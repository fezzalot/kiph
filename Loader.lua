local suc, res = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/fezzalot/kiph/refs/heads/main/places/" .. game.PlaceId .. "/main.lua")
end)
if suc then
    loadstring(res)()
else
    loadstring("https://raw.githubusercontent.com/fezzalot/kiph/refs/heads/main/places/Universal/main.lua")()
end
