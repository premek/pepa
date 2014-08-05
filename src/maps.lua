function goto_fn(map, x, y)
  return function()
    world:set_map(maps[map], x, y)
  end
end
    

maps = {
  main = {
    filename = "map01",
    objects = {
    },
    actions = {
      {4, 9, function() 
        world:set_map(maps.inn, 8, 10)
        player:say("Good morning, inn keeper")
      end },
      {20, 14, goto_fn("berryland", 1, 14)},
      {4, 15, function() player:say("Neumim plavat... nebo nechci."); end},
      {10, 8, function() player:say("Kamen, kamen, kamen, kamen, kamen, ..."); end},

    }
  },
  berryland = {
    filename = "map02",
    objects = {
    },
    actions = {
      {1, 14, goto_fn("main", 20, 14)},
      {6, 14, function() game:start(state_picking) end},
    }
  },
  inn = {
    filename = "map03",
    objects = {
        npc,
    },
    actions = {
      {8, 11, goto_fn("main", 4, 10)},
      {9, 11, goto_fn("main", 4, 10)},
      {9, 6, function() player:say("Ahh..."); end},
      {12, 6, function() player:say("Halooo!"); end},
    }
  },
}

