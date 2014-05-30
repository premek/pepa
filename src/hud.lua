hud = {}

function hud:draw()


 local s = player.life.."% <3\n" .. 
	player.berries .. " B\n" .. 
	"$ " .. player.cash .. "\n" .. 
	player.laf .. " % L&F"
    
 love.graphics.setFont(textFont);

 love.graphics.setColor(0,0,0)
  love.graphics.print(s,11,11) 
 --love.graphics.setColor(0,0,0)
 -- love.graphics.print(s,10,10) 

end
