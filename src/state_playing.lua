state_playing = {}

function state_playing:draw ()
love.graphics.setColor(255,255,255)

  world:draw()
 player:draw()
-- npc:draw()
hud:draw()

end

function state_playing:keypressed(key, unicode)
    if key == 'escape' then
      state_menu.menu = mainmenu
      game:start(state_menu)
   end



   if love.keyboard.isDown('t') then
        player:say("meteor shower... a gentle wave wets our sandals")
   end

   if love.keyboard.isDown('up') then
        player:step(0, -1)
   end
   if love.keyboard.isDown('down') then
        player:step(0, 1)
   end

   if love.keyboard.isDown('left') then
        player:step(-1, 0)
   end
   if love.keyboard.isDown('right') then
        player:step(1, 0)
   end



end

dtotal = 0

function state_playing:update(dt)
	player:update(dt)

	dtotal = dtotal + dt

local oldy = player.act_y
local oldx = player.act_x

	--FIXME
    player.act_y = player.act_y - math.floor((player.act_y - player.grid_y*world.tile.h + world.tile.h - player.offset.y) * player.speed * dt)
    player.act_x = player.act_x - math.floor((player.act_x - player.grid_x*world.tile.w + world.tile.w - player.offset.x) * player.speed * dt)

   if dtotal >= 0.2 then
      dtotal = dtotal - 0.2   -- reduce our timer by a second, but don't discard the change... what if our framerate is 2/3 of a second?


if(player.act_y ~=oldy or player.act_x ~= oldx) then
player.anim_frame = player.anim_frame % #player.ch[0][1] + 1 -- FIXME
else
player.anim_frame = 1
end


 end

end
