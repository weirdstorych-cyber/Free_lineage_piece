local repository = "https://raw.githubusercontent.com/weirdstorych-cyber/Free_lineage_piece/main/"
local env = type(getgenv) == "function" and getgenv() or _G
env.POON_FE_URL = repository .. "loader.lua"

return assert(loadstring(game:HttpGet(repository .. "poon_fe_pastefy.lua")))()
