state_inventory = {} buhuuu!

function state_inventory:draw() return state_menu:draw() end
function state_inventory:keypressed(key, unicode)
	if key == 'i' then game_state_pop() end
	return state_menu:keypressed(key, unicode)
end

function state_inventory:init()
	self.menu = {
		selected = {x=1, y=1},
		fullscreen = false,
		items = {}
	}

	state_menu.menu = self.menu
end

function state_inventory:update(dt)
	self.menu.items = {}
	for item,amount in pairs (player.inventory) do
		if amount > 0 then
			self.menu.items[#self.menu.items+1] = {
				{
					label = t(item) .. (amount > 1 and " (" .. amount .. "x)" or ""),
					cb = function() state_menu.menu = {
						selected = {x=1, y=1},
						fullscreen = false,
						items = {
							{{label=t("Use"), cb=function() print("Use", item) end}},
							{{label=t("Eat"), cb=function() print("Eat", item); player.inventory:remove(item) end}},
							{{label=t("Examine"), cb=function() print("Examine", item) end}},
							{{label=t("Back"), cb=function() state_menu.menu = self.menu end}},
						}
					} end
				}
			}
		end
	end
	--[[
	self.menu.items[#self.menu.items+1] = {{
		label = t("Exit"),
		cb = function() game_state_pop() end
	}}
	]]

	return state_menu:update(dt)
end
