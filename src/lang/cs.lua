return {
  _name = "Cesky",
  ----------------
  monies = "penize",
  elegant_beard = "elegantni bradka",
  berries = function(n) n = n or 1; return n == 1 and "boruvka" or n<5 and "boruvky" or "boruvek" end,
  health  = function(n) return n .. "% <3" end,
  appearance  = function(n) return n .. "% vzhled" end,
  inventory = "Majetek:",
}
