hud = {}

function hud:draw()
  player.inventory:draw()
  player.props:draw("", 11,11, "left")

end
