local suc, res = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/fezzalot/kiph/refs/heads/main/places/" .. game.PlaceId .. "/main.lua")
end)
if suc then
    loadstring(res)()
else
    if not shared.dontShowAgain then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "kliph",
            Text = "Unsupported game! Find supported games in: https://discord.gg/QhKyfqSZTn",
            Duration = 10
        })
        shared.dontShowAgain = true
    end
end
