languages = require.tree("lang")

lang_settings = {
  current = languages.cs,
  default = languages.en,
}

function t(txt, ...)
  local res;
  local r = lang_settings.current[txt]
  if r then
    res=r
  else
    print("Not translated in current language", txt)
    r = lang_settings.default[txt]
  end
  if r then
    res=r
  else
    print("Not translated in default language", txt)
    res = txt
  end

  return type(res) == "function" and res(...) or res
end
