--[[
█▀▀ █▀▀ ▀█▀ ▀█▀ █ █▄░█ █▀▀   █▀█ █░█ █▀▀ █▀█   █ ▀█▀   █▀█ █▀▀ █▀▄▀█ ▄▀█ █▀ ▀█▀ █▀▀ █▀█ █▀▀ █▀▄
█▄█ ██▄ ░█░ ░█░ █ █░▀█ █▄█   █▄█ ▀▄▀ ██▄ █▀▄   █ ░█░   █▀▄ ██▄ █░▀░█ █▀█ ▄█ ░█░ ██▄ █▀▄ ██▄ █▄▀
]]

repeat task.wait() until game:IsLoaded()
local require = require or function(...)
    return ...
end
local env = function(func)
    func()
end

if not isfolder("kiph") then
    makefolder("kiph")
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local pth = ReplicatedStorage.Pot_Shared.Settings.pth.Value
local hammerSkins = ReplicatedStorage.HammerSkins

local potShared = ReplicatedStorage.Pot_Shared
local potSharedSettings = require(potShared.Settings)

local player = workspace:FindFirstChild("PotGuy")
local hammer -- idk why i have this this is probably useless as [REDACTED]
local realHammer
local pot

if player then
    hammer = player:FindFirstChild("HammerSkin")
    pot = player:WaitForChild("Pot")
    realHammer = player:WaitForChild("Hammer")
end

workspace.ChildAdded:Connect(function(child)
    if child.Name == "PotGuy" then
        player = child
        hammer = player:FindFirstChild("HammerSkin")
        pot = player:WaitForChild("Pot")
        realHammer = player:WaitForChild("Hammer")
    end
end)

shared.serverToken = shared.serverToken or pth:InvokeServer(1, "", {
    {}
}, true, "ccn-1c6v9jab8ofx8erq-aqd9i0thggdfdd6uemc8f5sg40u")
local token = shared.serverToken

local function win()
    local event = ReplicatedStorage:FindFirstChild("LoadChar")
    if not event then return end
    event:FireServer(
        "end",
        token
    )
end

-- oh wow
local function addMaterial(material, props)
    for ind = 1, (typeof(material) == "table" and #material) or 1 do
        potSharedSettings.Material_Details[(typeof(material) == "table" and material[ind]) or material] = {
            Effect_Type = props.Effect_Type,
            SoundID = props.SoundID
        }
    end
end

local function equipSkin(skinArgument)
    local skin = ReplicatedStorage:WaitForChild("Skins"):FindFirstChild(skinArgument)
    if skin then
        local rainbow = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 234, 0),
            Color3.fromRGB(0, 255, 21),
            Color3.fromRGB(0, 110, 255),
            Color3.fromRGB(195, 0, 255)
        }
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)

        for _, pot in player:GetChildren() do
            if pot:IsA("Model") and (pot.Name ~= "HammerSkin" and pot.Name ~= "Cosmetic" and (pot and pot:FindFirstChild("Main"))) then
                pot:Destroy()
            end
        end

        local potSkin = skin:Clone()
        potSkin.Parent = player
        potSkin:PivotTo(pot.CFrame * CFrame.Angles(0, 1.5707963267948966, 0))

        if skinArgument == "RGB" then
            task.spawn(function()
                while potSkin:FindFirstChild("Main") do
                    for _, color in rainbow do
                        TweenService:Create(potSkin.Main, tweenInfo, {
                            Color = color
                        }):Play()
                        task.wait(tweenInfo.Time)
                        TweenService:Create(potSkin.Outline, tweenInfo, {
                            Color = color
                        }):Play()
                    end
                end
            end)
        end

        local oldTrail = realHammer:FindFirstChildOfClass("Trail")
        if oldTrail then
            oldTrail:Destroy()
        end

        local trail = ReplicatedStorage:WaitForChild("Trails"):FindFirstChild(skinArgument)
        if trail then
            local trailClone = trail:Clone()
            trailClone.Parent = realHammer
            trailClone.Attachment0 = trailClone.Parent:WaitForChild("Trail0")
            trailClone.Attachment1 = trailClone.Parent:WaitForChild("Trail1")
        end

        local weld
        weld = Instance.new("WeldConstraint")
        weld.Parent = potSkin:WaitForChild("Main")
        weld.Part0 = weld.Parent
        weld.Part1 = pot
    end
