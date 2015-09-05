state_picking_mouse = {
	time = 0, -- current remaining time
	size = 32,
	offsetx = 160,
	offsety = 130,
	berries = {},
	berries_count = 0, -- current count of berries left on the bush

	defaults = {
		time = 10,
		berries_count = 10,
	}
}

function state_picking_mouse:init ()
  self.time = self.defaults.time
	self.berries = {}
	self.berries_count = self.defaults.berries_count
  for i=1,self.berries_count do
		local r = -1
		repeat
			r = math.random(0,99);
		until not self.berries[r]
		self.berries[r] = true
	end
	love.mouse.setPosition( lg.getWidth() / 2, lg.getHeight() / 2 )
	love.mouse.setVisible(true)
end

function state_picking_mouse:quit ()
	love.mouse.setVisible(false)
end

function state_picking_mouse:draw ()
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(bigFont);
	local p = lg.getWidth()
	lg.printf(math.ceil(self.time) .. " s", p*0, 45, p*1, "center")

  for k,v in pairs(self.berries) do
  	self:rect(k, "fill")
  end

end

function state_picking_mouse:keypressed(key, unicode)
  if key == 'escape' then self:finished() end
end

function state_picking_mouse:mousepressed(x, y, button)
	local c = self:xytoc(x,y)
	print("click", x,y,c)
	if self.berries[c] then self:pick(c) end
end

function state_picking_mouse:update(dt)
  self.time = self.time - dt
  if(self.time<=0) then self:finished() end
	return true -- update underlying state
end

function state_picking_mouse:finished()
	game_state_pop()
end

function state_picking_mouse:pick(pos)
  self.berries[pos] = nil
  player.inventory:add("berries")
	-- TODO bush can have its own inventory with berries? :)
	self.berries_count = self.berries_count - 1
	if self.berries_count <= 0 then self:finished() end
end


function state_picking_mouse:ctox(c)
  return c%10*self.size+self.offsetx
end
function state_picking_mouse:ctoy(c)
  return math.floor(c/10)*self.size+self.offsety
end
function state_picking_mouse:xytoc(x, y)
	return (x<self.offsetx or x>self.offsetx+10*self.size or
            y<self.offsety or y>self.offsety+10*self.size) and -1 or
						math.floor((y - self.offsety) / self.size) * 10 + math.floor((x - self.offsetx) / self.size)
end
function state_picking_mouse:rect(c,mode)
  lg.setFont(textFont);
  lg.setColor(0,0,0)
	lg.printf(c, self:ctox(c), self:ctoy(c), self.size, "center")

	lg.setColor(205,255,255)
  lg.rectangle(mode, self:ctox(c), self:ctoy(c), self.size, self.size)
end
