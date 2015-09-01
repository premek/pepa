require "util"
require "lang"

require "inventory"
require "character"
require "npc"
require "player"

require "mainmenu"

require "maps"
require "world"
require "menu"
require "hud"


require "state_playing"
require "state_menu"
require "state_paused"
require "state_picking"

require "game"


lg = love.graphics


love.filesystem.load("tiledmap.lua")()

love.mouse.setVisible(false)



function love.load()
  --world:set_map(maps.main, 13, 10) -- FIXME where
  world:set_map(maps.bank, 8,13) -- FIXME where

  bigFont = love.graphics.newFont("font/Bohemian typewriter.ttf", 60);
  textFont = love.graphics.newFont("font/Bohemian typewriter.ttf", 15);

  player:load()
 -- npc:load()
end



function love.keypressed(key, unicode)
	if(game.state.keypressed) then game.state:keypressed(key, unicode); end

   if key == 'p' then
      game:toggle_pause()
   end

   if key == 'q' then
	love.event.quit()
   end


end

function love.draw()
	if(game.state.draw) then game.state:draw(); end
end



function love.update(dt)
   if(game.state.update) then game.state:update(dt); end
end

function love.focus(f)
--  game:pause( not f )
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