end

local function hideHead()
    for _, accessory in player:GetChildren() do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 1
            end
        end
    end
    player.Head.Transparency = 1
end
local function showHead()
    for _, accessory in player:GetChildren() do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 0
            end
        end
    end
    player.Head.Transparency = 0
end
local cosmetics = {
    ["Drunk Mario"] = {
        Texture = "rbxassetid://554947969",
        Mesh = "rbxassetid://554947956",
        Size = Vector3.new(3, 3, 3),
        HideHead = true,
        Offsets = {
            CFrame = CFrame.new(0, 1, 0),
            Angles = CFrame.Angles(
                math.rad(0),
                math.rad(180),
                math.rad(0)
            )
        }
    },
    ["Lucky Block"] = {
        Texture = "rbxassetid://16653372467",
        Mesh = "rbxassetid://16653372407",
        Size = Vector3.new(0.5, 0.5, 0.5),
        HideHead = true,
        Offsets = {
            CFrame = CFrame.new(0, 0.4, 0),
            Angles = CFrame.Angles(
                math.rad(0),
                math.rad(180),
                math.rad(0)
            )
        }
    },
    ["Monitor Head"] = {
        Texture = "rbxassetid://1263007159",
        Mesh = "rbxassetid://1263004833",
        Size = Vector3.new(1.4, 1.4, 1.4),
        HideHead = true,
        Offsets = {
            CFrame = CFrame.new(0, 0.5, 0),
            Angles = CFrame.Angles(
                math.rad(0),
                math.rad(0),
                math.rad(0)
            )
        }
    },
    ["UwU Mask"] = {
        Texture = "http://www.roblox.com/asset/?id=4903989589",
        Mesh = "rbxassetid://4903983276",
        Size = Vector3.new(1.4, 1.4, 1.4),
        HideHead = false,
        Offsets = {
            CFrame = CFrame.new(0, 0, 0),
            Angles = CFrame.Angles(
                math.rad(0),
                math.rad(0),
                math.rad(0)
            )
        }
    },
    ["Pot Head"] = {
        Texture = "rbxassetid://11779199030",
        Mesh = "rbxassetid://11779186056",
        Size = Vector3.new(0.05, 0.05, 0.05),
        HideHead = true,
        Offsets = {
            CFrame = CFrame.new(0, 0.6, 0),
            Angles = CFrame.Angles(
                math.rad(0),
                math.rad(0),
                math.rad(0)
            )
        }
    },
    ["Ice Crown"] = {
        Texture = "http://www.roblox.com/asset/?id=1323305",
        Mesh = "http://www.roblox.com/asset/?id=1323306",
        Size = Vector3.new(1, 1, 1),
        HideHead = false,
        Offsets = {
            CFrame = CFrame.new(-0.6, 1.8, 0),
            Angles = CFrame.Angles(
                math.rad(0),
                math.rad(0),
                math.rad(20)
            )
        }
    },
    ["Red Dominoes Pizza"] = {
        Texture = "http://www.roblox.com/asset/?id=42211425",
        Mesh = "http://www.roblox.com/asset/?id=1031410",
        Size = Vector3.new(1.3, 1.3, 1.3),
        HideHead = false,
        Offsets = {
            CFrame = CFrame.new(0, 1.5, 0),
            Angles = CFrame.Angles(
                math.rad(0),
                math.rad(0),
                math.rad(0)
            )
        }
    }
}
local function addCosmetic(cosmeticArgument, bool)
    local existing = player:FindFirstChild("Cosmetic")
    if existing then
        existing:Destroy()
    end
    showHead()
    if bool and cosmetics[cosmeticArgument] then
        local model = Instance.new("Model")
        model.Name = "Cosmetic"
        model.Parent = player

        local part = Instance.new("MeshPart")
        part.Name = "Main"
        part.TextureID = cosmetics[cosmeticArgument].Texture
        part.MeshId = cosmetics[cosmeticArgument].Mesh
        part.Size = cosmetics[cosmeticArgument].Size
        part.CanCollide = false
        part.Anchored = true
        part.Parent = model

        if cosmetics[cosmeticArgument].HideHead then
            hideHead()
        else
            showHead()
        end

        task.spawn(function()
            local spinVal = 0
            while model.Parent do
                if cosmeticArgument == "Lucky Block" then
                    spinVal += 0.005
                    model:PivotTo(player.Head.CFrame * cosmetics[cosmeticArgument].Offsets.CFrame * cosmetics[cosmeticArgument].Offsets.Angles * CFrame.Angles(0, spinVal, 0))
                else
                    model:PivotTo(player.Head.CFrame * cosmetics[cosmeticArgument].Offsets.CFrame * cosmetics[cosmeticArgument].Offsets.Angles)
                end
                task.wait()
            end
        end)
    end
