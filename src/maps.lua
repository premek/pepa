vendingMachineMenu = {
	selected = {x=1, y=1},
	items = {{
		{label="Buy a drink", cb = function()
      game_state_pop()
      if(player.inventory:remove("monies", 10)) then
        player.inventory:add("drink")
        player:say("Thanks, machine")
      else
        player:say("Na to nemam")
      end
    end},
		--{label="Start Multiplayer", cb = function() print ("Start") end}
		},{
		{label="Shave me", cb = function()
      game_state_pop()
      if(player.inventory:remove("monies", 10)) then
        if(player.props:remove("homeless_beard") or player.props:remove("elegant_beard")) then beardtime = 0; end
        player:say("Tak...")
      else
        player:say("Na to nemam")
      end
    end},
		--{label="Start Multiplayer", cb = function() print ("Start") end}
		},
		{{label="Leave", cb = function() game_state_pop(); player:say("Goodbye, machine"); end}}
	}
}
bankToiletMenu = {
  selected = {x=1, y=1},
  items = {
    {{label="Napit se", cb = function() player.props.life = player.props.life + 2 ; game_state_pop(); end}},
    {{label="Umyt si oblicej", cb = function() player.props:remove("dirt"); game_state_pop(); end}},
    {{label="Cely se umyt", cb = function() player.inventory:remove("clothes"); game_state_pop(); end}},
    {{label="Odejit", cb = function() game_state_pop();end}},
  }
}


bankCheck = function(x,y,prevx,prevy)
  -- only when going from outside (from bottom)
  if prevy > y then
    if player.props.laf < 50 then
      player:say("Jsem moc spinavy, do banky nemuzu")
      player:step(0,1)
    end
    if not player.inventory:contains("clothes") then
      player:say("Huhu, bez obleceni me do banky nepusti")
      player:step(0,1)
    end
  end
end

local mytree = function()
  Menu.show(Menu.new({
		    {{label="Spat", cb = function() Menu.hide(); game_state_push(state_sleeping); end}},
		    {{label="Odejit", cb = Menu.hide}},
		  }, "Tohle je muj strom"))
end

-- FIXME clean this code
local bath = function()
	local random = math.random(1, 35)
	local amount = math.min(player.props.dirt, random)
	print("cleaning dirt", amount, random)
	player.props:remove("dirt", amount)
	game_state_pop()
end

local waterMenu = {
  selected = {x=1, y=1},
  items = {
    {{label="Napit se", cb = function() player.props.life = player.props.life - 30 ; game_state_pop(); end}},
    {{label="Vykoupat se", cb = bath}},
    {{label="Odejit", cb = function() game_state_pop();end}},
  }
}


maps = {
  main = {
    filename = "map01",
    objects = {
			Storage:new({x=19, y=10, inventory={clothes=1}}),
		},
    actions = {
      {4, 9, function() world:set_map(maps.inn, 8, 10); player:say("Good morning, inn keeper"); end},
      {4, 15, function() Menu.show(waterMenu); end},
      {15, 3, function() player:say("Tuk tuk"); end}, -- FIXME unicode chars not working?
      {2, 4, function() player:say("Co je asi v tom sudu?"); end}, -- FIXME unicode chars not working?
      {4, 4, function() world:set_map(maps.bank, 8, 13); end}, -- FIXME unicode chars not working?
      {10, 8, function() player:say("Kamen, kamen, kamen, kamen, kamen, ..."); end},
      {18, 14, function() game_state_push(state_picking_mouse) end},
      {18, 9, mytree},
      {17, 9, mytree},
    }
  },
  inn = {
    filename = "map03",
    objects = {
        npc.businessman,
				Storage:new({x=10, y=6, inventory={book=10}}),
			Storage:new({x=11, y=6, inventory={berries=1}}),
    },
    actions = {
      {8, 11, function() world:set_map(maps.main, 4, 10); end},
      {9, 11, function() world:set_map(maps.main, 4, 10); end},
      {9, 6, function() state_menu.menu = vendingMachineMenu; game_state_push(state_menu); end},
      {12, 6, function() player:say("Halooo!"); end},
    }
  },
  bank = {
    filename = "map04",
    objects = {
			--npc.banker1, npc.banker2, npc.banker3, npc.banksecurity
		},
    actions = {
      {16,11, function() player:say("Se mi nechce..."); end},
      {18,11, function() player:say("Ted nechci...       a navic tady ani nejsou dvere"); end},
      {6,  7, function() print(npc.banksecurity); npc.banksecurity:say("Nelezte tam, vidim Vas!"); end}, -- FIXME - not working
      {13, 11, function() state_menu.menu = bankToiletMenu; game_state_push(state_menu); end},
      {14, 11, function() state_menu.menu = bankToiletMenu; game_state_push(state_menu); end},
      {8, 11, bankCheck},
      {9, 11, bankCheck},
      {8, 15, function() world:set_map(maps.main, 4, 5); end},
      {9, 15, function() world:set_map(maps.main, 4, 5); end},
    }
  },
}
