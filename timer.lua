local Timer = {}

function Timer.new(limit)
    local self = {}
    setmetatable(self, {__index = Timer})

    self.limit = limit
    self.currentTime = limit

    return self
end

function Timer:ready(dt)
    local time = self.currentTime - dt
    self.currentTime = time

    if time <= 0 then
        self.currentTime = self.currentTime + self.limit
        return true
    else
        return false
    end
end

function Timer:time(time)
    if time then
        self.currentTime = time
    end

    return self.currentTime
end

return Timer
