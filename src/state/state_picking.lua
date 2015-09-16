state_picking = {
	time = 0, -- current remaining time
	size = 32,
	offsetx = 160,
	offsety = 130,
	cursor = 0,
	speed = 10,
	berries = {},
}

function state_picking:init ()
	self.time = 10 -- current remaining time
	self.cursor = 0
	for i=1,10 do self.berries[math.random(0,99)] = true end
end

function state_picking:draw ()
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(bigFont);
	local p = lg.getWidth()
	lg.printf(math.ceil(self.time) .. " s", p*0, 45, p*1, "center")

	for k,v in pairs(self.berries) do
		self:rect(k, "fill")
	end

	for a=0,99 do
		self:rect(a, "line")
	end

	self:rect(math.floor(self.cursor), "fill")


end

function state_picking:ctox(c)
	return (c%10 * (math.floor(c%20/10)*(-2)+1) + math.floor(c%20/10)*9) * self.size+self.offsetx
end
function state_picking:ctoy(c)
	return math.floor(c/10)*self.size+self.offsety
end
function state_picking:rect(c,mode)
	love.graphics.setFont(textFont);
	lg.printf(c, self:ctox(c), self:ctoy(c), self.size, "center")
	lg.rectangle(mode, self:ctox(c), self:ctoy(c), self.size, self.size)
end


function state_picking:keypressed(key, unicode)
	if key == ' ' then
		if self.berries[math.floor(self.cursor)] then self:pick(math.floor(self.cursor)) end
	end

end

function state_picking:update(dt)
	self.cursor = (self.cursor + dt*self.speed) % 100
	self.time = self.time - dt
	print(self.time)
	if(self.time<=0) then
		print ("pop")
		game_state_pop()
		print(#game_state)
	end
	return true -- update underlying state
end

function state_picking:pick(pos)
	self.berries[pos] = nil
	player.inventory.berries = player.inventory.berries + 1;
end
