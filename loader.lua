-- loader.lua
local function xorDecrypt(str, key)
    local result = ""
    for i = 1, #str do
        local byte = string.byte(str, i)
        result = result .. string.char(bit32.bxor(byte, key))
    end
    return result
end

-- Зашифрованный код (вставьте содержимое encrypted_aimbot.lua как строку)
local encryptedCode = [[-- Объявляем функцию для запуска основного скрипта
local function LoadAimbotScript()
    local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/VisualRoblox/Roblox/main/UI-Libraries/Visual%20UI%20Library/Source.lua'))()
    local HttpService = game:GetService("HttpService")

    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    local Window = Library:CreateWindow('MI-Cheat', 'Rivals', 'VSMT-Studio', 'rbxassetid://10618928818', false, 'AimBotConfigs', 'Default')
    
    local MainTab = Window:CreateTab('Main', true, 'rbxassetid://3926305904', Vector2.new(524, 44), Vector2.new(36, 36))
    local MainSection = MainTab:CreateSection('Subscription Info')
    MainSection:CreateLabel('Subscription: Premium', Color3.fromRGB(255, 255, 255))

    -- Добавление информации о VSMT Studio
    local InfoSection = MainTab:CreateSection('About VSMT Studio')
    InfoSection:CreateLabel('Создано VSMT Studio', Color3.fromRGB(255, 255, 255))
    InfoSection:CreateLabel('Discord - mihackmm', Color3.fromRGB(255, 255, 255))
    InfoSection:CreateLabel('Telegram - @xzcamdymai66', Color3.fromRGB(255, 255, 255))

    -- Кнопка для Discord канала
    InfoSection:CreateButton('Discord канал', function()
        local success, err = pcall(function()
            print("Discord channel link: https://discord.gg/zc3b4jxXkg")
            setclipboard("https://discord.gg/zc3b4jxXkg")
            Library:CreateNotification('Discord Channel', 'Ссылка скопирована в буфер обмена: https://discord.gg/zc3b4jxXkg', 5)
        end)
        if not success then
            Library:CreateNotification('Ошибка', 'Не удалось скопировать ссылку. Скопируйте вручную: https://discord.gg/zc3b4jxXkg', 5)
        end
    end)

    -- Кнопка для Telegram канала
    InfoSection:CreateButton('Telegram канал', function()
        local success, err = pcall(function()
            print("Telegram channel link: https://t.me/SMTStudioHack")
            setclipboard("https://t.me/SMTStudioHack")
            Library:CreateNotification('Telegram Channel', 'Ссылка скопирована в буфер обмена: https://t.me/SMTStudioHack', 5)
        end)
        if not success then
            Library:CreateNotification('Ошибка', 'Не удалось скопировать ссылку. Скопируйте вручную: https://t.me/SMTStudioHack', 5)
        end
    end)

    

    -- Кнопка для YouTube
    InfoSection:CreateButton('YouTube', function()
        local success, err = pcall(function()
            print("YouTube link: https://youtube.com/@mwx_llc?si=rEhqI7v4dAmX5J-w")
            setclipboard("https://youtube.com/@mwx_llc?si=rEhqI7v4dAmX5J-w")
            Library:CreateNotification('YouTube', 'Ссылка скопирована в буфер обмена: https://youtube.com/@mwx_llc?si=rEhqI7v4dAmX5J-w', 5)
        end)
        if not success then
            Library:CreateNotification('Ошибка', 'Не удалось скопировать ссылку. Скопируйте вручную: https://youtube.com/@mwx_llc?si=rEhqI7v4dAmX5J-w', 5)
        end
    end)

    InfoSection:CreateLabel('MI-Cheat - это специальный скрипт для режима RIVALS.', Color3.fromRGB(255, 255, 255))
    InfoSection:CreateLabel('VSMT-Studio владеет еще множеством крутых скриптов', Color3.fromRGB(255, 255, 255))
    InfoSection:CreateLabel('для разных игр. Discord - mihackmm.', Color3.fromRGB(255, 255, 255))
    -- Переменные
    local aimAssistActive = false
    local wallCheckEnabled = false
    local permEspEnabled = false
    local friendEspEnabled = false
    local targetEspEnabled = false
    local showHPEnabled = false
    local modernEspEnabled = false -- Новая переменная для Modern ESP
    local enemyEspColor = Color3.fromRGB(255, 0, 0)
    local friendEspColor = Color3.fromRGB(0, 255, 0)
    local targetEspColor = Color3.fromRGB(255, 255, 0)
    local hpTextColor = Color3.fromRGB(0, 0, 0)
    local espSize = Vector3.new(4, 6, 2)
    local espTransparency = 0.75
    local hpTextSize = 30
    local whitelist = {LocalPlayer, "CTEPNK_0"}
    local espParts = {}
    local hpLabels = {}
    local ESPObjects = {} -- Таблица для Modern ESP
    local currentTarget = nil

    -- Переменные для вкладки Other
    local menuKeybindEnabled = false
    local menuColor = Color3.fromRGB(0, 125, 255)
    local menuTransparency = 0.5
    local menuPosition = UDim2.new(0.8, 0, 0.1, 0)
    local menuWidth = 180
    local menuHeightOffset = 20

    -- Переменные для биндов
    local aimKeybind = "Q"  -- Бинд для Aim Assist
    local whitelistKeybind = "G"  -- Бинд для Quick Add to Friends
    local toggleUIKeybind = "E"  -- Бинд для Toggle UI

    -- Функции
    local function IsPlayerWhitelisted(player)
        return table.find(whitelist, player) ~= nil or player.Name == "tuitgemev8"
    end

    local function AddToWhitelist(player)
        if not table.find(whitelist, player) then
            table.insert(whitelist, player)
            Library:CreateNotification('Whitelist', player.Name .. ' добавлен в белый список', 3)
        end
    end

    local function RemoveFromWhitelist(player)
        local index = table.find(whitelist, player)
        if index then
            table.remove(whitelist, index)
            Library:CreateNotification('Whitelist', player.Name .. ' удален из белого списка', 3)
        end
    end

    local function CreateESP(player, color)
        if player.Character and player.Character:FindFirstChild("Head") then
            local espPart = Instance.new("BoxHandleAdornment")
            espPart.Adornee = player.Character.Head
            espPart.Size = espSize
            espPart.Color3 = color
            espPart.Transparency = espTransparency
            espPart.ZIndex = 0
            espPart.AlwaysOnTop = true
            espPart.Parent = player.Character.Head
            return espPart
        end
    end

    local function CreateHPText(player)
        if player.Character and player.Character:FindFirstChild("Head") then
            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = player.Character.Head
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = hpTextColor
            textLabel.TextSize = hpTextSize
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.Text = "HP: " .. (player.Character:FindFirstChild("Humanoid") and math.floor(player.Character.Humanoid.Health) or "N/A")
            textLabel.Parent = billboard
            billboard.Parent = player.Character.Head
            return billboard
        end
    end

    local function ClearESP()
        for _, part in pairs(espParts) do
            if part then part:Destroy() end
        end
        espParts = {}
    end

    local function ClearHPText()
        for _, label in pairs(hpLabels) do
            if label then label:Destroy() end
        end
        hpLabels = {}
    end

    local function IsVisibleThroughWalls(target)
        if not wallCheckEnabled then return true end
        local origin = Camera.CFrame.Position
        local targetPos = target.Character and target.Character:FindFirstChild("Head") and target.Character.Head.Position
        if not targetPos then return false end
        local ray = Ray.new(origin, (targetPos - origin).Unit * (targetPos - origin).Magnitude)
        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
        return hit == nil or hit:IsDescendantOf(target.Character)
    end

    local function GetClosestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge
        local localCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local localHumanoidRootPart = localCharacter:WaitForChild("HumanoidRootPart")

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not IsPlayerWhitelisted(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - localHumanoidRootPart.Position).Magnitude
                if distance < shortestDistance and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and IsVisibleThroughWalls(player) then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
        return closestPlayer
    end

    -- Функция Modern ESP
    local function LoadModernESP()
        local defaultESPColor = Color3.fromRGB(255, 0, 0)
        local espTransparency = 0.7

        -- Создание ESP
        local function CreateESP(player)
            if not modernEspEnabled or not player or ESPObjects[player] then 
                return 
            end
            
            local char = player.Character
            if not char then 
                return 
            end
            
            local head = char:FindFirstChild("Head")
            if not head then 
                return 
            end
            
            print("Создаем Modern ESP для " .. player.Name)
            
            -- BillboardGui для имени, HP и расстояния
            local espHolder = Instance.new("BillboardGui")
            espHolder.Name = "IY_ESP_" .. player.Name
            espHolder.Adornee = head
            espHolder.Size = UDim2.new(0, 100, 0, 75)
            espHolder.StudsOffset = Vector3.new(0, 3, 0)
            espHolder.AlwaysOnTop = true
            espHolder.Parent = char
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.BackgroundTransparency = 1
            nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
            nameLabel.Text = player.Name
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.TextScaled = true
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.Parent = espHolder
            
            local hpLabel = Instance.new("TextLabel")
            hpLabel.BackgroundTransparency = 1
            hpLabel.Size = UDim2.new(1, 0, 0.33, 0)
            hpLabel.Position = UDim2.new(0, 0, 0.33, 0)
            hpLabel.TextStrokeTransparency = 0.5
            hpLabel.TextScaled = true
            hpLabel.Font = Enum.Font.SourceSansBold
            hpLabel.Parent = espHolder
            
            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.Size = UDim2.new(1, 0, 0.33, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
            distanceLabel.TextStrokeTransparency = 0.5
            distanceLabel.TextScaled = true
            distanceLabel.Font = Enum.Font.SourceSansBold
            distanceLabel.Parent = espHolder
            
            -- Highlight для обводки
            local highlight = Instance.new("Highlight")
            highlight.Name = "IY_ESP_Highlight"
            highlight.Adornee = char
            highlight.FillTransparency = espTransparency
            highlight.OutlineTransparency = 0
            highlight.Parent = char
            
            ESPObjects[player] = {
                Billboard = espHolder,
                Highlight = highlight,
                NameLabel = nameLabel,
                HPLabel = hpLabel,
                DistanceLabel = distanceLabel
            }
        end

        -- Удаление ESP
        local function RemoveESP(player)
            if ESPObjects[player] then
                print("Удаляем Modern ESP для " .. player.Name)
                if ESPObjects[player].Billboard then
                    ESPObjects[player].Billboard:Destroy()
                end
                if ESPObjects[player].Highlight then
                    ESPObjects[player].Highlight:Destroy()
                end
                ESPObjects[player] = nil
            end
        end

        -- Обновление ESP
        local function UpdateESP()
            if not modernEspEnabled then
                print("Modern ESP отключен, очищаем все")
                for player, _ in pairs(ESPObjects) do
                    RemoveESP(player)
                end
                return
            end
            
            local localChar = LocalPlayer.Character
            local localHead = localChar and localChar:FindFirstChild("Head")
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    RemoveESP(player)
                    CreateESP(player)
                    
                    local espData = ESPObjects[player]
                    if espData then
                        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                        local targetHead = player.Character and player.Character:FindFirstChild("Head")
                        
                        espData.NameLabel.TextColor3 = defaultESPColor
                        espData.HPLabel.TextColor3 = defaultESPColor
                        espData.DistanceLabel.TextColor3 = defaultESPColor
                        espData.Highlight.FillColor = defaultESPColor
                        espData.Highlight.OutlineColor = defaultESPColor
                        
                        if humanoid then
                            espData.HPLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth
                        else
                            espData.HPLabel.Text = "HP: N/A"
                        end
                        
                        if localHead and targetHead then
                            local distance = (localHead.Position - targetHead.Position).Magnitude
                            espData.DistanceLabel.Text = "Dist: " .. math.floor(distance) .. " studs"
                        else
                            espData.DistanceLabel.Text = "Dist: N/A"
                        end
                    end
                end
            end
            print("Modern ESP обновлены")
        end

        -- Запуск обновления каждые 0.1 секунды
        spawn(function()
            while true do
                UpdateESP()
                wait(0.1)
            end
        end)

        -- Обработка новых игроков и возрождения
        Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                print("Новый игрок: " .. player.Name)
                player.CharacterAdded:Connect(function(char)
                    print(player.Name .. " получил новый персонаж")
                    if modernEspEnabled then
                        CreateESP(player)
                    end
                end)
                if player.Character then
                    CreateESP(player)
                end
            end
        end)

        Players.PlayerRemoving:Connect(function(player)
            print("Игрок ушел: " .. player.Name)
            RemoveESP(player)
        end)

        -- Инициализация для текущих игроков
        print("Инициализация Modern ESP для текущих игроков")
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreateESP(player)
            end
        end
    end

    -- Вкладка Aim Assist
    local AimTab = Window:CreateTab('Aim Assist', true, 'rbxassetid://3926305904', Vector2.new(524, 44), Vector2.new(36, 36))
    local AimSection = AimTab:CreateSection('Settings')

    local ToggleAim = AimSection:CreateToggle('Enable Aim Assist', false, Color3.fromRGB(0, 125, 255), 0.25, function(Value)
        aimAssistActive = Value
        Library:CreateNotification('Aim Assist', 'Aim Assist is now ' .. (Value and 'Active' or 'Inactive'), 3)
    end)

    local AimKeybind = AimSection:CreateKeybind('Toggle Aim Assist', aimKeybind, function()
        aimAssistActive = not aimAssistActive
        ToggleAim:UpdateToggle(aimAssistActive)
    end)

    local WallCheckToggle = AimSection:CreateToggle('Enable Wall Check', false, Color3.fromRGB(0, 125, 255), 0.25, function(Value)
        wallCheckEnabled = Value
        Library:CreateNotification('Wall Check', 'Wall Check is now ' .. (Value and 'Active' or 'Inactive'), 3)
    end)

    -- Вкладка ESP
    local EspTab = Window:CreateTab('ESP', false, 'rbxassetid://3926305904', Vector2.new(524, 44), Vector2.new(36, 36))

    local PermEspSection = EspTab:CreateSection('Permanent ESP')
    local TogglePermEsp = PermEspSection:CreateToggle('Enable Enemy ESP', false, Color3.fromRGB(0, 125, 255), 0.25, function(Value)
        permEspEnabled = Value
        if not Value then ClearESP() end
    end)
    local EnemyColorPicker = PermEspSection:CreateColorpicker('Enemy ESP Color', Color3.fromRGB(255, 0, 0), 0.25, function(Value)
        enemyEspColor = Value
    end)

    local FriendEspSection = EspTab:CreateSection('Friend ESP')
    local ToggleFriendEsp = FriendEspSection:CreateToggle('Enable Friend ESP', false, Color3.fromRGB(0, 125, 255), 0.25, function(Value)
        friendEspEnabled = Value
        if not Value then ClearESP() end
    end)
    local FriendColorPicker = FriendEspSection:CreateColorpicker('Friend ESP Color', Color3.fromRGB(0, 255, 0), 0.25, function(Value)
        friendEspColor = Value
    end)

    local TargetEspSection = EspTab:CreateSection('Target ESP')
    local ToggleTargetEsp = TargetEspSection:CreateToggle('Enable Target ESP', false, Color3.fromRGB(0, 125, 255), 0.25, function(Value)
        targetEspEnabled = Value
        if not Value then ClearESP() end
    end)
    local TargetColorPicker = TargetEspSection:CreateColorpicker('Target ESP Color', Color3.fromRGB(255, 255, 0), 0.25, function(Value)
        targetEspColor = Value
    end)

    local HPSection = EspTab:CreateSection('HP Display')
    local ToggleHP = HPSection:CreateToggle('Show Player HP', false, Color3.fromRGB(0, 125, 255), 0.25, function(Value)
        showHPEnabled = Value
        if not Value then ClearHPText() end
    end)
    local HPColorPicker = HPSection:CreateColorpicker('HP Text Color', Color3.fromRGB(255, 255, 255), 0.25, function(Value)
        hpTextColor = Value
        for _, label in pairs(hpLabels) do
            if label then label.TextLabel.TextColor3 = hpTextColor end
        end
    end)
    local HPSizeSlider = HPSection:CreateSlider('HP Text Size', 8, 30, 14, Color3.fromRGB(0, 125, 255), function(Value)
        hpTextSize = Value
        for _, label in pairs(hpLabels) do
            if label then label.TextLabel.TextSize = hpTextSize end
        end
    end)

    local EspSettingsSection = EspTab:CreateSection('ESP Visual Settings')
    local TransparencySlider = EspSettingsSection:CreateSlider('ESP Transparency', 0, 100, 50, Color3.fromRGB(0, 125, 255), function(Value)
        espTransparency = Value / 100
        for _, part in pairs(espParts) do
            if part then part.Transparency = espTransparency end
        end
    end)

    local ESPSizeSlider = EspSettingsSection:CreateSlider('ESP Size', 1, 10, 4, Color3.fromRGB(0, 125, 255), function(Value)
        espSize = Vector3.new(Value, Value * 1.5, Value / 2)
        for _, part in pairs(espParts) do
            if part then part.Size = espSize end
        end
    end)

    local ToggleModernEsp = EspSettingsSection:CreateToggle('Enable Modern ESP', false, Color3.fromRGB(0, 125, 255), 0.25, function(Value)
        modernEspEnabled = Value
        if Value then
            LoadModernESP()
            Library:CreateNotification('Modern ESP', 'Modern ESP is now Active', 3)
        else
            for player, _ in pairs(ESPObjects) do
                if ESPObjects[player].Billboard then ESPObjects[player].Billboard:Destroy() end
                if ESPObjects[player].Highlight then ESPObjects[player].Highlight:Destroy() end
                ESPObjects[player] = nil
            end
            Library:CreateNotification('Modern ESP', 'Modern ESP is now Inactive', 3)
        end
    end)

    -- Вкладка Friends List
    local FriendsTab = Window:CreateTab('Friends List', false, 'rbxassetid://3926305904', Vector2.new(524, 44), Vector2.new(36, 36))
    local FriendsSection = FriendsTab:CreateSection('Player Management')

    local playerList = {}
    local function UpdatePlayerList()
        playerList = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerList, player.Name)
            end
        end
    end

    UpdatePlayerList()
    local SelectedPlayer = nil
    local PlayersDropdown = FriendsSection:CreateDropdown('Select Player', playerList, nil, 0.25, function(Value)
        SelectedPlayer = Players:FindFirstChild(Value)
    end)

    local AddFriendButton = FriendsSection:CreateButton('Add to Friends', function()
        if SelectedPlayer then
            AddToWhitelist(SelectedPlayer)
        end
    end)

    local RemoveFriendButton = FriendsSection:CreateButton('Remove from Friends', function()
        if SelectedPlayer then
            RemoveFromWhitelist(SelectedPlayer)
        end
    end)

    local AddNearbyButton = FriendsSection:CreateButton('Add Nearby Players (5 studs)', function()
        local localCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local localRoot = localCharacter:WaitForChild("HumanoidRootPart")
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - localRoot.Position).Magnitude
                if distance <= 5 then
                    AddToWhitelist(player)
                end
            end
        end
    end)

    local WhitelistKeybind = FriendsSection:CreateKeybind('Quick Add to Friends', whitelistKeybind, function()
        local closestPlayer = GetClosestPlayer()
        if closestPlayer then
            AddToWhitelist(closestPlayer)
        end
    end)

    local RefreshButton = FriendsSection:CreateButton('Refresh Players', function()
        UpdatePlayerList()
        PlayersDropdown:UpdateDropdown(playerList)
    end)

    -- Вкладка UI Settings
    local UITab = Window:CreateTab('UI Settings', false, 'rbxassetid://3926305904', Vector2.new(524, 44), Vector2.new(36, 36))
    local UISection = UITab:CreateSection('Controls')

    local ToggleUIKeybind = UISection:CreateKeybind('Toggle UI', toggleUIKeybind, function()
        Library:ToggleUI()
    end)

    -- Вкладка Other (Menu Keybind)
    local OtherTab = Window:CreateTab('Other', false, 'rbxassetid://3926305904', Vector2.new(524, 44), Vector2.new(36, 36))
    local OtherSection = OtherTab:CreateSection('Menu Keybind Settings')

    local menuGui = nil
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function CreateOrUpdateMenuGui()
        if not menuKeybindEnabled then
            if menuGui then menuGui:Destroy() end
            menuGui = nil
            return
        end

        local contentText = ""
        contentText = contentText .. (aimAssistActive and "Aim Assist: ON (" .. aimKeybind .. ")\n" or "Aim Assist: OFF (" .. aimKeybind .. ")\n")

        local lineCount = select(2, contentText:gsub("\n", "")) + 1
        local textHeight = lineCount * 18

        if not menuGui then
            menuGui = Instance.new("ScreenGui")
            menuGui.Parent = game.CoreGui
            menuGui.Name = "MenuKeybindGui"

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, menuWidth, 0, menuHeightOffset + textHeight)
            frame.Position = menuPosition
            frame.BackgroundColor3 = menuColor
            frame.BackgroundTransparency = menuTransparency
            frame.BorderSizePixel = 0
            frame.Parent = menuGui

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 20)
            title.Position = UDim2.new(0, 0, 0, 0)
            title.BackgroundTransparency = 1
            title.Text = "Active Keybinds"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 16
            title.Font = Enum.Font.SourceSansBold
            title.Parent = frame

            local content = Instance.new("TextLabel")
            content.Name = "Content"
            content.Size = UDim2.new(1, -10, 0, textHeight)
            content.Position = UDim2.new(0, 5, 0, 20)
            content.BackgroundTransparency = 1
            content.TextColor3 = Color3.fromRGB(255, 255, 255)
            content.TextSize = 14
            content.Font = Enum.Font.SourceSans
            content.TextXAlignment = Enum.TextXAlignment.Left
            content.TextYAlignment = Enum.TextYAlignment.Top
            content.Parent = frame

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    dragStart = input.Position
                    startPos = frame.Position
                end
            end)

            frame.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                    local delta = input.Position - dragStart
                    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    menuPosition = frame.Position
                end
            end)

            frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
        end

        local contentTextFormatted = ""
        if aimAssistActive then
            contentTextFormatted = contentTextFormatted .. "<font size=\"18\">Aim Assist: ON (" .. aimKeybind .. ")</font>\n"
        else
            contentTextFormatted = contentTextFormatted .. "<font size=\"18\">Aim Assist: OFF (" .. aimKeybind .. ")</font>\n"
        end

        menuGui.Frame.Content.RichText = true
        menuGui.Frame.Content.Text = contentTextFormatted
        menuGui.Frame.BackgroundColor3 = menuColor
        menuGui.Frame.BackgroundTransparency = menuTransparency
        menuGui.Frame.Size = UDim2.new(0, menuWidth, 0, menuHeightOffset + textHeight)
    end

    local ToggleMenuKeybind = OtherSection:CreateToggle('Enable Menu Keybind', false, Color3.fromRGB(0, 125, 255), 0.25, function(Value)
        menuKeybindEnabled = Value
        CreateOrUpdateMenuGui()
        Library:CreateNotification('Menu Keybind', 'Menu Keybind is now ' .. (Value and 'Active' or 'Inactive'), 3)
    end)

    local MenuColorPicker = OtherSection:CreateColorpicker('Menu Color', Color3.fromRGB(0, 125, 255), 0.25, function(Value)
        menuColor = Value
        if menuGui then
            menuGui.Frame.BackgroundColor3 = menuColor
        end
    end)

    local MenuTransparencySlider = OtherSection:CreateSlider('Menu Transparency', 0, 100, 50, Color3.fromRGB(0, 125, 255), function(Value)
        menuTransparency = Value / 100
        if menuGui then
            menuGui.Frame.BackgroundTransparency = menuTransparency
        end
    end)

    local MenuWidthSlider = OtherSection:CreateSlider('Menu Width', 50, 300, 100, Color3.fromRGB(0, 125, 255), function(Value)
        menuWidth = Value
        if menuGui then
            local contentText = menuGui.Frame.Content.Text
            local lineCount = select(2, contentText:gsub("\n", "")) + 1
            local textHeight = lineCount * 18
            menuGui.Frame.Size = UDim2.new(0, menuWidth, 0, menuHeightOffset + textHeight)
            menuGui.Frame.Content.Size = UDim2.new(1, -10, 0, textHeight)
        end
    end)

    local MenuHeightOffsetSlider = OtherSection:CreateSlider('Menu Height Offset', 20, 100, 20, Color3.fromRGB(0, 125, 255), function(Value)
        menuHeightOffset = Value
        if menuGui then
            local contentText = menuGui.Frame.Content.Text
            local lineCount = select(2, contentText:gsub("\n", "")) + 1
            local textHeight = lineCount * 18
            menuGui.Frame.Size = UDim2.new(0, menuWidth, 0, menuHeightOffset + textHeight)
        end
    end)

    local PositionXSlider = OtherSection:CreateSlider('Menu X Position', 0, 1, 0.8, Color3.fromRGB(0, 125, 255), function(Value)
        menuPosition = UDim2.new(Value, 0, menuPosition.Y.Scale, 0)
        if menuGui then
            menuGui.Frame.Position = menuPosition
        end
    end)

    local PositionYSlider = OtherSection:CreateSlider('Menu Y Position', 0, 1, 0.1, Color3.fromRGB(0, 125, 255), function(Value)
        menuPosition = UDim2.new(menuPosition.X.Scale, 0, Value, 0)
        if menuGui then
            menuGui.Frame.Position = menuPosition
        end
    end)

    -- Вкладка Config
    local ConfigTab = Window:CreateTab('Config', false, 'rbxassetid://3926305904', Vector2.new(524, 44), Vector2.new(36, 36))
    local ConfigSection = ConfigTab:CreateSection('Configuration')

    local function SaveConfig()
        local config = {
            aimAssistActive = aimAssistActive,
            wallCheckEnabled = wallCheckEnabled,
            permEspEnabled = permEspEnabled,
            friendEspEnabled = friendEspEnabled,
            targetEspEnabled = targetEspEnabled,
            showHPEnabled = showHPEnabled,
            modernEspEnabled = modernEspEnabled, -- Сохранение состояния Modern ESP
            enemyEspColor = {R = enemyEspColor.R, G = enemyEspColor.G, B = enemyEspColor.B},
            friendEspColor = {R = friendEspColor.R, G = friendEspColor.G, B = friendEspColor.B},
            targetEspColor = {R = targetEspColor.R, G = targetEspColor.G, B = targetEspColor.B},
            hpTextColor = {R = hpTextColor.R, G = hpTextColor.G, B = hpTextColor.B},
            espSize = {X = espSize.X, Y = espSize.Y, Z = espSize.Z},
            espTransparency = espTransparency,
            hpTextSize = hpTextSize,
            whitelist = whitelist,
            menuKeybindEnabled = menuKeybindEnabled,
            menuColor = {R = menuColor.R, G = menuColor.G, B = menuColor.B},
            menuTransparency = menuTransparency,
            menuPosition = {X = menuPosition.X.Scale, Y = menuPosition.Y.Scale},
            menuWidth = menuWidth,
            menuHeightOffset = menuHeightOffset
        }

        local json = HttpService:JSONEncode(config)
        writefile("MoonCheatConfig.json", json)
        Library:CreateNotification('Config', 'Configuration saved to MoonCheatConfig.json', 3)
    end

    local function LoadConfig()
        if isfile("MoonCheatConfig.json") then
            local json = readfile("MoonCheatConfig.json")
            local config = HttpService:JSONDecode(json)

            aimAssistActive = config.aimAssistActive
            wallCheckEnabled = config.wallCheckEnabled
            permEspEnabled = config.permEspEnabled
            friendEspEnabled = config.friendEspEnabled
            targetEspEnabled = config.targetEspEnabled
            showHPEnabled = config.showHPEnabled
            modernEspEnabled = config.modernEspEnabled or false -- Загрузка состояния Modern ESP
            enemyEspColor = Color3.new(config.enemyEspColor.R, config.enemyEspColor.G, config.enemyEspColor.B)
            friendEspColor = Color3.new(config.friendEspColor.R, config.friendEspColor.G, config.friendEspColor.B)
            targetEspColor = Color3.new(config.targetEspColor.R, config.targetEspColor.G, config.targetEspColor.B)
            hpTextColor = Color3.new(config.hpTextColor.R, config.hpTextColor.G, config.hpTextColor.B)
            espSize = Vector3.new(config.espSize.X, config.espSize.Y, config.espSize.Z)
            espTransparency = config.espTransparency
            hpTextSize = config.hpTextSize
            whitelist = config.whitelist
            menuKeybindEnabled = config.menuKeybindEnabled
            menuColor = Color3.new(config.menuColor.R, config.menuColor.G, config.menuColor.B)
            menuTransparency = config.menuTransparency
            menuPosition = UDim2.new(config.menuPosition.X, 0, config.menuPosition.Y, 0)
            menuWidth = config.menuWidth
            menuHeightOffset = config.menuHeightOffset

            ToggleAim:UpdateToggle(aimAssistActive)
            WallCheckToggle:UpdateToggle(wallCheckEnabled)
            TogglePermEsp:UpdateToggle(permEspEnabled)
            ToggleFriendEsp:UpdateToggle(friendEspEnabled)
            ToggleTargetEsp:UpdateToggle(targetEspEnabled)
            ToggleHP:UpdateToggle(showHPEnabled)
            ToggleModernEsp:UpdateToggle(modernEspEnabled) -- Обновление переключателя Modern ESP
            if modernEspEnabled then LoadModernESP() end -- Запуск Modern ESP при загрузке
            EnemyColorPicker:UpdateColor(enemyEspColor)
            FriendColorPicker:UpdateColor(friendEspColor)
            TargetColorPicker:UpdateColor(targetEspColor)
            HPColorPicker:UpdateColor(hpTextColor)
            HPSizeSlider:UpdateSlider(hpTextSize)
            TransparencySlider:UpdateSlider(espTransparency * 100)
            ESPSizeSlider:UpdateSlider(espSize.X)
            ToggleMenuKeybind:UpdateToggle(menuKeybindEnabled)
            MenuColorPicker:UpdateColor(menuColor)
            MenuTransparencySlider:UpdateSlider(menuTransparency * 100)
            PositionXSlider:UpdateSlider(menuPosition.X.Scale)
            PositionYSlider:UpdateSlider(menuPosition.Y.Scale)
            MenuWidthSlider:UpdateSlider(menuWidth)
            MenuHeightOffsetSlider:UpdateSlider(menuHeightOffset)
            CreateOrUpdateMenuGui()
            Library:CreateNotification('Config', 'Configuration loaded from MoonCheatConfig.json', 3)
        else
            Library:CreateNotification('Config', 'No config file found!', 3)
        end
    end

    local function SaveBind()
        local bindConfig = {
            aimKeybind = aimKeybind,
            whitelistKeybind = whitelistKeybind,
            toggleUIKeybind = toggleUIKeybind
        }

        local json = HttpService:JSONEncode(bindConfig)
        writefile("bindconfig.json", json)
        Library:CreateNotification('Binds', 'Keybinds saved to bindconfig.json', 3)
    end

    local function LoadBind()
        if isfile("bindconfig.json") then
            local json = readfile("bindconfig.json")
            local bindConfig = HttpService:JSONDecode(json)

            aimKeybind = bindConfig.aimKeybind or "T"
            whitelistKeybind = bindConfig.whitelistKeybind or "G"
            toggleUIKeybind = bindConfig.toggleUIKeybind or "E"

            AimKeybind:SetKey(aimKeybind)
            WhitelistKeybind:SetKey(whitelistKeybind)
            ToggleUIKeybind:SetKey(toggleUIKeybind)
            CreateOrUpdateMenuGui()
            Library:CreateNotification('Binds', 'Keybinds loaded from bindconfig.json', 3)
        else
            Library:CreateNotification('Binds', 'No bind config file found!', 3)
        end
    end

    ConfigSection:CreateButton('Save in Config', function()
        SaveConfig()
    end)

    ConfigSection:CreateButton('Load CFG', function()
        LoadConfig()
    end)

    ConfigSection:CreateButton('Save Bind', function()
        SaveBind()
    end)

    ConfigSection:CreateButton('Load Bind', function()
        LoadBind()
    end)

    -- Вкладка Link
    

    -- Основной цикл
    RunService.Heartbeat:Connect(function()
        if aimAssistActive then
            currentTarget = GetClosestPlayer()
            if currentTarget then
                local targetHead = currentTarget.Character and currentTarget.Character:FindFirstChild("Head")
                local targetHumanoid = currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid")
                if targetHead and targetHumanoid and targetHumanoid.Health > 0 then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                else
                    currentTarget = nil
                end
            end
        else
            currentTarget = nil
        end

        if permEspEnabled or friendEspEnabled or (aimAssistActive and targetEspEnabled) then
            ClearESP()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local isFriend = IsPlayerWhitelisted(player)
                    local isTarget = (aimAssistActive and player == currentTarget and targetEspEnabled)
                    
                    if isTarget then
                        espParts[player] = CreateESP(player, targetEspColor)
                    elseif isFriend and friendEspEnabled then
                        espParts[player] = CreateESP(player, friendEspColor)
                    elseif not isFriend and permEspEnabled then
                        espParts[player] = CreateESP(player, enemyEspColor)
                    end
                end
            end
        else
            ClearESP()
        end

        if showHPEnabled then
            ClearHPText()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") then
                    hpLabels[player] = CreateHPText(player)
                end
            end
        else
            ClearHPText()
        end
    end)

    spawn(function()
        while true do
            if menuKeybindEnabled then
                CreateOrUpdateMenuGui()
            end
            wait(0.3)
        end
    end)

    Players.PlayerAdded:Connect(UpdatePlayerList)
    Players.PlayerRemoving:Connect(function(player)
        UpdatePlayerList()
        espParts[player] = nil
        hpLabels[player] = nil
    end)
end

-- Автозагрузка скрипта
local function AutoExecute()
    local lastPlaceId = game.PlaceId
    LoadAimbotScript()

    while true do
        wait(1)
        if game.PlaceId ~= lastPlaceId then
            lastPlaceId = game.PlaceId
            LoadAimbotScript()
        end
    end
end

spawn(AutoExecute)]] -- Замените на содержимое encrypted_aimbot.lua
local key = 42 -- Тот же ключ, что при шифровании

local decryptedCode = xorDecrypt(encryptedCode, key)
loadstring(decryptedCode)()