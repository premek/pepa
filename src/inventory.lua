Inventory = {}

function Inventory:new(o)
  local o = o or {}
  print("creating inventory", o)
  setmetatable(o, self)
  self.__index = self
  -------------------------
  return o
end

function Inventory:add(thing, amount)
  amount = amount or 1
  if(self[thing]==nil) then self[thing] = 0; end

  if(self[thing] + amount < 0) then
    print("negative amount of things", thing, amount, self[thing], self[thing]+amount)
    return false
  end

  print("adding to inventory", thing, amount, self[thing], self[thing]+amount)
  self[thing] = self[thing] + amount
  return true
end

function Inventory:remove(thing, amount)
  amount = amount or 1
  return self:add(thing, -amount)
end

function Inventory:contains(thing, amount)
  amount = amount or 1
  return self[thing] and self[thing] >= amount;
end



function Inventory:draw(title,x,y,align)
  local width = 200
  x=x or 640-11-width
  y=y or 11
  align = align or "right"
  title = title or (t("inventory") .. " ('I')")

  love.graphics.setFont(textFont);
  love.graphics.setColor(60,60,60)

  local s = title.."\n----------\n"
  for item, amount in pairs(self) do
    if(type(amount) == "number" and amount > 0) then
      s = s .. t(item, amount) .. " x" .. amount .. "\n"
    end
  end

  love.graphics.printf(s, x, y, width, align)
end
