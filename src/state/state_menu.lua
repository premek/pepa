state_menu = {menu = mainmenu}

function state_menu:draw()
	Menu.draw(state_menu.menu)
end

function state_menu:keypressed(key, unicode)

	if key == 'up' or key == 'down' or key == 'left' or key == 'right' then
		Menu.nav(state_menu.menu, key)
	end

	if key == 'return' then
		Menu.execute(state_menu.menu)
		return
	end

	if key == 'escape' then game_state_pop() end
end

function state_menu:update () return true end -- XXX should menu pause or not?
