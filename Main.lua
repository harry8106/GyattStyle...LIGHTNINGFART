local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("True Heart 360", "Ocean")
local Stats = game.Players.LocalPlayer.data1
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HRP = player.Character.HumanoidRootPart
local SelectedTrainer = nil
local SelectedJob = nil
local offsetDistance = -1.5
local playerNames, Headshot, Bodyshot = {}, 0.9, -0.9
local selectedHitArea, selectedHit = nil, nil
local Skill1, Skill2, Skill3, Skill4 = "", "", "", "Ultra Instinct!"
_G.selectedPlayer, _G.SpamAttack, _G.Spam, _G.Follow, _G.KillPlayer, _G.Drug, _G.Food = nil, false, false, false, false, nil, nil

local function UpdatePlayerNames()
    playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
end

UpdatePlayerNames()
Players.PlayerAdded:Connect(UpdatePlayerNames)
Players.PlayerRemoving:Connect(UpdatePlayerNames)

local function Run()
    local Tab = Window:NewTab("Stats")
    local Section = Tab:NewSection("Change Stats")

    Section:NewTextBox("Change Power", "TextboxInfo", function(txt)
        Stats.power.Value = txt
        Stats.torque.Value = txt
        Stats.upperbody.Value = txt
    end)
    Section:NewTextBox("Change HitSpeed", "TextboxInfo", function(txt)
        Stats.hitspeed.Value = txt
        Stats.fasttwitch.Value = txt
        Stats.efficiency.Value = txt
    end)
    Section:NewTextBox("Change Arms", "TextboxInfo", function(txt)
        Stats.arms.Value = txt
        Stats.forearm.Value = txt
        Stats.shoulders.Value = txt
    end)
    Section:NewTextBox("Change Agility", "TextboxInfo", function(txt)
        Stats.agility.Value = txt
        Stats.footwork.Value = txt
        Stats.explosiveness.Value = (txt / 5)
    end)
    Section:NewTextBox("Change Defense", "TextboxInfo", function(txt)
        Stats.defense.Value = txt
        Stats.neck.Value = txt
        Stats.core.Value = txt
    end)

    local Tab = Window:NewTab("Attacks")
    local Section = Tab:NewSection("Destroy.")

    Section:NewDropdown("Place of hit", "DropdownInf", {"Headshot", "Bodyshot"}, function(currentOptionplace)
        if currentOptionplace == "Headshot" then
            selectedHitArea = Headshot
        elseif currentOptionplace == "Bodyshot" then
            selectedHitArea = Bodyshot
        end
    end)
    Section:NewDropdown("What attack", "DropdownInf", {"jab", "righthook", "lefthook", "uppercut", "straight"}, function(currentOptionhit)
        if currentOptionhit == "jab" then
            selectedHit = "jab"
        elseif currentOptionhit == "righthook" then
            selectedHit = "righthook"
        elseif currentOptionhit == "lefthook" then
            selectedHit = "lefthook"
        elseif currentOptionhit == "uppercut" then
            selectedHit = "uppercut"
        elseif currentOptionhit == "straight" then
            selectedHit = "straight"
        end
    end)

    Section:NewKeybind("Attack Keybind", "KeybindInfo", Enum.KeyCode.Z, function()
        game:GetService("ReplicatedStorage").Combat:FireServer(selectedHit, 0, 1000, selectedHitArea)
    end)

    Section:NewToggle("Spam Attack (Shitty)", "ToggleInfo", function(SpamAttack)
        if SpamAttack then
            _G.SpamAttack = true
        else
            _G.SpamAttack = false
        end

        while _G.SpamAttack == true do
            game:GetService("ReplicatedStorage").Combat:FireServer(selectedHit, 0, 1000, selectedHitArea)
            task.wait()
        end
    end)

    local function findNearestPlayer()
        local minDist = math.huge
        local nearestPlayer = nil
        local player = game.Players.LocalPlayer
        local myPos = player.Character.HumanoidRootPart.Position

        for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player then
                local otherPos = otherPlayer.Character and otherPlayer.Character.HumanoidRootPart.Position
                if otherPos then
                    local dist = (myPos - otherPos).magnitude
                    if dist < minDist then
                        minDist = dist
                        nearestPlayer = otherPlayer
                    end
                end
            end
        end

        return nearestPlayer
    end

    local function teleportAndFaceNearestPlayer()
        local nearestPlayer = findNearestPlayer()
        if nearestPlayer then
            local player = game.Players.LocalPlayer
            local char = player.Character
            if char then
                local targetPos = nearestPlayer.Character.HumanoidRootPart.Position - (nearestPlayer.Character.HumanoidRootPart.CFrame.LookVector * 5)
                char:SetPrimaryPartCFrame(CFrame.new(targetPos))
                char:SetPrimaryPartCFrame(CFrame.new(char.HumanoidRootPart.Position, char.HumanoidRootPart.Position + (nearestPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).unit))
            end
        end
    end

    local function Combo1Skill()
        game:GetService("ReplicatedStorage").Combat:FireServer("jab", 0, 1000, 0.9) -- jab
        wait(0.1)
        game:GetService("ReplicatedStorage").Combat:FireServer("jab", 0, 1000, 0.9) -- jab
        wait(0.1)
        game:GetService("ReplicatedStorage").Combat:FireServer("jab", 0, 1000, 0.9) -- jab
        wait(0.3)
        game:GetService("ReplicatedStorage").Combat:FireServer("uppercut", 0, 1000, 0.9) -- UpperCut
    end

    local function Combo2Skill()
        game:GetService("ReplicatedStorage").Combat:FireServer("straight", 0, 1000, 0.9)
        wait(0.2)
        game:GetService("ReplicatedStorage").Combat:FireServer("lefthook", 0, 1000, -0.9)
    end

    local function Combo3Skill()
        game:GetService("ReplicatedStorage").Combat:FireServer("righthook", 0, 1000, -0.9)
        wait(0.4)
        game:GetService("ReplicatedStorage").Combat:FireServer("uppercut", 0, 1000, 0.9)
    end

    local function Combo4Skill()
        for i = 1, 5 do
            game:GetService("ReplicatedStorage").Combat:FireServer("dash", "front")
            task.wait()
        end
        teleportAndFaceNearestPlayer()
    end

    local Tab = Window:NewTab("Skill Maker")
    local Section = Tab:NewSection("Jab x3, Upper")

    Section:NewTextBox("Skill name:", "TextboxInfo", function(Skill1Name)
        Skill1 = Skill1Name
        print("Skill", Skill1)
    end)

    Section:NewKeybind("Skill1 Keybind", "KeybindInfo", Enum.KeyCode.One, function()
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Skill1, "All")
        Combo1Skill()
    end)

    local Section = Tab:NewSection("Straight Left Hook")

    Section:NewTextBox("Skill name:", "TextboxInfo", function(Skill2Name)
        Skill2 = Skill2Name
        print(Skill2)
    end)

    Section:NewKeybind("Skill2 Keybind", "KeybindInfo", Enum.KeyCode.Two, function()
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Skill2, "All")
        Combo2Skill()
    end)

    local Section = Tab:NewSection("Right Hook Upper")

    Section:NewTextBox("Skill name:", "TextboxInfo", function(Skill3Name)
        Skill3 = Skill3Name
        print(Skill3)
    end)

    Section:NewKeybind("Skill3 Keybind", "KeybindInfo", Enum.KeyCode.Three, function()
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Skill3, "All")
        Combo3Skill()
    end)

    local Section = Tab:NewSection("Ultra Instinct")

    Section:NewTextBox("Skill name:", "TextboxInfo", function(Skill4Name)
        Skill4 = Skill4Name
        print(Skill4)
    end)

    Section:NewKeybind("Skill4 Keybind", "KeybindInfo", Enum.KeyCode.Four, function()
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Skill4, "All")
        Combo4Skill()
    end)

    local Tab = Window:NewTab("Teleports")
    local Section = Tab:NewSection("Style Trainers")

    Section:NewDropdown("Select Trainer", "DropdownInf", {"Hitman", "Peekaboo", "Crouching", "Refined Orthodox", "Long Guard", "Philly Shell"}, function(currentOption)
        if currentOption == "Hitman" then
            SelectedTrainer = game:GetService("Workspace")["Monte Hearns"]
        elseif currentOption == "Peekaboo" then
            SelectedTrainer = game:GetService("Workspace")["Bobby Johnson"]
        elseif currentOption == "Crouching" then
            SelectedTrainer = game:GetService("Workspace")["Boon-Nam Bun"]
        elseif currentOption == "Refined Orthodox" then
            SelectedTrainer = game:GetService("Workspace")["Keijima Haruki"]
        elseif currentOption == "Long Guard" then
            SelectedTrainer = game:GetService("Workspace")["Van Guren"]
        elseif currentOption == "Philly Shell" then
            SelectedTrainer = game:GetService("Workspace")["Obu Nobu"]
        end
    end)

    Section:NewButton("Tp To Trainer", "ButtonInfo", function()
        HRP.CFrame = SelectedTrainer.Torso.CFrame
    end)

    local Section = Tab:NewSection("Job People")

    Section:NewDropdown("Select Job place", "DropdownInf", {"StockBroker", "Scrapper", "HeavyLifter", "Cashier (WIP)"}, function(currentOption)
        if currentOption == "StockBroker" then
            SelectedJob = game:GetService("Workspace")["Hunterlinn"]
        elseif currentOption == "Scrapper" then
            SelectedJob = game:GetService("Workspace")["Janitor Jim"]
        elseif currentOption == "HeavyLifter" then
            SelectedJob = game:GetService("Workspace")["Boss Man Bobby John"]
        elseif currentOption == "Cashier (WIP)" then
            SelectedJob = game:GetService("Workspace")["Tommy"]
        end
    end)

    Section:NewButton("Tp To Employer", "ButtonInfo", function()
        HRP.CFrame = SelectedJob.Torso.CFrame
    end)

    local Section = Tab:NewSection("Locations")

    local LocationsFolder = game:GetService("ReplicatedStorage").LocationsFolder
    local Locations = {}
    for _, item in pairs(LocationsFolder:GetChildren()) do
        table.insert(Locations, item.Name)
    end

    Section:NewDropdown("Select Location","DropDownInfo", Locations, function(CurrentOption)
        _G.SelectedLocation = CurrentOption
    end)

    Section:NewButton("Tp To Location", "ButtonInfo", function()
        game:GetService("ReplicatedStorage").Location:FireServer(_G.SelectedLocation)
    end)

    local Tab = Window:NewTab("Buy Stuff")
    local Section = Tab:NewSection("Supplements")

    local supplementFolder = game:GetService("Workspace").supplementbuys
    local DrugNames = {}

    for _, item in pairs(supplementFolder:GetChildren()) do
        table.insert(DrugNames, item.Name)
    end

    Section:NewDropdown("Select A Drug", "DropdownInf", DrugNames, function(currentOption)
        _G.Drug = currentOption
    end)

    Section:NewButton("Buy Drug", "ButtonInfo", function()
        game:GetService("Players").LocalPlayer.PlayerGui.BuyTrainingUI.bg.RemoteEvent:FireServer(_G.Drug)
    end)

    local Section = Tab:NewSection("Food")
    local FoodNames = {"Chicken", "Cake", "Bloxorade", "Hotdog", "Burger", "Taco"}
    Section:NewDropdown("Select A Food", "DropdownInf", FoodNames, function(currentOption)
        _G.Food = currentOption
    end)
    Section:NewButton("Buy Food", "ButtonInfo", function()
        game:GetService("Players").LocalPlayer.PlayerGui.FoodUI.ClothingFrame.RemoteEvent:FireServer(_G.Food)
    end)

    local Tab = Window:NewTab("Misc.")
    local Section = Tab:NewSection("Idk anything else")

    Section:NewButton("Stock Market GUI (ass)", "ButtonInfo", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/harry8106/STOCKMARKETTH3/main/Main.lua'))()
    end)

    Section:NewButton("Heal injuries", "ButtonInfo", function()
        game:GetService("Players").LocalPlayer.PlayerGui.DoctorUI.Cure.LocalScript.RemoteEvent:FireServer()
    end)

    Section:NewButton("Ragdoll Self", "ButtonInfo", function()
        game:GetService("ReplicatedStorage").KO:FireServer()
    end)

    local function joinNewServer()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end

    Section:NewKeybind("Toggle GUI", "KeybindInfo", Enum.KeyCode.LeftAlt, function()
	    Library:ToggleUI()
    end)

    Section:NewButton("Rejoin Server", "ButtonInfo", function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end)

    Section:NewButton("Join New Server", "ButtonInfo", function()
        joinNewServer()
    end)

    local Tab = Window:NewTab("Troll")
    local Section = Tab:NewSection("Troll Face")

    Section:NewToggle("Made In Heaven!", "ToggleInfo", function(SpamOn)
        if SpamOn then
            _G.Spam = true
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("MADE IN HEAVEN!", "All")
        else
            _G.Spam = false
        end
        while _G.Spam == true do
            game:GetService("ReplicatedStorage").Combat:FireServer("dash", "front")
            task.wait()
        end
    end)

    local dropdown = Section:NewDropdown("Select Player","Info", playerNames, function(CurrentOption)
        _G.selectedPlayer = CurrentOption
    end)

    Section:NewButton("Refresh Player List (needed)", "ButtonInfo", function()
        dropdown:Refresh(playerNames)
    end)

    Section:NewToggle("Blind Player", "ToggleInfo", function(Follow)
        if Follow then
            _G.Follow = true
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("FLASHBANG!", "All")
            print("blinding ".. _G.selectedPlayer)
        else
            _G.Follow = false
        end
    end)

    Section:NewToggle("kill Player", "ToggleInfo", function(KillPlayerToggle)
        if KillPlayerToggle then
            _G.KillPlayer = true
            print("killing ".. _G.selectedPlayer)
        else
            _G.KillPlayer = false
        end
    end)

    local function hoverAbovePlayer()
        local targetPlayer = Players:GetPlayerFromCharacter(game.Workspace[_G.selectedPlayer])
        if not targetPlayer then return end
            
        local rootPart = player.Character.HumanoidRootPar
        local head = targetPlayer.Character.Head

        rootPart.CFrame = CFrame.new(head.Position + head.CFrame.LookVector * offsetDistance)
    end

    while true do
        if _G.KillPlayer then
            hoverAbovePlayer()
            Combo1Skill()
        elseif _G.Follow then
            hoverAbovePlayer()
            game:GetService("ReplicatedStorage").Combat:FireServer("dash", "front")
        end
        task.wait(0.001)
    end

end

Run()
