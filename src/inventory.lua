inventory = {clothes=0, beard=1, berries=3}

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
