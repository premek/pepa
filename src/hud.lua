hud = {}

function hud:draw()

  inventory:draw()


 local s = t("health", player.props.life) .. "\n" ..
	t("appearance", player.props.laf)

 love.graphics.setFont(textFont);

 love.graphics.setColor(60,60,60)
  love.graphics.print(s,11,11)
 --love.graphics.setColor(0,0,0)
 -- love.graphics.print(s,10,10)



end
