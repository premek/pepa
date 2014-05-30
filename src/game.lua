
game = {}
game.state = {
	paused = state_paused,
	menu = state_menu,
	playing = state_playing,
}
game.current_state = game.state.playing -- TODO stack

function game:pause(p) 
	self.current_state = p and self.state.paused or self.state.playing
end
function game:toggle_pause() 
	self:pause(self.current_state ~= self.state.paused)
end
