mainmenu_options_lang = {
	selected = {x=1, y=1},
	items = {}
}
for k,v in pairs(languages) do
	table.insert(mainmenu_options_lang.items, {{
      label=v._name,
		  cb = function()
				lang_settings.current = v
				game_state_pop()
			end
    }})
end


mainmenu_options = {
	selected = {x=1, y=1},
	items = {{
    {
      label="Language",
      sub = mainmenu_options_lang,
    }},
    {{
        label="Option2",
        cb = function()  end,
    }}}
}


mainmenu = {
	selected = {x=1, y=1},
	fullscreen = true,
	items = {{
		{
      label="Start",
      cb = function() game_state_pop() end,
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
