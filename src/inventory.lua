inventory = {clothes=0, dirt = 0, elegant_beard = 0, homeless_beard=0, berries=3, monies=100}

function inventory:add(thing, amount)
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

function inventory:remove(thing, amount)
  amount = amount or 1
  return self:add(thing, -amount)
end

function inventory:contains(thing, amount)
  amount = amount or 1
  return self[thing] and self[thing] >= amount;
end



function inventory:draw()

 love.graphics.setFont(textFont);
 love.graphics.setColor(60,60,60)

 local width = 200
 local s = "Inventory:\n----------\n"

 for item, amount in pairs(self) do
   if(type(amount) == "number" and amount > 0) then
     if(amount>1) then s= s .. amount .. "x " end
     s = s .. item .. "\n"
   end
 end

 love.graphics.printf(s, 640-11-width, 11, width, "right")
end
