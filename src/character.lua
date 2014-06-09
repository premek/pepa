Character = {
        grid_x = 1,
        grid_y = 1,
        act_x = 1,
        act_y = 1,
	offset = {x=0, y=-20},
	facing = {x=0,y=1},
	anim_frame = 1,
        speed = 5,
	img = "chars",
	---

	msg = {txt="Nazdar!",cur_len=0, displayed_len=15, offset_x = 35, offset_y = 10},
	
	life = 100,
	berries = 0,
	cash = 100,
	laf = 100,
}

function Character:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end


function Character:load ()

  char = love.graphics.newImage( "img/".. self.img .. ".png" )
  chq = function(x,y) return love.graphics.newQuad(x,y, 36, 48, 113, 210); end
  ch = {[-1]={}, [0]={}, [1]={}}
  -- stand, step1, step2
  ch[0][-1] = {chq(40,8), chq(4,8), chq(40,8), chq(76,8)}
  ch[1][0] = {chq(40,56), chq(4,56), chq(40,56), chq(76,56)}
  ch[0][1] = {chq(40,104), chq(4,104), chq(40,104), chq(76,104)}
  ch[-1][0] = {chq(40,153), chq(4,153), chq(40,153), chq(76,153)}
end

function Character:face(x,y) 
	self.facing.x=x
	self.facing.y=y
end

function Character:say(t) 
	self.msg.txt = t
end

function Character:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.drawq(char, ch[self.facing.x][self.facing.y][self.anim_frame], self.act_x, self.act_y)

  love.graphics.setColor(0,0,0)
  love.graphics.setFont(textFont);
  love.graphics.print(string.sub(self.msg.txt, math.max(1,self.msg.cur_len - Character.msg.displayed_len), self.msg.cur_len), self.act_x+self.msg.offset_x, self.act_y+self.msg.offset_y) 
  --love.graphics.draw(img, top_left, 50, 50)
  -- v0.8:
  -- love.graphics.drawq(img, top_left, 50, 50)
end

p_dtotal = 0

function Character:update(dt)
	p_dtotal = p_dtotal + dt -- TODO nejaky helper / util

   if p_dtotal >= 0.10 then
      p_dtotal = p_dtotal - 0.10

if(Character.msg.txt ~= "") then
Character.msg.cur_len = Character.msg.cur_len + 1 --FIXME
if(Character.msg.cur_len > string.len(Character.msg.txt)+Character.msg.displayed_len) then -- time to read
Character.msg.txt = ""
Character.msg.cur_len = 0
end
end
end
end

function Character:warp(x,y)
    self.grid_x = x
    self.grid_y = y
    self.act_x = x * world.tile.w - world.tile.w + Character.offset.x
    self.act_y = y * world.tile.h - world.tile.h + Character.offset.y
end



function Character:step(x, y)

	local newx = self.grid_x + x
	local newy = self.grid_y + y

    print("Step from ", self.grid_x, self.grid_y, "to", newx, newy)

            self:face(x, y)

    if newy >0 and newy <= TiledMap_GetMapH() 
       and newx >0 and newx <= TiledMap_GetMapW()
       and TiledMap_GetMapTile(newx-1,newy-1,map_unwalkable_id)==0
       then
            self.grid_y = newy
            self.grid_x = newx
    else
     print("No no")
    end
--if TiledMap_GetMapTile(newx-1,newy-1,map_action_id) > 0 then
  --         action(newx, newy)
--end

  world:call_player_actions(newx, newy)

end

