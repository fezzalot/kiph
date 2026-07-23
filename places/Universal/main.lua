repeat task.wait() until (game:IsLoaded() and game:GetService("Players").LocalPlayer ~= nil)
game:GetService("Players").LocalPlayer:Kick("Kiph is not supported for universal.\nSupported games:\n" .. game:HttpGet("https://github.com/fezzalot/kiph/raw/refs/heads/main/places/supported.txt"))
