state_menu = {}
function state_menu:draw()
	menu_draw()

end

function state_menu:keypressed(key, unicode)
 
   if key == 'up' then
        menu_nav(0, -1)
   end
   if key == 'down' then
        menu_nav(0, 1)
   end
   
   if key == 'left' then
        menu_nav(-1, 0)
   end
   if key == 'right' then
        menu_nav(1, 0)
   end
   if key == 'return' then
        menu_execute()
   end
   if key == 'escape' then
	game.current_state = game.state.playing; return
   end


end

----------

menu = {
	selected = {x=1, y=1},
	fullscreen = true,
	items = {{
		{label="Start", cb = function() game.current_state = game.state.playing end}, 
		--{label="Start Multiplayer", cb = function() print ("Start") end}
		},
		{{label="Quit", cb = function() love.event.quit() end}}
	}
}


function menu_get()
	return menu.items[menu.selected.y][menu.selected.x]
end


function menu_nav(x,y)
	local newy = math.max(1, math.min(#menu.items, menu.selected.y + y))
	local newx = math.max(1, math.min(#menu.items[newy], menu.selected.x + x))

	menu.selected.x = newx
	menu.selected.y = newy
	print ("Selected menu " .. menu_get().label)

end

function menu_execute()
	print ("Executing menu " .. menu_get().label)
	menu_get().cb()
end

function menu_draw()

	local left = 150
	local top = 50
	local spacex = 100
	local spacey = 30


    love.graphics.setFont(textFont);
    if menu.fullscreen then 
	love.graphics.setColor(50,50,50)
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())
    end
    for y=1,#menu.items do
      for x=1,#menu.items[y] do
	love.graphics.setColor(255,255,255)

	local l = left + x*spacex
	local t = top + y*spacey

	if menu.selected.x==x and menu.selected.y==y then
		--love.graphics.setColor(0,0,0)
		love.graphics.printf(">", l - 20, t, 200, "left")
	end
  	
	love.graphics.printf(menu.items[y][x].label, l, t, 200, "left")

      end
    end


end

