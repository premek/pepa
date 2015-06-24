
game = {}
game.state = state_playing -- TODO stack

function game:start(state)
  if(state.init) then state:init(); end
  self.state = state
end

function game:pause(p)
	state_paused = p and self.start(state_paused) or self.start(state_playing)
end
function game:toggle_pause()
	self:pause(self.state ~= state_paused)
end
