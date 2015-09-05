Menu = {
	get = function(menu)
		return menu.items[menu.selected.y][menu.selected.x]
	end,

	directions = {up={x=0,y=-1}, right={x=1,y=0}, down={x=0,y=1}, left={x=-1,y=0}},

	nav = function (menu, direction)
		local newy = math.max(1, math.min(#menu.items, menu.selected.y + Menu.directions[direction].y))
		local newx = math.max(1, math.min(#menu.items[newy], menu.selected.x + Menu.directions[direction].x))
		menu.selected.x = newx
		menu.selected.y = newy
		print ("Selected menu " .. Menu.get(menu).label)
	end,

	execute = function (menu)
		print ("Executing menu " .. Menu.get(menu).label)
		if(Menu.get(menu).cb) then Menu.get(menu).cb(); end
		if(Menu.get(menu).sub) then state_menu.menu = Menu.get(menu).sub; end -- TODO stack - each menu separate game_state
	end,

	draw = function (menu)
		local left = 150
		local top = 50
		local spacex = 100
		local spacey = 30
  	love.graphics.setFont(textFont);
		love.graphics.setColor(50,50,50)
		if menu.fullscreen then
			love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())
		else
			love.graphics.rectangle("fill",left+spacex-40,top+spacey-20,spacex+60,#menu.items*spacey+30)
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

}
