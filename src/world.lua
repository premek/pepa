
world = {}

world.tile = {w=32, h=32}

world.current_map = maps.map03

world.cam = {x = love.graphics.getWidth()/2, y = love.graphics.getHeight()/2}

function world:set_map(map, px, py)
  TiledMap_Load("map/"..map.filename..".tmx")
  --map_action_id = TiledMap_GetLayerZByName("action") or error("missing layer")
  self.current_map = map

  self.current_map.unwalkable_id = self.current_map.unwalkable_id or
    TiledMap_GetLayerZByName("unwalkable") or error("missing layer")

  for i,o in pairs(map.objects) do
    o:load()
    o:warp() --FIXME?
   end
  player:warp(px,py)
end

-- TODO nebo rovnou nejak primo at se pokazde neprohledava vsechno?
function world:interact(actor, x, y, previousx, previousy)
  for k,a in ipairs(self.current_map.actions) do
    if x==a[1] and y == a[2] then
      print ("calling action", self.current_map.filename, x, y, previousx, previousy)
      a[3](x, y, previousx, previousy)
    end
  end
  for k,obj in ipairs(self.current_map.objects) do
    if x==obj.x and y == obj.y then
      print ("interacting object", self.current_map.filename, x, y, previousx, previousy)
      obj:interact(actor)
    end
  end
end

function world:draw ()
  love.graphics.setColor(255,255,255)
  TiledMap_DrawNearCam(self.cam.x, self.cam.y)
  for i,o in pairs(self.current_map.objects) do o:draw(); end

end

function world:isWalkable(x,y)
  if y > 0 and y <= TiledMap_GetMapH()
  and x >0 and x <= TiledMap_GetMapW()
  and TiledMap_GetMapTile(x-1,y-1,self.current_map.unwalkable_id)==0 then

    for k,obj in ipairs(self.current_map.objects) do
      if x==obj.x and y == obj.y and obj.walkable ~= nil and not obj.walkable then
        print("Unwalkable object", x, y)
        return false
      end
    end
    return true
  else
    return false
  end
end
