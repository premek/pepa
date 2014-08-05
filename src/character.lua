Character = {}
Character.__index = Character

function Character:new (img)
	local s = setmetatable({}, Character)
        s.grid_x = 1
        s.grid_y = 1
        s.act_x = 1
        s.act_y = 1
	s.offset = {x=0, y=-20}
	s.facing = {x=0,y=1}
	s.anim_frame = 1
        s.speed = 5
	s.img = img or "npc1"
	s.msg = {txt="Nazdar!",cur_len=0, displayed_len=15, offset_x = 35, offset_y = 10}
	
	s.life = 100
	s.berries = 0
	s.cash = 100
	s.laf = 100

  return s
end


function Character:load ()

  self.char = love.graphics.newImage( "img/".. self.img .. ".png" )
  local chq = function(x,y) return love.graphics.newQuad(x,y, 36, 48, 113, 210); end
  self.ch = {[-1]={}, [0]={}, [1]={}}
  -- stand, step1, step2
  self.ch[0][-1] = {chq(40,8), chq(4,8), chq(40,8), chq(76,8)}
  self.ch[1][0] = {chq(40,56), chq(4,56), chq(40,56), chq(76,56)}
  self.ch[0][1] = {chq(40,104), chq(4,104), chq(40,104), chq(76,104)}
  self.ch[-1][0] = {chq(40,153), chq(4,153), chq(40,153), chq(76,153)}
  print (self.img .. " loaded")
end

function Character:face(x,y) 
	self.facing.x=x
	self.facing.y=y
end

function Character:say(t) 
	self.msg.txt = t
	self.msg.cur_len = 0
end

function Character:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(self.char, self.ch[self.facing.x][self.facing.y][self.anim_frame], self.act_x, self.act_y)

  love.graphics.setColor(0,0,0)
  love.graphics.setFont(textFont);
  love.graphics.print(string.sub(self.msg.txt, math.max(1,self.msg.cur_len - self.msg.displayed_len), self.msg.cur_len), self.act_x+self.msg.offset_x, self.act_y+self.msg.offset_y) 
  --love.graphics.draw(img, top_left, 50, 50)
  -- v0.8:
  -- love.graphics.drawq(img, top_left, 50, 50)
end

p_dtotal = 0

function Character:update(dt)
	p_dtotal = p_dtotal + dt -- TODO nejaky helper / util

   if p_dtotal >= 0.10 then
      p_dtotal = p_dtotal - 0.10

if(self.msg.txt ~= "") then
self.msg.cur_len = self.msg.cur_len + 1 --FIXME
if(self.msg.cur_len > string.len(self.msg.txt)+self.msg.displayed_len) then -- time to read
self.msg.txt = ""
self.msg.cur_len = 0
end
end
end
end

function Character:warp(x,y)
    self.grid_x = x
    self.grid_y = y
    self.act_x = x * world.tile.w - world.tile.w + self.offset.x
    self.act_y = y * world.tile.h - world.tile.h + self.offset.y
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