end

if true then -- debugging
    --return
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "kiph",
    Icon = 131795232442976, -- Koronis v2 be like
    LoadingTitle = "kiph.",
    LoadingSubtitle = "by Fezza",
    ShowText = "KIPH UI",
    Theme = {
        TextColor = Color3.fromRGB(240, 240, 240),
        Background = Color3.fromRGB(22, 22, 24),
        Topbar = Color3.fromRGB(30, 29, 31),
        Shadow = Color3.fromRGB(180, 30, 90),
        NotificationBackground = Color3.fromRGB(20, 20, 22),
        NotificationActionsBackground = Color3.fromRGB(230, 230, 230),
        TabBackground = Color3.fromRGB(38, 34, 37),
        TabStroke = Color3.fromRGB(150, 40, 90),
        TabBackgroundSelected = Color3.fromRGB(45, 30, 40),
        TabTextColor = Color3.fromRGB(230, 220, 225),
        SelectedTabTextColor = Color3.fromRGB(255, 90, 150),
        ElementBackground = Color3.fromRGB(32, 30, 32),
        ElementBackgroundHover = Color3.fromRGB(40, 36, 39),
        SecondaryElementBackground = Color3.fromRGB(24, 23, 25),
        ElementStroke = Color3.fromRGB(160, 45, 95),
        SecondaryElementStroke = Color3.fromRGB(90, 35, 60),
        SliderBackground = Color3.fromRGB(45, 30, 38),
        SliderProgress = Color3.fromRGB(220, 40, 110),
        SliderStroke = Color3.fromRGB(255, 80, 150),
        ToggleBackground = Color3.fromRGB(28, 26, 28),
        ToggleEnabled = Color3.fromRGB(215, 35, 100),
        ToggleDisabled = Color3.fromRGB(90, 82, 86),
        ToggleEnabledStroke = Color3.fromRGB(255, 85, 155),
        ToggleDisabledStroke = Color3.fromRGB(115, 105, 110),
        ToggleEnabledOuterStroke = Color3.fromRGB(180, 50, 100),
        ToggleDisabledOuterStroke = Color3.fromRGB(65, 60, 62),
        DropdownSelected = Color3.fromRGB(42, 32, 37),
        DropdownUnselected = Color3.fromRGB(28, 27, 29),
        InputBackground = Color3.fromRGB(28, 27, 29),
        InputStroke = Color3.fromRGB(150, 40, 90),
        PlaceholderColor = Color3.fromRGB(170, 160, 165)
    },
 
    ToggleUIKeybind = "R",
 
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "kiph",
       FileName = "Big Hub"
    },
 
    Discord = {
       Enabled = true,
       Invite = "PXBbfWGXsQ",
       RememberJoins = true
    },
 
    KeySystem = true,
    KeySettings = {
       Title = "Welcome to Kiph",
       Subtitle = "Key System",
       Note = "Join: discord.gg/PXBbfWGXsQ (Key is: kiph)",
       FileName = "kiph_key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"kiph", "", " "}
    }
})

