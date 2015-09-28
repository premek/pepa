hud = {}

function hud:draw()
  player.inventory:draw()
  local s = t("health", player.props.life) .. "\n" ..
  t("appearance", player.props.laf) .. "\n"

  love.graphics.setFont(textFont);
  love.graphics.setColor(60,60,60)
  love.graphics.print(s,11,11)
end