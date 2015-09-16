Counter = {}


function Counter:new(fn)
  return Counter:newInterval(0, fn)
end

function Counter:newInterval(interval, fn)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  -------------------------
  o.current = 0
  o.interval = interval
  o.fn = fn
  return o
end

function Counter:reset()
  self.current = 0
end

function Counter:update(dt, ...)
  self.current = self.current + dt
  -- when interval is 0, fn is called every time and current is not restarted
  if self.current >= self.interval then
    self.current = self.current - self.interval
    self.fn(self.current, ...)
  end
end
