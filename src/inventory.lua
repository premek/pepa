Inventory = {}

function Inventory:new(o)
  o = o or {}
  print("creating inventory", o)
  setmetatable(o, self)
  self.__index = self
  -------------------------
  o.clothes = o.clothes or 1
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



function Inventory:draw()

 love.graphics.setFont(textFont);
 love.graphics.setColor(60,60,60)

 local width = 200
 local s = t("inventory") .. "\n----------\n"

 for item, amount in pairs(self) do
   if(type(amount) == "number" and amount > 0) then
     if(amount>1) then s= s .. amount .. "x " end
     s = s .. t(item, amount) .. "\n"
   end
 end

 love.graphics.printf(s, 640-11-width, 11, width, "right")
end
