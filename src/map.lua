map = {}

map.tile = {w=32, h=32}

function map:set(name, px, py)
    TiledMap_Load("map/"..name..".tmx")
    map_unwalkable_id = TiledMap_GetLayerZByName("unwalkable") or error("missing layer")
    map_action_id = TiledMap_GetLayerZByName("action") or error("missing layer")
player.grid_x = px
player.grid_y = py
player.act_x = px * self.tile.w - self.tile.w + player.offset.x
player.act_y = py * self.tile.h - self.tile.h + player.offset.y

end

map.draw = function () 
	love.graphics.setColor(255,255,255)

    TiledMap_DrawNearCam(gCamX,gCamY)
end

