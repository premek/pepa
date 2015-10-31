Character = {}

function Character:new (o)
  local o = o or {}
  print("creating character", o.img, o)
  setmetatable(o, self)
  self.__index = self
  -- TODO understand lua metatables, __index. etc.

  o.facing = {x=0,y=1}
  o.speed=5
  o.dirtratio = 30 -- TODO realtime or "turn based" over the night?
  o.walkable = false

  o.x = o.x or 1
  o.y = o.y or 1
  o.px_x = o.px_x or 0
  o.px_y = o.px_y or 0
  o.offset = {x=0, y=-20}
  o.anim_frame = 1
  o.img = o.img or "npc1"
  o.msg = {txt="",cur_len=0, displayed_len=15, offset_x = 35, offset_y = 10}
  o.props = Inventory:new({life = 100, laf=50})
  o.inventory = Inventory:new(o.inventory)

  o:initCounters()

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

function Character:init ()
  self:warp()
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
  local variant = self.inventory.clothes and self.inventory.clothes>0 and self.char or self.charnaked;
  love.graphics.draw(variant, self.ch[self.facing.x][self.facing.y][self.anim_frame], self.px_x, self.px_y)

  love.graphics.setColor(0,0,0)
  love.graphics.setFont(textFont);
  love.graphics.print(string.sub(self.msg.txt, math.max(1,self.msg.cur_len - self.msg.displayed_len), self.msg.cur_len), self.px_x+self.msg.offset_x, self.px_y+self.msg.offset_y)
  --love.graphics.draw(img, top_left, 50, 50)
  -- v0.8:
  -- love.graphics.drawq(img, top_left, 50, 50)
end

--FIXME globals?
char_frame_counter = 0




function Character:update(dt)

  self.counters.msg:update(dt)
  self.counters.beard:update(dt)
  self.counters.dirt:update(dt)

  self.props.laf = math.max(0, math.min(100, 60
    +10*(self.props.elegant_beard or 0)
    -1*(self.props.dirt or 0)
    -30*(self.props.homeless_beard or 0)
    +40*(self.inventory.clothes or 0)
  ))

  local oldy = self.px_y
  local oldx = self.px_x
  self.px_y = self.px_y - math.floor((self.px_y - self.y*world.tile.h + world.tile.h - self.offset.y) * self.speed * dt)
  self.px_x = self.px_x - math.floor((self.px_x - self.x*world.tile.w + world.tile.w - self.offset.x) * self.speed * dt)
  self.counters.frame:update(dt, oldx, oldy)

end


function Character:initCounters()
  self.counters = {}

  self.counters.msg = Counter:newInterval(0.1, function(t)
    if(self.msg.txt ~= "") then
      self.msg.cur_len = self.msg.cur_len + 1 --FIXME
      if(self.msg.cur_len > string.len(self.msg.txt)+self.msg.displayed_len) then -- time to read
        self.msg.txt = ""
        self.msg.cur_len = 0
      end
    end
  end)

  self.counters.beard = Counter:new(function(t)
    if t >= 90 then
      if(not self.props:contains("homeless_beard")) then
        self.props:remove("elegant_beard")
        self.props:add("homeless_beard")
      end
    else
      if t >= 30 then
        if(not self.props:contains("elegant_beard")) then
          self.props:add("elegant_beard")
        end
      end
    end
  end)

  self.counters.dirt = Counter:newInterval(self.dirtratio, function(t)
    self.props:add("dirt");
  end)

  self.counters.frame = Counter:newInterval(0.2, function(t, oldx, oldy)
    if(self.px_y ~= oldy or self.px_x ~= oldx) then
      self.anim_frame = self.anim_frame % #self.ch[0][1] + 1
    else
      self.anim_frame = 1
    end
  end)

end




function Character:warp(x,y)
  self.x = x or self.x
  self.y = y or self.y

  self.px_x = self.x * world.tile.w - world.tile.w + self.offset.x
  self.px_y = self.y * world.tile.h - world.tile.h + self.offset.y
end



function Character:step(x, y)
  local oldx = self.x
  local oldy = self.y
  local newx = self.x + x
  local newy = self.y + y

  print("Step from ", self.x, self.y, "to", newx, newy)

  self:face(x, y)

  if world:isWalkable(newx, newy) then
    self.y = newy
    self.x = newx
  else
    print("No no")
  end

  world:interact(self, newx, newy, oldx, oldy)

end


function Character:interact(actor)
  self:face(actor.x-self.x, actor.y-self.y)
  self:say("Hello!")
  actor:say("Nazdar")
  -- TODO trade items, see storage.lua
end
