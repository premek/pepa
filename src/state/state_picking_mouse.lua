state_picking_mouse = {
	img = {},
	time = 0, -- current remaining time
	berries = {},
	berries_count = 0, -- current count of berries left on the bush
	defaults = {
		time = 10,
		berries_count = 10,
	},
	gains = {
		life = -20,
		dirt = 20,
	}
}

function state_picking_mouse:load ()
	self.img.cursor = love.mouse.getSystemCursor("hand")
  --	cursor = love.mouse.newCursor("pig.png", 0, 0)

	self.img.bg = {}
	self.img.bg.g = love.graphics.newImage( "img/bg.png" )
	self.img.bg.w = self.img.bg.g:getWidth()
	self.img.bg.h = self.img.bg.g:getHeight()

	self.img.berry = {}
	self.img.berry.g = love.graphics.newImage( "img/berry.png" )
	self.img.berry.w = self.img.berry.g:getWidth()
	self.img.berry.h = self.img.berry.g:getHeight()
	self.img.berry.size = self.img.bg.w / 10

	self.img.offsetx = lg:getWidth() / 2 - self.img.bg.w / 2
	self.img.offsety = lg:getHeight() / 2 - self.img.bg.h / 2
end

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
	love.mouse.setCursor(self.img.cursor)
	love.mouse.setPosition( lg.getWidth() / 2, lg.getHeight() / 2 )
	love.mouse.setVisible(true)
end

function state_picking_mouse:quit ()
	love.mouse.setVisible(false)
	love.mouse.setCursor()
end

function state_picking_mouse:draw ()
	lg.setColor(0,0,0,150)
  lg.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())

	lg.setColor(255,255,255)
	lg.draw(self.img.bg.g, self.img.offsetx, self.img.offsety)

	for k,v in pairs(self.berries) do
		local x = k%10*self.img.berry.size+self.img.offsetx
		local y = math.floor(k/10)*self.img.berry.size+self.img.offsety
		lg.draw(self.img.berry.g, x, y, 0, self.img.berry.size/self.img.berry.w)
	end

	lg.setColor(255,255,255)
	love.graphics.setFont(bigFont);
	local p = lg.getWidth()
	lg.printf(math.ceil(self.time) .. " s", p*0, 25, p*1, "center")

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
	player.props:add("life", self.gains.life)
	player.props:add("dirt", self.gains.dirt)
	game_state_pop()
end

function state_picking_mouse:pick(pos)
	self.berries[pos] = nil
	player.inventory:add("berries")
	-- TODO bush can have its own inventory with berries? :)
	self.berries_count = self.berries_count - 1
	if self.berries_count <= 0 then self:finished() end
end



function state_picking_mouse:xytoc(x, y)
	return (x<self.img.offsetx or x>self.img.offsetx+10*self.img.berry.size or
	y<self.img.offsety or y>self.img.offsety+10*self.img.berry.size) and -1 or
	math.floor((y - self.img.offsety) / self.img.berry.size) * 10
	+ math.floor((x - self.img.offsetx) / self.img.berry.size)
end
