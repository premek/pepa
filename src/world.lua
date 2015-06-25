
world = {}

world.tile = {w=32, h=32}

world.current_map = maps.map01

world.cam = {x = love.graphics.getWidth()/2, y = love.graphics.getHeight()/2}

function world:set_map(map, px, py)
  TiledMap_Load("map/"..map.filename..".tmx")
  map_unwalkable_id = TiledMap_GetLayerZByName("unwalkable") or error("missing layer")
  --map_action_id = TiledMap_GetLayerZByName("action") or error("missing layer")
  self.current_map = map
  for i,o in pairs(map.objects) do o:load(); end
  player:warp(px,py)
end

-- TODO nebo rovnou nejak primo at se pokazde neprohledava vsechno?
function world:call_player_actions(x, y)
  for k,a in ipairs(self.current_map.actions) do
    if x==a[1] and y == a[2] then
      print ("calling action", self.current_map.filename, x, y)
      a[3]()
    end
  end
end

function world:draw ()
  love.graphics.setColor(255,255,255)
  TiledMap_DrawNearCam(self.cam.x, self.cam.y)
  for i,o in pairs(self.current_map.objects) do o:draw(); end

end
