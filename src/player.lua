
    player = {
        grid_x = 1,
        grid_y = 1,
        act_x = 1,
        act_y = 1,
	offset = {x=0, y=-20},
	facing = {x=0,y=1},
	anim_frame = 1,
        speed = 5,
	---

	msg = {txt="Nazdar!",cur_len=0, displayed_len=15},
	
	life = 100,
	berries = 0,
	cash = 100,
	laf = 100,
}



player.load = function()


char = love.graphics.newImage( "img/chars.png" )

chq = function(x,y) return love.graphics.newQuad(x,y, 36, 48, 113, 210); end

ch = {[-1]={}, [0]={}, [1]={}}
-- stand, step1, step2
ch[0][-1] = {chq(40,8), chq(4,8), chq(40,8), chq(76,8)}
ch[1][0] = {chq(40,56), chq(4,56), chq(40,56), chq(76,56)}
ch[0][1] = {chq(40,104), chq(4,104), chq(40,104), chq(76,104)}
ch[-1][0] = {chq(40,153), chq(4,153), chq(40,153), chq(76,153)}
   

end

function player:face(x,y) 
		self.facing.x=x
		self.facing.y=y
	 end


function player:say(t) 
		self.msg.txt = t
	 end

function player:draw()
	love.graphics.setColor(255,255,255)
    love.graphics.drawq(char, ch[self.facing.x][self.facing.y][self.anim_frame], self.act_x, self.act_y)

 love.graphics.setColor(0,0,0)
    love.graphics.setFont(textFont);

  love.graphics.print(string.sub(self.msg.txt, math.max(1,self.msg.cur_len - player.msg.displayed_len), self.msg.cur_len), self.act_x+35, self.act_y+10) 
  --love.graphics.printf(string.sub(self.msg.txt,1,self.msg.cur_len), self.act_x+40, self.act_y-15, 200, "left") 


    --love.graphics.draw(img, top_left, 50, 50)
    -- v0.8:
    -- love.graphics.drawq(img, top_left, 50, 50)
end

p_dtotal = 0

function player:update(dt)
	p_dtotal = p_dtotal + dt -- TODO nejaky helper / util

   if p_dtotal >= 0.13 then
      p_dtotal = p_dtotal - 0.13   -- reduce our timer by a second, but don't discard the change... what if our framerate is 2/3 of a second?

if(player.msg.txt ~= "") then
player.msg.cur_len = player.msg.cur_len + 1 --FIXME
if(player.msg.cur_len > string.len(player.msg.txt)+player.msg.displayed_len) then -- time to read
player.msg.txt = ""
player.msg.cur_len = 0
end
end
end
end



function action(x,y) -- FIXME
    print("action", x,y)
    if x==4 and y==9 then map:set("map03", 8, 11) end
    if x==20 and y==14 or y==5 then map:set("map02", 1, y) end
end



function player:step(x, y)

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
if TiledMap_GetMapTile(newx-1,newy-1,map_action_id) > 0 then
           action(newx, newy)
end

end

