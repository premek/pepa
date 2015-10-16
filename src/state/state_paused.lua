state_paused = {}

function state_paused:draw ()
  love.graphics.setColor(0,0,0,200)
  love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setColor(255,255,255)
  love.graphics.setFont(bigFont);
  love.graphics.printf("Paused", 0,love.graphics.getWidth()/4, love.graphics.getWidth(), "center")
  return true
end

function state_paused:keypressed(key, unicode)
  if key == 'escape' or key == 'p' then
    game_state_pop()
  end
end

function state_paused:update () return false end -- do not update lower states
