Menu = {
	get = function(menu)
		return menu.items[menu.selected.y][menu.selected.x]
	end,

	directions = {up={x=0,y=-1}, right={x=1,y=0}, down={x=0,y=1}, left={x=-1,y=0}},

	nav = function (menu, direction)
		local newy = (menu.selected.y + Menu.directions[direction].y - 1) % #menu.items + 1
		local newx = (menu.selected.x + Menu.directions[direction].x - 1) % #menu.items[newy] + 1
		menu.selected.x = newx
		menu.selected.y = newy
		--print ("Selected menu " .. Menu.get(menu).label)
	end,

	execute = function (menu)
		local selected = Menu.get(menu);
		if selected then
		  print ("Executing menu " .. selected.label, selected.cb, selected.sub)
		  if(selected.cb) then selected.cb(); end
		  -- FIXME sub
		  if(selected.sub) then state_menu.menu = selected.sub; end
			-- TODO stack - each menu separate game_state
	  end
	end,

	show = function (menu)
          state_menu.menu = menu
          game_state_push(state_menu)
	end,

  hide = function() game_state_pop() end;

  new = function(items, title)
    return { selected = {x=1, y=1}, title=title, items = items }
	end,

	alert = function(msg)
		Menu.show(Menu.new({{{label="OK", cb = Menu.hide}}}, msg))
	end,

	draw = function (menu)
		local left = 150
		local top = 80
		local spacex = 130
		local spacey = 30
		love.graphics.setFont(textFont);



		if(menu.title) then
			love.graphics.setColor(50,50,50)
			love.graphics.rectangle("fill",left+spacex-40,top-35,spacex*2+60,spacey+10)
			love.graphics.setColor(255,255,255)
			love.graphics.printf(menu.title, left+spacex-20, top-25, 200, "left")
		end

		love.graphics.setColor(50,50,50)
		if menu.fullscreen then
			love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())
		else
			love.graphics.rectangle("fill",left+spacex-40,top+spacey-20,spacex*2+60,#menu.items*spacey+30)
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
				if menu.items[y][x] then
					love.graphics.printf(menu.items[y][x].label, l, t, 200, "left")
				end
			end
		end
	end

}
