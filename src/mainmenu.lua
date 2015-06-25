mainmenu_options = {
	selected = {x=1, y=1},
	items = {{
    {
      label="Option1",
      cb = function() game:start(state_playing) end,
    }},
    {{
        label="Option2",
        cb = function() game:start(state_playing) end,
    }}}
}


mainmenu = {
	selected = {x=1, y=1},
	items = {{
		{
      label="Start",
      cb = function() game:start(state_playing) end,
    },
		--{label="Start Multiplayer", cb = function() print ("Start") end}
    },{
  		{
        label="Options",
        cb = function() print("OPTIONS") end,
        sub = mainmenu_options
      },
  		--{label="Start Multiplayer", cb = function() print ("Start") end}
  		},
		{{label="Quit", cb = function() love.event.quit() end}}
	}
}
