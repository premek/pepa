require "lib/require"
require "util"
require "counter"
require "lang"

require "mainmenu"


require "inventory"
require "character"
require "npc"
require "storage"
require "player"


require "maps"
require "world"
require "menu"
require "hud"

require.tree("state")

math.randomseed(os.time()); math.random(); math.random(); math.random(); -- wft



game_state = {state_playing}

game_state_push = function (state) -- TODO arguments
  if state.init then state:init() end
  table.insert(game_state, state)
end
game_state_pop = function ()
  local state = table.remove(game_state)
  if state.quit then state:quit() end
end


lg = love.graphics


love.filesystem.load("lib/tiledmap.lua")()

love.mouse.setVisible(false)

-----------XXXXXXXXXXXX
--state_picking_mouse:init()

function love.load()
  world:set_map(maps.main, 16, 10) -- FIXME where
  --world:set_map(maps.inn, 9, 10) -- FIXME where
  --world:set_map(maps.bank, 8,13) -- FIXME where

  bigFont = love.graphics.newFont("font/Bohemian typewriter.ttf", 60);
  textFont = love.graphics.newFont("font/Bohemian typewriter.ttf", 15);

  player:load()
  state_picking_mouse:load()
  -- npc:load()


end



function love.keypressed(key, unicode)
  --if key == "rctrl" then
--      debug.debug()
--  end

  for i=#game_state,1,-1 do
    if(game_state[i].keypressed) then
      if not game_state[i]:keypressed(key, unicode) then return end
    end
  end
end

function love.mousepressed(x, y, button)
  for i=#game_state,1,-1 do
    if(game_state[i].mousepressed) then
      if not game_state[i]:mousepressed(x, y, button) then return end
    end
  end
end

function love.draw()
  -- if one of the states is fullscreen, draw only from that one upwards
  local from = 1
  for i=#game_state,1,-1 do
    if(game_state[i].fullscreen) then from = i end
  end
  for i=from, #game_state do
    if(game_state[i].draw) then game_state[i]:draw() end
  end
end



function love.update(dt)
  -- update the top state
  -- If it returns false, do NOT update the lower one, etc...
  for i=#game_state,1,-1 do
    if(game_state[i].update) then
      if not game_state[i]:update(dt) then return end
    end
  end
end

function love.focus(f)
  --  game:pause( not f )
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
