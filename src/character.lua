Character = {}

function Character:new (o)
  o = o or {}
  print("creating character", o.img, o)
  setmetatable(o, self)
  self.__index = self
  -- TODO understand lua metatables, __index. etc.

  o.facing = {x=0,y=1}
  o.speed=5
  o.dirtratio = 0.004 -- TODO realtime or "turn based" over the night?

  o.grid_x = 1
  o.grid_y = 1
  o.act_x = o.act_x or 1
  o.act_y = o.act_y or 1
	o.offset = {x=0, y=-20}
	o.anim_frame = 1
	--o.img = o.img or "npc1"
	o.msg = {txt="",cur_len=0, displayed_len=15, offset_x = 35, offset_y = 10}
  o.props = {life = 100, laf=50}
	o.inventory = Inventory:new(o.inventory)

  return o
end


function Character:load ()

	self.char = love.graphics.newImage( "img/".. self.img .. ".png" )
	-- FIXME
	self.charnaked = love.graphics.newImage( "img/chars-naked.png" )

  local chq = function(x,y) return love.graphics.newQuad(x,y, 36, 48, 113, 210); end
  self.ch = {[-1]={}, [0]={}, [1]={}}
  -- stand, step1, step2
  self.ch[0][-1] = {chq(40,8), chq(4,8), chq(40,8), chq(76,8)}
  self.ch[1][0] = {chq(40,56), chq(4,56), chq(40,56), chq(76,56)}
  self.ch[0][1] = {chq(40,104), chq(4,104), chq(40,104), chq(76,104)}
  self.ch[-1][0] = {chq(40,153), chq(4,153), chq(40,153), chq(76,153)}
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
	local variant = self.inventory.clothes>0 and self.char or self.charnaked;
  love.graphics.draw(variant, self.ch[self.facing.x][self.facing.y][self.anim_frame], self.act_x, self.act_y)

  love.graphics.setColor(0,0,0)
  love.graphics.setFont(textFont);
  love.graphics.print(string.sub(self.msg.txt, math.max(1,self.msg.cur_len - self.msg.displayed_len), self.msg.cur_len), self.act_x+self.msg.offset_x, self.act_y+self.msg.offset_y)
  --love.graphics.draw(img, top_left, 50, 50)
  -- v0.8:
  -- love.graphics.drawq(img, top_left, 50, 50)
end

--FIXME globals?
p_dtotal = 0
beardtime = 0
newdirt = 0
dtotal = 0

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

  beardtime = beardtime + dt -- TODO nejaky helper / util
    if beardtime >= 90 then
      if(not self.inventory:contains("homeless_beard")) then
        self.inventory:remove("elegant_beard")
        self.inventory:add("homeless_beard")
      end
    else if beardtime >= 30 then
      if(not self.inventory:contains("elegant_beard")) then self.inventory:add("elegant_beard"); end
    end
  end

  newdirt = newdirt + dt*self.dirtratio
  if newdirt > 1 then newdirt = 0; self.inventory:add("dirt"); end

  self.props.laf = math.max(0, math.min(100, 50
    +10*self.inventory.elegant_beard
    -20*self.inventory.dirt
    -30*self.inventory.homeless_beard
    +40*self.inventory.clothes
  ))


  	dtotal = dtotal + dt

  local oldy = self.act_y
  local oldx = self.act_x

  	--FIXME
      self.act_y = self.act_y - math.floor((self.act_y - self.grid_y*world.tile.h + world.tile.h - self.offset.y) * self.speed * dt)
      self.act_x = self.act_x - math.floor((self.act_x - self.grid_x*world.tile.w + world.tile.w - self.offset.x) * self.speed * dt)

     if dtotal >= 0.2 then
        dtotal = dtotal - 0.2   -- reduce our timer by a second, but don't discard the change... what if our framerate is 2/3 of a second?


  if(self.act_y ~=oldy or self.act_x ~= oldx) then
  self.anim_frame = self.anim_frame % #self.ch[0][1] + 1 -- FIXME
  else
  self.anim_frame = 1
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
	local oldx = self.grid_x
	local oldy = self.grid_y
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

  world:call_player_actions(newx, newy, oldx, oldy)

end
