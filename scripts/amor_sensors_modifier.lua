-- loading lua-yarp binding library
require("yarp")

-- Lua 5.2 lacks a global 'unpack' function
local unpack = table.unpack or unpack

local SensorDataProcessor = {}

--
-- Creates a SensorDataProcessor instance.
--
-- @param processor Table of input parameters
--
-- @return SensorDataProcessor
--
SensorDataProcessor.new = function(self, processor)
    local obj = {
        accumulator = "",
        dataReady = false,
        currentSensorData = nil,
        processor = processor,
        stamp = 0
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

--
-- Consumes fetched data from sensors.
--
-- @param str String of new data to be appended to the accumulator
--
SensorDataProcessor.accept = function(self, str)
    str = str or ""
    self.accumulator = self.accumulator .. str
    self:tryConsume()
end

--
-- Calls further processing methods if conditions are satisfied,
-- sets flag if data is ready to be forwarded to receiver.
--
SensorDataProcessor.tryConsume = function(self)
    if self.processor.evaluateCondition(self.accumulator) then
        self.currentSensorData, self.accumulator = self.processor.process(self.accumulator)

        if self.currentSensorData then
            self.dataReady = true
            self.stamp = self.stamp + 1
        end
    end
end

--
-- Get current stamp (incremented after data is ready on each iteration).
--
-- @return Number
--
SensorDataProcessor.getStamp = function(self)
    return self.stamp
end

--
-- Factory function, creates a mean SensorDataProcessor.
--
-- @param properties Table of input parameters
-- @param properties.parts String identifier for main data streams (arm, elbow, hand)
-- @param properties.subparts String identifier for secondary data streams (X, Y, Z)
-- @param properties.hexValues Number of hexadecimal values contained in a single data stream
-- @param properties.hexSize Number of characters a hexValue is comprised of
--
-- @return Table of output parameters
-- @return Table.evaluateCondition Function, see docs below
-- @return Table.process Function, see docs below
--
local createMeanProcessor = function(properties)
    -- identifier for invalid input values
    local invalidValue = tonumber(string.rep("F", properties.hexSize), 16)
    --local separators = {"\r\n", "\n", "\r"}
    --local storage = {}

    --
    -- Splits input into lines.
    --
    -- @param str String of raw data, contains newline characters.
    --
    -- @return Table
    --
    local extractMessages = function(str)
        local lines = {}

        for line in string.gmatch(str, "%S+") do
            table.insert(lines, line)
        end

        return lines
    end

    --
    -- Groups (by part/subpart) and sorts input data table.
    --
    -- @param lines Table of full message data (parts + subparts)
    --
    local preprocessMessages = function(lines)
        local temp = {}
        local n = 0
        local nparts, nsubparts = #properties.parts, #properties.subparts
        if #lines ~= nparts * (nsubparts + 1) then return end

        for i = 1, #properties.parts do
            n = n + 1
            local ttemp = {}
            table.insert(ttemp, lines[n])

            for j = 1, #properties.subparts do
                n = n + 1
                table.insert(ttemp, lines[n])
            end
            
            table.insert(temp, ttemp)
        end

        table.sort(temp, function(a, b)
            return a[1] < b[1]
        end)

        for i, v in ipairs(lines) do lines[i] = nil end

        for i, part in ipairs(temp) do
            for j, subpart in ipairs(part) do
                table.insert(lines, subpart)
            end
        end
    end

    --
    -- Tokenizes input string into elements of constant width.
    --
    -- @param str input String
    -- @param n Number of characters each token is comprised of
    --
    -- @return Table of split tokens
    --
    local splitString = function(str, n)
        n = math.floor(n or 0)
        if n <= 0 then return {""} end
        local t = {}

        for i = 1, math.floor(str:len() / n) do
            local start = 1 + n * (i - 1)
            table.insert(t, str:sub(start, start + n - 1))
        end

        return t
    end

    --
    -- Calculates arithmetic mean of input data.
    --
    -- @param varargs of input Numbers
    --
    -- @return Number as arithmetic mean of input data
    --
    local calculateMean = function(...)
        if select('#', ...) == 0 then return 0 end
        local sum = 0

        for i, value in ipairs({...}) do
            sum = sum + value
        end

        return math.floor(sum / select('#', ...))
    end

    --
    -- Extracts sensor value from sanitized streams and applies selected algorithm.
    --
    -- @param Table of preprocessed message Strings.
    --
    -- @return Table
    --
    local doWork = function(lines)
        local nline = 0
        local storage = {}

        for i, part in ipairs(properties.parts) do
            nline = nline + 1
            local line = lines[nline]
            if not line or line ~= part then return nil end
            local partArray = {}

            for j, subpart in ipairs(properties.subparts) do
                nline = nline + 1
                line = lines[nline]
                if not line or line:sub(1, 1) ~= subpart then return nil end
                local substring = line:sub(2)
                if substring:len() ~= properties.hexValues * properties.hexSize then return nil end
                local thex = splitString(substring, properties.hexSize)
                if #thex ~= properties.hexValues then return nil end

                for k, hexString in ipairs(thex) do
                    local dec = tonumber(hexString, 16)
                    if not dec then return nil end
                    if dec == invalidValue then dec = 0 end
                    local tuple = partArray[k] or {}
                    table.insert(tuple, dec)

                    if not partArray[k] then
                        table.insert(partArray, tuple)
                    end
                end
            end

            for k, tuple in ipairs(partArray) do
                partArray[k] = calculateMean(unpack(tuple))
            end

            table.insert(storage, partArray)
        end

        return storage
    end

    --
    -- Tests whether provided string represents a complete stream of data (all parts and subparts).
    --
    -- @param str Input String
    --
    -- @return Boolean
    --
    local evaluateCondition = function(str)
        local id = properties.parts[1]
        local n = str:find(id, 1, true)
        return n and str:find(id, n + 1, true) ~= nil or false
    end

    --
    -- Main execution block, processes raw data.
    --
    -- @param str String of raw data accumulated by the processor in previous iterations
    --
    -- @return Table
    -- @return Table[1] Table of parsed messages
    -- @return Table[2] String of accumulated data by this iteration
    --
    local process = function(str)
        local id = properties.parts[1]
        local first = str:find(id, 1, true)
        local second = str:find(id, first + 1, true)
        local substring = str:sub(first, second - 1)
        local lines = extractMessages(substring)
        preprocessMessages(lines)
        return doWork(lines), str:sub(second)
    end

    return {
        evaluateCondition = evaluateCondition,
        process = process
    }
end

local sensorDataProcessor

--
-- Method called when the port monitor is created.
--
-- @param options
--
-- @return Boolean
--
PortMonitor.create = function(options)
    print("INITIALIZING AMOR SENSORS")
    -- TODO: read options from .ini file
    local meanProcessor = createMeanProcessor{
        parts = {"I", "J", "K"},
        subparts = {"X", "Y", "Z"},
        hexValues = 16,
        hexSize = 3
    }
    sensorDataProcessor = SensorDataProcessor:new(meanProcessor)
    return true;
end

--
-- Method called when port monitor is destroyed.
--
PortMonitor.destroy = function()
    print("DESTROYING PORT MONITOR")
    sensorDataProcessor = nil
end

--
-- Method called when the port receives new data.
-- If false is returned, the data will be ignored
-- and update() will never be called.
--
-- @param thing The Things abstract data type
--
-- @return Boolean
--
PortMonitor.accept = function(thing)
    bt = thing:asBottle()

    if bt == nil then
        print("bot_modifier.lua: got wrong data type (expected type Bottle)")
        return false
    end

    sensorDataProcessor:accept(bt:get(0):asString())
    return sensorDataProcessor.dataReady
end

--
-- Method called to forward processed data.
--
-- @param thing The Things abstract data type
--
-- @return Things
--
PortMonitor.update = function(thing)
    print(string.format("in update [%d]", sensorDataProcessor:getStamp()))
    sensorDataProcessor.dataReady = false
    local vec = yarp.Vector()

    for i, part in ipairs(sensorDataProcessor.currentSensorData) do
        for j, decValue in ipairs(part) do
            vec:push_back(decValue)
        end
    end

    thing:setPortWriter(vec)
    return thing
end
