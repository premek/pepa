Storage = {}

function Storage:new (o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self

  o.walkable = false

  o.x = o.x or 1
  o.y = o.y or 1
  o.inventory = Inventory:new(o.inventory)

  return o
end

Storage.menu = {
  selected = {x=1, y=1},
  items = {
    {{label="Napit se", cb = function() player.props.life = player.props.life + 2 ; game_state_pop(); end}},
    {{label="Umyt si oblicej", cb = function() player.inventory:remove("dirt"); game_state_pop(); end}},
    {{label="Cely se umyt", cb = function() player.inventory:remove("clothes"); game_state_pop(); end}},
    {{label="Odejit", cb = function() game_state_pop();end}},
  }
}

function Storage:getMenu(actor)
  local inventories = {self.inventory, actor.inventory}

  local items = {}
  for i,inventory in ipairs(inventories) do
    items[i] = {}
    for item,amount in pairs(inventory) do
      if amount > 0 then items[i][#items[i]+1] = item end
    end
  end
  -- print_r(items)

  local menu = {
   selected = {x=1, y=1},
   nonblocking = true,
   title = "(Storage)...............(Inventory)",
   items = {}
  }
  for row=1, math.max(#items[1], #items[2]) do
    local line = {}
    for col, inventory in ipairs(inventories) do
      local nextInventory = inventories[(col % #inventories)+1]
      if items[col][row] then line[col] = {
        label = t(items[col][row], inventory[items[col][row]]) .. " x"..inventory[items[col][row]],
        cb = function()
          inventory:remove(items[col][row])
          nextInventory:add(items[col][row])
          state_menu.menu = self:getMenu(actor)
          state_menu.menu.selected = menu.selected
        end
      } end
    end
    menu.items[#menu.items+1] = line
  end
  return menu
end

function Storage:interact(actor)
  state_menu.menu = self:getMenu(actor)
  game_state_push(state_menu);
end