local function notif(title, text, duration, icon)
    Rayfield:Notify({
        Title = tostring(title),
        Content = tostring(text),
        Duration = (duration and tonumber(duration)) or 4,
        Image = icon or "info",
    })
end

local Mods = Window:CreateTab("Mods", "package")
local Misc = Window:CreateTab("Misc", "scan-line")
local Notes = Window:CreateTab("Notes", "notebook-pen")

Mods:CreateSection("Modifications")
Misc:CreateSection("Miscelleanous")
Notes:CreateSection("Notes")

Notes:CreateParagraph({Title = "<font size='18'><b>Stability</b></font>", Content = [[<b><font color="rgb(255, 120, 150)">Issues:</font></b>
    <b>1.</b> <font color="rgb(165, 165, 165)">Winning aftermath can lag (will fix in earlier updates for this)</font>
Report issues at: <font color="rgb(114, 137, 218)">https://discord.gg/QhKyfqSZTn</font>]]})
Notes:CreateButton({
    Name = "Copy Discord",
    Callback = function()
        setclipboard("https://discord.gg/QhKyfqSZTn")
    end,
})

local function funcExists(func, run)
    if getgenv()[func] then
        run()
    else
        notif("Incompatible Executor", "Your executor cannot use this because it is missing a required executor function: " .. func, 6, "triangle-alert")
    end
end

env(function()
    local Win
    Win = Misc:CreateButton({
        Name = "Win",
        Callback = win,
    })
end)

env(function()
    Misc:CreateDivider()

    local SpamWin
    local Duration

    local MINIMUM_DURATION = 0.1

    SpamWin = Misc:CreateToggle({
        Name = "Spam Win",
        CurrentValue = false,
        Flag = "SpamWin",
        Callback = function(enabled)
            if enabled then
                repeat
                    win()
                    task.wait(Duration.CurrentValue or MINIMUM_DURATION)
                until not SpamWin.CurrentValue
            end
        end,
    })

    Duration = Misc:CreateSlider({
        Name = "Duration",
        Range = {MINIMUM_DURATION, 5},
        Increment = 0.1,
        Suffix = "seconds",
        CurrentValue = MINIMUM_DURATION,
        Flag = "SpamWin_Duration",
        Callback = function() end
    })
end)

env(function()
    local SetSkin
    local Skin

    local skins = {}
    for _, skin in ReplicatedStorage.Skins:GetChildren() do
        if skin:IsA("Model") then
            table.insert(skins, skin.Name)
        end
    end

    SetSkin = Mods:CreateToggle({
        Name = "Set Pot Skin",
        CurrentValue = false,
        Flag = "SetSkin",
        Callback = function(enabled)
            if enabled then
                repeat
                    if not player:FindFirstChild(Skin.CurrentOption[1]) then
                        equipSkin(Skin.CurrentOption[1])
                    end
                    task.wait(0.01)
                until not SetSkin.CurrentValue
            else
                equipSkin(player.Skin.Value)
            end
        end,
    })

    Skin = Mods:CreateDropdown({
        Name = "Pot Skin Selection",
        Options = skins,
        CurrentOption = {"RGB"},
        MultipleOptions = false,
        Flag = "SetSkin_SkinSelection",
        Callback = function() 
            if SetSkin.CurrentValue then
                equipSkin(Skin.CurrentOption[1])
            end
        end,
    })
end)

env(function()
    local FreePotSkins
    local hook

    FreePotSkins = Mods:CreateToggle({
        Name = "Free Pot Skins",
        CurrentValue = false,
        Flag = "FreePotSkins",
        Callback = function(enabled)
            funcExists("hookmetamethod", function()
                if enabled then
                    hook = hookmetamethod(game, "__namecall", function(self, ...)
                        local method = getnamecallmethod()
                        if self == game.ReplicatedStorage.EquipSkin and method == "InvokeServer" then
                            return true
                        end
                        return hook(self, ...)
                    end)
                else
                    if hook then
                        hookmetamethod(game, '__namecall', hook)
                        hook = nil
                    end
                end
            end)
        end,
    })
end)

env(function()
    local SetSkin
    local Skin

    local function equipHammerSkin(skinArgument)
        local skin = hammerSkins:FindFirstChild(skinArgument)
        if skin then
            local skinClone = skin:Clone()
            skinClone.Name = "HammerSkin"
            skinClone.Parent = player
        end
    end

    local skins = {}
    for _, skin in hammerSkins:GetChildren() do
        if skin:IsA("Model") then
            table.insert(skins, skin.Name)
        end
    end

    SetSkin = Mods:CreateToggle({
        Name = "Set Hammer Skin",
        CurrentValue = false,
        Flag = "SetHammerSkin",
        Callback = function(enabled)
            if enabled then
                equipHammerSkin(Skin.CurrentOption[1])
            else
                if player:FindFirstChild("HammerSkin") then
                    player:FindFirstChild("HammerSkin"):Destroy()
                end
            end
        end,
    })

    Skin = Mods:CreateDropdown({
        Name = "Hammer Skin Selection",
        Options = skins,
        CurrentOption = {"VIP"},
        MultipleOptions = false,
        Flag = "SetHammerSkin_SkinSelection",
        Callback = function() 
            if SetSkin.CurrentValue then
                equipHammerSkin(Skin.CurrentOption[1])
            end
        end,
    })
end)

env(function()
    local SetCosmetic
    local Cosmetic

    local cosmeticsString = {}
    for name, _ in cosmetics do
        table.insert(cosmeticsString, name)
    end

    SetCosmetic = Mods:CreateToggle({
        Name = "Set Cosmetic",
        CurrentValue = false,
        Flag = "SetCosmetic",
        Callback = function(enabled)
            if enabled then
                repeat
                    pcall(function()
                        if not player:FindFirstChild("Cosmetic") then
                            addCosmetic(Cosmetic.CurrentOption[1], true)
                        end
                    end)
                    task.wait()
                until not SetCosmetic.CurrentValue
            else
                showHead()
                local oldCosmetic = player:FindFirstChild("Cosmetic")
                if oldCosmetic then
                    oldCosmetic:Destroy()
                end
            end
        end,
    })

    Cosmetic = Mods:CreateDropdown({
        Name = "Cosmetic Selection",
        Options = cosmeticsString,
        CurrentOption = {cosmeticsString[1]},
        MultipleOptions = false,
        Flag = "SetCosmetic_Selection",
        Callback = function()
            if SetCosmetic.CurrentValue then
                addCosmetic(Cosmetic.CurrentOption[1], true)
            end
        end,
    })
end)

env(function()
    Mods:CreateDivider()
    local defaultGravity = 57.5
    local Slider
    local GravityToggle
    local module = require(ReplicatedStorage.Pot_Shared.GraphicsPresets)

    local function setGravity(val)
        pcall(function()
            module.levels[0].Gravity = val
            module.levels[250].Gravity = val
            module.levels[530].Gravity = val
            module.levels[670].Gravity = val
            module.levels[810].Gravity = val
        end)
    end

    GravityToggle = Mods:CreateToggle({
        Name = "Gravity",
        CurrentValue = false,
        Flag = "Gravity",
        Callback = function(enabled)
            funcExists("require", function()
                if enabled then
                    repeat
                        setGravity(Slider.CurrentValue)
                        task.wait()
                    until not GravityToggle.CurrentValue
                else
                    setGravity(defaultGravity)
                end
            end)
        end,
    })

    Slider = Mods:CreateSlider({
        Name = "Gravity Amount",
        Range = {0, 100},
        Increment = 0.5,
        Suffix = "%",
        CurrentValue = 57.5,
        Flag = "Gravity_GravityAmount",
        Callback = function(value) end,
    })
end)

env(function()
    Mods:CreateDivider()
    local RotateToggle
    local RotateSlider

    local originals = {}
    local pivotPoint

    local function collectParts()
        originals = {}

        for _, obj in workspace:GetDescendants() do
            if obj:IsA("MeshPart") or obj:IsA("BasePart") then
                originals[obj] = obj.CFrame
            end
        end

        local spawnPart = workspace:FindFirstChild("SPAWNPART")
        if spawnPart and spawnPart:IsA("BasePart") then
            originals[spawnPart] = spawnPart.CFrame
            pivotPoint = spawnPart.Position
        else
            local sum = Vector3.new()
            local count = 0
            for _, cf in originals do
                sum += cf.Position
                count += 1
            end
            pivotPoint = count > 0 and (sum / count) or Vector3.new()
        end
    end

    local function applyRotation(degrees)
        if not pivotPoint then return end
        local rad = math.rad(degrees)
        local rotation = CFrame.Angles(0, 0, rad)

        local pivotCFrame = CFrame.new(pivotPoint)
        local pivotInverse = pivotCFrame:Inverse()

        for part, originalCFrame in originals do
            if part and part.Parent then
                part.CFrame = pivotCFrame * rotation * pivotInverse * originalCFrame
            end
        end
    end

    RotateToggle = Mods:CreateToggle({
        Name = "Rotation",
        CurrentValue = false,
        Flag = "RotationEnabled",
        Callback = function(enabled)
            if enabled then
                collectParts()
                applyRotation(RotateSlider.CurrentValue or 0)
            else
                for part, originalCFrame in originals do
                    if part and part.Parent then
                        part.CFrame = originalCFrame
                    end
                end
                originals = {}
                pivotPoint = nil
            end
        end,
    })

    RotateSlider = Mods:CreateSlider({
        Name = "Rotation Angle",
        Range = {-360, 360},
        Increment = 1,
        Suffix = "°",
        CurrentValue = 0,
        Flag = "RotationAngle",
        Callback = function(value)
            if RotateToggle.CurrentValue then
                applyRotation(value)
            end
        end,
    })
end)

env(function()
    Mods:CreateDivider()
    local CustomMaterialSounds

    CustomMaterialSounds = Mods:CreateToggle({
        Name = "Custom Material Sounds",
        CurrentValue = false,
        Flag = "CustomMaterialSounds",
        Callback = function(enabled) end,
    })

    local materials = {}
    for i, v in potSharedSettings.Material_Details do
        local materialName = i
        if not table.find(materials, materialName) then
            table.insert(materials, materialName)
            local default = Rayfield.Flags[materialName .. "_SoundID"] or potSharedSettings.Material_Details[materialName].SoundID
            local gameDefault = potSharedSettings.Material_Details[materialName].SoundID
            local MaterialInput
            MaterialInput = Mods:CreateInput({
                Name = materialName,
                CurrentValue = default,
                PlaceholderText = "SoundID (excluding rbxassetid)",
                RemoveTextAfterFocusLost = false,
                Flag = materialName .. "_SoundID",
                Callback = function(value) end,
            })
            task.spawn(function()
                while true do
                    if CustomMaterialSounds.CurrentValue then
                        potSharedSettings.Material_Details[materialName].SoundID = MaterialInput.CurrentValue
                    else
                        potSharedSettings.Material_Details[materialName].SoundID = gameDefault
                    end
                    task.wait()
                end
            end)
        end
    end
end)

-- OguriFuture for Ball And Axe, Kiph for Getting Over It Remastered.
-- = )
-- Love you so much! <3
Rayfield:LoadConfiguration() -- = 3
-- By Fezza, I love LUAU. (https://github.com/fezzalot)
-- Okay, that's all from me ! Thank's for reading this = ]
