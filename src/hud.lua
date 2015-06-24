hud = {}

function hud:draw()

  inventory:draw()


 local s = player.life.."% <3\n" ..
	"$ " .. player.cash .. "\n" ..
	player.laf .. " % L&F"

 love.graphics.setFont(textFont);

 love.graphics.setColor(60,60,60)
  love.graphics.print(s,11,11)
 --love.graphics.setColor(0,0,0)
 -- love.graphics.print(s,10,10)



end
