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
        if(player.inventory:remove("homeless_beard") or player.inventory:remove("elegant_beard")) then beardtime = 0; end
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
    {{label="Umyt si oblicej", cb = function() player.inventory:remove("dirt"); game_state_pop(); end}},
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

maps = {
  main = {
    filename = "map01",
    objects = {},
    actions = {
      {4, 9, function() world:set_map(maps.inn, 8, 10); player:say("Good morning, inn keeper"); end},
      {4, 15, function() player:say("Neumim plavat... nebo nechci."); end},
      {15, 3, function() player:say("Tuk tuk"); end}, -- FIXME unicode chars not working?
      {2, 4, function() player:say("Co je asi v tom sudu?"); end}, -- FIXME unicode chars not working?
      {4, 4, function() world:set_map(maps.bank, 8, 13); end}, -- FIXME unicode chars not working?
      {10, 8, function() player:say("Kamen, kamen, kamen, kamen, kamen, ..."); end},
      {18, 14, function() game_state_push(state_picking_mouse) end},
      {18, 9, function() player:say("Strome, kamarade") end},
    }
  },
  inn = {
    filename = "map03",
    objects = {
        npc.businessman,
    },
    actions = {
      {8, 11, function() world:set_map(maps.main, 4, 10); end},
      {9, 11, function() world:set_map(maps.main, 4, 10); end},
      {9, 6, function() state_menu.menu = vendingMachineMenu; game_state_push(state_menu); end},
      {12, 6, function() player:say("Halooo!"); end},
      {10, 6, function() player.inventory.clothes = 1; end},
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
