state_sleeping = {
	time = 0, -- current remaining time
	defaults = {
		time = 1,
	},
	gains = {
		life = 20,
		dirt = 1,
	}
}

function state_sleeping:init ()
	self.time = self.defaults.time
end

function state_sleeping:draw ()
	lg.setColor(0,0,0,200)
  lg.rectangle("fill",0,0,lg.getWidth(), lg.getHeight())
	lg.setColor(255,255,255)
	lg.setFont(textFont);
	local y = math.floor(lg.getHeight() / 2)+0.5
	lg.printf("Zzz...", lg.getWidth()/2, y-30, 0, "center")
	lg.line(0, y, lg.getWidth() * (self.time/self.defaults.time), y)
end

function state_sleeping:update(dt)
	self.time = self.time - dt
	if(self.time<=0) then self:finished() end
	--return true -- update underlying state
end

function state_sleeping:finished()
	player.props:add("life", self.gains.life)
	player.props:add("dirt", self.gains.dirt)
	game_state_pop()
end
