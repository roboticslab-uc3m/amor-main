-- loading lua-yarp binding library
require("yarp")

local SensorDataProcessor = {}

SensorDataProcessor.new = function(self, processor)
    local obj = {
        accumulator = "",
        dataReady = false,
        currentSensorData = nil,
        processor = processor
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

SensorDataProcessor.accept = function(self, str)
    str = str or ""
    self.accumulator = self.accumulator .. str
    self:tryConsume()
end

SensorDataProcessor.tryConsume = function(self)
    if self.processor.evaluateCondition(self.accumulator) then
        self.currentSensorData, self.accumulator = self.processor.process(self.accumulator)

        if self.currentSensorData then
            self.dataReady = true
        end
    end
end

local createMeanProcessor = function(properties)
    local invalidValue = tonumber(string.rep("F", properties.hexSize), 16)
    --local separators = {"\r\n", "\n", "\r"}
    --local storage = {}

    local extractMessages = function(str)
        local lines = {}

        for line in string.gmatch(str, "%S+") do
            table.insert(lines, line)
        end

        return lines
    end

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

    local calculateMean = function(...)
        if arg.n == 0 then return 0 end
        local sum = 0

        for i, value in ipairs(arg) do
            sum = sum + value
        end

        return math.floor(sum / arg.n)
    end

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

    local evaluateCondition = function(str)
        local id = properties.parts[1]
        local n = str:find(id, 1, true)
        return n and str:find(id, n + 1, true) ~= nil or false
    end

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
-- create is called when the port monitor is created
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
-- destroy is called when port monitor is destroyed
--
PortMonitor.destroy = function()
    print("DESTROYING PORT MONITOR")
    sensorDataProcessor = nil
end

--
-- accept is called when the port receives new data
-- @param thing The Things abstract data type
-- @return Boolean
-- if false is returned, the data will be ignored
-- and update() will never be called
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
-- update is called when the port receives new data
-- @param thing The Things abstract data type
-- @return Things
--
PortMonitor.update = function(thing)
    print("in update")
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
