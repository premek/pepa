languages = require.tree("lang")
local pink = require 'lib.pink.pink.pink'

lang_settings = {
  current = languages.cs,
  default = languages.en,
}

local story = pink.getStory('ink/cs/main.ink')
function t(txt, ...)
  story.choosePathString(txt)
  local ret = story.continue()
  if not ret then print("Missing translation", txt ) end
  return ret or ""
end
-- TODO variable text 1 boruvka 5 boruvek
-- TODO switching languages
-- TODO default translation
-- TODO do not call on each draw update where not needed/changing (hud, ...)

function tbak(txt, ...)
  local res;
  local r = lang_settings.current[txt]
  if r then
    res=r
  else
    --print("Not translated in current language", txt)
    r = lang_settings.default[txt]
  end
  if r then
    res=r
  else
    --print("Not translated in default language", txt)
    res = txt
  end

  return type(res) == "function" and res(...) or res
end
