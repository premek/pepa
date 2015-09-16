state_playing = {
  fullscreen = true -- do not draw underlying states
}

function state_playing:draw ()
  love.graphics.setColor(255,255,255)
  world:draw()
  player:draw()
  hud:draw()
end

function state_playing:keypressed(key, unicode)
  if key == 'escape' then
    state_menu.menu = mainmenu
    game_state_push(state_menu)
  end

  if key == 'p' then
    game_state_push(state_paused)
  end

  if love.keyboard.isDown('t') then
    player:say("meteor shower... a gentle wave wets our sandals")
  end

  if love.keyboard.isDown('up') then
    player:step(0, -1)
  end
  if love.keyboard.isDown('down') then
    player:step(0, 1)
  end
  if love.keyboard.isDown('left') then
    player:step(-1, 0)
  end
  if love.keyboard.isDown('right') then
    player:step(1, 0)
  end
end



function state_playing:update(dt)
  player:update(dt)
end
