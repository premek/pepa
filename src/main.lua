
require "map"
require "menu"
require "player"
require "hud"


require "state_playing"
require "state_paused"

require "game"


love.filesystem.load("tiledmap.lua")()
gCamX,gCamY = love.graphics.getWidth()/2, love.graphics.getHeight()/2

love.mouse.setVisible(false)



function love.load()
  map:set("map01", 13, 10)
  
  bigFont = love.graphics.newFont("font/Bohemian typewriter.ttf", 60);
  textFont = love.graphics.newFont("font/Bohemian typewriter.ttf", 15);

  player.load()
end



function love.keypressed(key, unicode)
	if(game.current_state.keypressed) then game.current_state:keypressed(key, unicode); end

   if key == 'p' then
      game:toggle_pause()
   end

   if key == 'q' then
	love.event.quit() 
   end


end

function love.draw()
	if(game.current_state.draw) then game.current_state:draw(); end
end



function love.update(dt)
   if(game.current_state.update) then game.current_state:update(dt); end
end

function love.focus(f)
  game:pause( not f )
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end


