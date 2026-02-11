--[[
    ----------------------------------------------------
    MERGED SCRIPT: WHITELIST + ZLX HUB
    ----------------------------------------------------
]]

-- // --- WHITELIST CONFIGURATION --- // --
local whitelist = {
    "PowerOFLukad", -- HIER deinen Namen reinschreiben
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
    "khohoi6",
}

-- // --- WHITELIST LOGIC (CLIENT SIDE ADAPTED) --- // --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local function checkWhitelist()
    local isWhitelisted = false
    for _, name in ipairs(whitelist) do
        if string.lower(LocalPlayer.Name) == string.lower(name) then
            isWhitelisted = true
            break
        end
    end
    return isWhitelisted
end

-- Wenn nicht gewhitelistet -> Kick & Stop Script
if not checkWhitelist() then
    LocalPlayer:Kick("⛔ You are not whitelisted for this Script! ⛔")
    return -- Stoppt das Script hier sofort
end

-- Wenn gewhitelistet -> Zeige Notification (in neuem Thread, damit Main Code sofort lädt)
task.spawn(function()
    local sg = Instance.new("ScreenGui")
    sg.Name = "WhitelistNotify"
    sg.ResetOnSpawn = false
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 220, 0, 60)
    frame.Position = UDim2.new(1, 10, 1, -70) -- Start rechts außen
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Parent = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 127) -- Grün
    stroke.Thickness = 2
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "Whitelist success! Loading..."
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.Parent = frame

    -- Animation Rein
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -230, 1, -70)
    })
    tweenIn:Play()

    -- Warten und rausfahren
    task.wait(4)
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 10, 1, -70)
    })
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        sg:Destroy()
    end)
end)

print("✅ Whitelist OK: " .. LocalPlayer.Name)

--[[
    ----------------------------------------------------
    MAIN CODE START (ZLX HUB)
    ----------------------------------------------------
]]

-- // SERVICES // --
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
-- Players ist oben schon definiert
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
-- TweenService ist oben schon definiert
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- LocalPlayer ist oben schon definiert
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local AnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))

-- // SETTINGS SYSTEM // --
local SETTINGS_FILE = "ZLX_Settings.json"
local CONFIG = {
    AUTO_STEAL_NEAREST = false,
    SPEED_HACK_TOGGLE = false,
    FRIENDS_ALLOWED = false -- Gespeicherte Einstellung für Friends
}

local function LoadSettings()
    if isfile and isfile(SETTINGS_FILE) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(SETTINGS_FILE)) end)
        if success and type(data) == "table" then
            for k, v in pairs(data) do CONFIG[k] = v end
        end
    end
end

local function SaveSettings()
    if writefile then writefile(SETTINGS_FILE, HttpService:JSONEncode(CONFIG)) end
end

LoadSettings()

-- // TELEPORT CONFIG // --
local WAYPOINT_1 = CFrame.new(-410.89, -6.11, 28.41)
local WAYPOINT_2 = CFrame.new(-408.59, -6.11, 119.49)
local WAYPOINT_3 = CFrame.new(-334.84, -4.65, 101.08)
local FINAL_DESTINATION = CFrame.new(-351.00, -7.30, 77.00) 

local isExecutingSequence = false
local canUseSpeedNow = true 

-- // SPEED CONFIG (ADJUSTED: +1 FASTER) // --
local BOOSTED_WALK_SPEED = 22 
local VELOCITY_MULT = 1.20

-- // NORRY'S DESYNC SYSTEM // --
local Config = {
    StrokeThickness = 2,
    ESPColor = Color3.fromRGB(255, 230, 0),
    BTNSColor = Color3.fromRGB(255, 170, 0),
    AnimDisable = false
}

local FFlags = {
    DisableDPIScale = "True",
    S2PhysicsSenderRate = "15000",
    AngularVelociryLimit = "360",
    StreamJobNOUVolumeCap = "2147483647",
    GameNetDontSendRedundantDeltaPositionMillionth = "1",
    TimestepArbiterOmegaThou = "1073741823",
    MaxMissedWorldStepsRemembered = "-2147483648",
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = "-5000",
    PhysicsSenderMaxBandwidthBps = "20000",
    LargeReplicatorEnabled9 = "True",
    CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = "1",
    TimestepArbiterHumanoidTurningVelThreshold = "1",
    MaxTimestepMultiplierAcceleration = "2147483647",
    SimOwnedNOUCountThresholdMillionth = "2147483647",
    SimExplicitlyCappedTimestepMultiplier = "2147483646",
    TimestepArbiterVelocityCriteriaThresholdTwoDt = "2147483646",
    CheckPVCachedVelThresholdPercent = "10",
    ReplicationFocusNouExtentsSizeCutoffForPauseStuds = "2147483647",
    InterpolationFramePositionThresholdMillionth = "5",
    DebugSendDistInSteps = "-2147483648",
    LargeReplicatorEnabled9 = "True",
    CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = "1",
    LargeReplicatorWrite5 = "True",
    NextGenReplicatorEnabledWrite4 = "True",
    MaxTimestepMultiplierContstraint = "2147483647",
    MaxTimestepMultiplierBuoyancy = "2147483647",
    MaxDataPacketPerSend = "2147483647",
    LargeReplicatorRead5 = "True",
    CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = "1",
    TimestepArbiterHumanoidLinearVelThreshold = "1",
    WorldStepMax = "30",
    InterpolationFrameVelocityThresholdMillionth = "5",
    LargeReplicatorSerializeRead3 = "True",
    GameNetPVHeaderLinearVelocityZeroCutoffExponent = "-5000",
    CheckPVCachedRotVelThresholdPercent = "10",
}

local animDisableConn = nil
local originalAnimIds = {}
local animateScript = nil

local ANIM_TYPES = {
    "walk", "run", "jump", "fall", "idle", "toolnone"
}

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = workspace

local fakePosESP = nil
local serverPosition = nil

local function cacheOriginalAnimations()
    local char = LocalPlayer.Character
    if not char then return false end
    
    animateScript = char:FindFirstChild("Animate")
    if not animateScript then return false end
    
    originalAnimIds = {}
    
    for _, animType in ipairs(ANIM_TYPES) do
        local animFolder = animateScript:FindFirstChild(animType)
        if animFolder then
            originalAnimIds[animType] = {}
            for _, anim in ipairs(animFolder:GetChildren()) do
                if anim:IsA("Animation") then
                    originalAnimIds[animType][anim.Name] = anim.AnimationId
                end
            end
        end
    end
    return true
end

local function disableAnimations()
    if not animateScript then return end
    
    for _, animType in ipairs(ANIM_TYPES) do
        local animFolder = animateScript:FindFirstChild(animType)
        if animFolder then
            for _, anim in ipairs(animFolder:GetChildren()) do
                if anim:IsA("Animation") then
                    anim.AnimationId = ""
                end
            end
        end
    end
    
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                track:Stop(0)
            end
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end
    animateScript = char:FindFirstChild("Animate")

    if not animateScript or not originalAnimIds then return end
    
    for animType, anims in pairs(originalAnimIds) do
        local animFolder = animateScript:FindFirstChild(animType)
        if animFolder then
            for animName, animId in pairs(anims) do
                local anim = animFolder:FindFirstChild(animName)
                if anim and anim:IsA("Animation") then
                    anim.AnimationId = animId
                end
            end
        end
    end
end

local function toggleAnimLoop(state)
    if state then
        if not next(originalAnimIds) then
            cacheOriginalAnimations()
        end
        
        if animDisableConn then animDisableConn:Disconnect() end
        animDisableConn = RunService.Heartbeat:Connect(function()
            if Config.AnimDisable then
                disableAnimations()
            end
        end)
    else
        if animDisableConn then
            animDisableConn:Disconnect()
            animDisableConn = nil
        end
        restoreAnimations()
    end
end

local function setFlags()
    for name, value in pairs(FFlags) do
        pcall(function()
            setfflag(tostring(name), tostring(value))
        end)
    end
end

local function respawn(plr)
    local rcdEnabled, wasHidden = false, false
    if gethidden then
        pcall(function()
             rcdEnabled, wasHidden = gethidden(workspace, 'RejectCharacterDeletions')
            ~= Enum.RejectCharacterDeletions.Disabled
        end)
    end

    if rcdEnabled and replicatesignal then
        replicatesignal(plr.ConnectDiedSignalBackend)
        task.wait(Players.RespawnTime - 0.1)
        replicatesignal(plr.Kill)
    else
        local char = plr.Character
        local hum = char:FindFirstChildWhichIsA('Humanoid')
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Dead)
        end
        char:ClearAllChildren()
        local newChar = Instance.new('Model')
        newChar.Parent = workspace
        plr.Character = newChar
        task.wait()
        plr.Character = char
        newChar:Destroy()
    end
end

function createESPVisual()
    local part = Instance.new("Part")
    part.Name = "ServerPosBox"
    part.Size = Vector3.new(4, 6, 2)
    part.Transparency = 1 
    part.Anchored = true
    part.CanCollide = false
    part.Parent = ESPFolder
    
    local box = Instance.new("SelectionBox")
    box.Name = "Outline"
    box.Adornee = part
    box.Parent = part
    box.Color3 = Config.ESPColor
    box.LineThickness = 0.10
    box.Transparency = 0
    box.SurfaceTransparency = 0.85
    
    local bb = Instance.new("BillboardGui")
    bb.Parent = part
    bb.Adornee = part
    bb.Size = UDim2.new(0, 100, 0, 50)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 4, 0)
    
    local text = Instance.new("TextLabel")
    text.Parent = bb
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "YOUR POSITION"
    text.TextColor3 = Config.ESPColor
    text.TextScaled = false
    text.TextSize = 10
    text.Font = Enum.Font.GothamBold
    text.TextStrokeTransparency = 0.5
    
    return part
end

local function trackServerPosition()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local success, result = pcall(function()
        return hrp:GetNetworkOwner()
    end)
    
    if success and result == nil then
    else
        local oldPos = hrp:GetPropertyChangedSignal("Position"):Connect(function()
            task.wait(0.15)
            local char = LocalPlayer.Character
            if char then
                local currentHRP = char:FindFirstChild("HumanoidRootPart")
                if currentHRP then
                    serverPosition = currentHRP.Position
                end
            end
        end)
    end
end

local function initializeESP()
    ESPFolder:ClearAllChildren()
    fakePosESP = createESPVisual()
    
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            serverPosition = hrp.Position
            fakePosESP.CFrame = CFrame.new(serverPosition)
            
            hrp:GetPropertyChangedSignal("CFrame"):Connect(function()
                task.wait(0.2)
                serverPosition = hrp.Position
            end)
        end
    end
    if Config.AnimDisable then
        task.wait(0.5)
        cacheOriginalAnimations()
    end
end

-- // NEW: GLOBAL DESYNC FUNCTION // --
local function ExecuteDesync()
    setFlags()
    respawn(LocalPlayer)
    
    -- Close GUI if open
    if CoreGui:FindFirstChild("DesyncControlUI") then CoreGui.DesyncControlUI:Destroy() end
    if PlayerGui:FindFirstChild("DesyncControlUI") then PlayerGui.DesyncControlUI:Destroy() end
    
    task.wait(5.1)
    initializeESP()
end

-- // STEAL & CIRCLE CONFIG // --
local allAnimalsCache = {}
local InternalStealCache = {}
local AUTO_STEAL_PROX_RADIUS = 100 
local IsStealing = false
local StealProgress = 0
local circleParts = {}
local PartsCount = 65
local PART_COLOR = Color3.fromRGB(180, 0, 255)

-- // CORE UTILITIES // --
local function getHRP()
    local char = LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
end

local function isMyBase(plotName)
    local plot = workspace.Plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") then return yourBase.Enabled == true end
    end
    return false
end

-- // SCANNER LOGIC // --
local function scanSinglePlot(plot)
    if not plot or not plot:IsA("Model") or isMyBase(plot.Name) then return end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return end
    for _, podium in ipairs(podiums:GetChildren()) do
        if podium:IsA("Model") and podium:FindFirstChild("Base") then
            local animalName = "Unknown"
            local spawn = podium.Base:FindFirstChild("Spawn")
            if spawn then
                for _, child in ipairs(spawn:GetChildren()) do
                    if child:IsA("Model") and child.Name ~= "PromptAttachment" then
                        animalName = child.Name
                        local animalInfo = AnimalsData[animalName]
                        if animalInfo and animalInfo.DisplayName then animalName = animalInfo.DisplayName end
                        break
                    end
                end
            end
            table.insert(allAnimalsCache, {
                name = animalName, plot = plot.Name, slot = podium.Name,
                worldPosition = podium:GetPivot().Position,
                uid = plot.Name .. "_" .. podium.Name,
            })
        end
    end
end

local function initializeScanner()
    task.wait(2)
    local plots = workspace:WaitForChild("Plots", 10)
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do scanSinglePlot(plot) end
    task.spawn(function()
        while task.wait(5) do
            allAnimalsCache = {}
            for _, plot in ipairs(plots:GetChildren()) do if plot:IsA("Model") then scanSinglePlot(plot) end end
        end
    end)
end

-- // STEAL CALLBACKS // --
local function findProximityPromptForAnimal(animalData)
    local plot = workspace.Plots:FindFirstChild(animalData.plot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    local podium = podiums and podiums:FindFirstChild(animalData.slot)
    local spawn = podium and podium.Base:FindFirstChild("Spawn")
    local attach = spawn and spawn:FindFirstChild("PromptAttachment")
    if attach then
        for _, p in ipairs(attach:GetChildren()) do if p:IsA("ProximityPrompt") then return p end end
    end
    return nil
end

local function buildStealCallbacks(prompt)
    if InternalStealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1) == "table" then
        for _, conn in ipairs(conns1) do if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end end
    end
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(conns2) == "table" then
        for _, conn in ipairs(conns2) do if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end end
    end
    if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then InternalStealCache[prompt] = data end
end

local function executeInternalStealAsync(prompt)
    local data = InternalStealCache[prompt]
    if not data or not data.ready then return end
    data.ready = false
    IsStealing = true
    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        local startTime = tick()
        while tick() - startTime < 1.3 do
            StealProgress = (tick() - startTime) / 1.3
            task.wait(0.05)
        end
        StealProgress = 1
        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
        task.wait(0.1)
        data.ready = true
        task.wait(0.3)
        IsStealing = false
        StealProgress = 0
    end)
end

-- // MAIN GUI CONSTRUCTION // --
local mainGui = Instance.new("ScreenGui", PlayerGui)
mainGui.Name = "ZLXHubMain"
mainGui.ResetOnSpawn = false

local dragFrame = Instance.new("Frame", mainGui)
-- **SIZE CHANGED HERE (HIGHER FOR NEW BUTTON)** --
dragFrame.Size = UDim2.new(0, 220, 0, 340) 
dragFrame.Position = UDim2.new(0.5, -110, 0.5, -170)
dragFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
dragFrame.BackgroundTransparency = 0.6 
dragFrame.BorderSizePixel = 0
Instance.new("UICorner", dragFrame).CornerRadius = UDim.new(0, 15)

local mainStroke = Instance.new("UIStroke", dragFrame)
mainStroke.Thickness = 2 
mainStroke.Color = Color3.fromRGB(160, 0, 255)

local title = Instance.new("TextLabel", dragFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ZLX HUB"
title.Font = Enum.Font.GothamBold; title.TextColor3 = Color3.fromRGB(200, 100, 255)
title.TextSize = 20
title.BackgroundTransparency = 1

local container = Instance.new("Frame", dragFrame)
container.Size = UDim2.new(0.9, 0, 0.75, 0); container.Position = UDim2.new(0.05, 0, 0.15, 0); container.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 8); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createBtn(txt, col)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, 0, 0, 32); 
    b.BackgroundTransparency = 0.5 
    b.Text = txt; b.Font = Enum.Font.GothamBold; b.TextColor3 = Color3.new(1,1,1); b.BackgroundColor3 = col; b.BorderSizePixel = 0
    b.TextSize = 12 
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local bs = Instance.new("UIStroke", b); bs.Thickness = 1; bs.Color = Color3.fromRGB(180, 0, 255)
    return b
end

-- BUTTON DEFINITIONS
local grabButton = createBtn("INSTA GRAB: OFF", Color3.fromRGB(25, 25, 25))
local speedBtn = createBtn("SPEED HACK: OFF", Color3.fromRGB(25, 25, 25))
-- NEW FRIENDS BUTTON
local friendsBtn = createBtn("FRIENDS: BLOCKED", Color3.fromRGB(25, 25, 25))
local startButton = createBtn("START TELEPORT (F)", Color3.fromRGB(60, 0, 150))
local desyncBtn = createBtn("INSTA DESYNC (K)", Color3.fromRGB(90, 0, 180)) 

local footer = Instance.new("TextLabel", dragFrame)
footer.Size = UDim2.new(1, 0, 0, 20); footer.Position = UDim2.new(0, 0, 0.93, 0); footer.Text = "discord.gg/768gtbVB28"
footer.TextColor3 = Color3.fromRGB(160, 0, 255); footer.Font = Enum.Font.Gotham; footer.TextSize = 10; footer.BackgroundTransparency = 1

local showbarFrame = Instance.new("Frame", dragFrame)
showbarFrame.Size = UDim2.new(0.9, 0, 0, 6)
showbarFrame.Position = UDim2.new(0.05, 0, 0.90, 0)
showbarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
showbarFrame.BackgroundTransparency = 0.5
Instance.new("UICorner", showbarFrame)
local progressBarFill = Instance.new("Frame", showbarFrame)
progressBarFill.Size = UDim2.new(0, 0, 1, 0); progressBarFill.BackgroundColor3 = Color3.fromRGB(180, 0, 255); Instance.new("UICorner", progressBarFill)

local function updateUI()
    grabButton.Text = CONFIG.AUTO_STEAL_NEAREST and "INSTA GRAB: ON" or "INSTA GRAB: OFF"
    grabButton.BackgroundColor3 = CONFIG.AUTO_STEAL_NEAREST and Color3.fromRGB(120, 0, 255) or Color3.fromRGB(25, 25, 25)
    
    speedBtn.Text = CONFIG.SPEED_HACK_TOGGLE and "SPEED HACK: ON" or "SPEED HACK: OFF"
    speedBtn.BackgroundColor3 = CONFIG.SPEED_HACK_TOGGLE and Color3.fromRGB(120, 0, 255) or Color3.fromRGB(25, 25, 25)
    
    if CONFIG.FRIENDS_ALLOWED then
        friendsBtn.Text = "FRIENDS: ALLOWED"
        friendsBtn.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
        friendsBtn.TextColor3 = Color3.new(0, 1, 0)
    else
        friendsBtn.Text = "FRIENDS: BLOCKED"
        friendsBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        friendsBtn.TextColor3 = Color3.new(1, 1, 1)
    end
end
updateUI()

-- // DRAGGABLE // --
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(dragFrame)

-- // FRIENDS LOGIC // --
local function toggleFriends()
    CONFIG.FRIENDS_ALLOWED = not CONFIG.FRIENDS_ALLOWED
    SaveSettings()
    updateUI()
    
    if CONFIG.FRIENDS_ALLOWED then
        -- Sucht nach allen ProximityPrompts die "allow" im Text haben
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local combinedText = (obj.ObjectText .. obj.ActionText):lower()
                if combinedText:find("allow") then 
                    fireproximityprompt(obj) 
                end
            end
        end
    end
end

-- // TELEPORT SEQUENCE // --
local function RunTeleportSequence()
    if isExecutingSequence then return end
    local hrp = getHRP()
    if not hrp then return end
    isExecutingSequence = true
    canUseSpeedNow = false
    
    hrp.CFrame = WAYPOINT_1; task.wait(0.1)
    hrp.CFrame = WAYPOINT_2; task.wait(0.1)
    hrp.CFrame = WAYPOINT_3
    
    CONFIG.AUTO_STEAL_NEAREST = true
    updateUI()
    
    task.wait(1.3)
    hrp.CFrame = FINAL_DESTINATION
    task.wait(0.2)
    
    CONFIG.AUTO_STEAL_NEAREST = false
    updateUI()
    isExecutingSequence = false
    canUseSpeedNow = true
end

-- // CLICK EVENTS // --
grabButton.MouseButton1Click:Connect(function() CONFIG.AUTO_STEAL_NEAREST = not CONFIG.AUTO_STEAL_NEAREST; updateUI(); SaveSettings() end)
speedBtn.MouseButton1Click:Connect(function() CONFIG.SPEED_HACK_TOGGLE = not CONFIG.SPEED_HACK_TOGGLE; updateUI(); SaveSettings() end)
friendsBtn.MouseButton1Click:Connect(toggleFriends) -- BUTTON CONNECT
startButton.MouseButton1Click:Connect(RunTeleportSequence)
desyncBtn.MouseButton1Click:Connect(ExecuteDesync)

-- // MAIN LOOPS // --
RunService.RenderStepped:Connect(function()
    progressBarFill.Size = IsStealing and UDim2.new(StealProgress, 0, 1, 0) or UDim2.new(0, 0, 1, 0)
    
    local hrp = getHRP()
    if hrp and #circleParts > 0 then
        for i, part in ipairs(circleParts) do
            local angle = math.rad(i * 360 / PartsCount)
            local pos = hrp.Position + Vector3.new(math.cos(angle) * AUTO_STEAL_PROX_RADIUS, -2.5, math.sin(angle) * AUTO_STEAL_PROX_RADIUS)
            part.CFrame = CFrame.new(pos, hrp.Position)
        end
    end
    
    if fakePosESP and serverPosition then
        fakePosESP.CFrame = fakePosESP.CFrame:Lerp(CFrame.new(serverPosition), 0.2)
    end
end)

RunService.Heartbeat:Connect(function()
    if CONFIG.SPEED_HACK_TOGGLE and canUseSpeedNow then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
            hrp.Velocity = Vector3.new(hum.MoveDirection.X * BOOSTED_WALK_SPEED * VELOCITY_MULT, hrp.Velocity.Y, hum.MoveDirection.Z * BOOSTED_WALK_SPEED * VELOCITY_MULT)
        end
    end

    if not CONFIG.AUTO_STEAL_NEAREST or IsStealing then return end
    local hrp = getHRP()
    if not hrp then return end
    local nearest, minDist = nil, math.huge
    for _, animalData in ipairs(allAnimalsCache) do
        local dist = (hrp.Position - animalData.worldPosition).Magnitude
        if dist < minDist and dist <= AUTO_STEAL_PROX_RADIUS then
            minDist = dist; nearest = animalData
        end
    end
    if nearest then
        local prompt = findProximityPromptForAnimal(nearest)
        if prompt then buildStealCallbacks(prompt); executeInternalStealAsync(prompt) end
    end
    
    trackServerPosition()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K then 
        ExecuteDesync() 
    elseif input.KeyCode == Enum.KeyCode.F then 
        RunTeleportSequence()
    elseif input.KeyCode == Enum.KeyCode.H then -- HOTKEY H
        toggleFriends()
    end
end)

-- // INIT // --
local function createCircle()
    for _, v in ipairs(circleParts) do v:Destroy() end
    circleParts = {}
    for i = 1, PartsCount do
        local p = Instance.new("Part", workspace)
        p.Anchored = true; p.CanCollide = false; p.Material = Enum.Material.Neon; p.Color = PART_COLOR; p.Transparency = 0.3
        p.Size = Vector3.new(1, 0.2, 0.3)
        table.insert(circleParts, p)
    end
end

initializeScanner()
createCircle()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.2)
    initializeESP()
    if Config.AnimDisable then
        task.wait(0.5)
        cacheOriginalAnimations()
    end
end)

if LocalPlayer.Character then
    task.wait(0.2)
    initializeESP()
    if Config.AnimDisable then
        task.wait(0.5)
        cacheOriginalAnimations()
    end
end

-- // Base Timer // --
local plotsFolder = workspace:FindFirstChild("Plots")
local baseEspInstances = {}
local espBaseThread

local function createBaseESP(plot, mainPart)
    if baseEspInstances[plot.Name] then
        baseEspInstances[plot.Name]:Destroy()
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "rznnq" .. plot.Name
    billboard.Size = UDim2.new(0, 50, 0, 25)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = mainPart
    billboard.MaxDistance = 1000
    billboard.Parent = plot
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.Arcade
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Parent = billboard
    baseEspInstances[plot.Name] = billboard
    return billboard
end

local function updateBaseESP()
    if not plotsFolder then return end

    for _, plot in ipairs(plotsFolder:GetChildren()) do
        local purchases = plot:FindFirstChild("Purchases")
        local plotBlock = purchases and purchases:FindFirstChild("PlotBlock")
        local mainPart = plotBlock and plotBlock:FindFirstChild("Main")
        local billboard = baseEspInstances[plot.Name]

        local timeLabel = mainPart
            and mainPart:FindFirstChild("BillboardGui")
            and mainPart.BillboardGui:FindFirstChild("RemainingTime")

        if timeLabel and mainPart then
            billboard = billboard or createBaseESP(plot, mainPart)
            local label = billboard:FindFirstChildWhichIsA("TextLabel")
            if label then
                label.Text = timeLabel.Text
            end
        elseif billboard then
            billboard:Destroy()
            baseEspInstances[plot.Name] = nil
        end
    end
end
espBaseThread = RunService.RenderStepped:Connect(updateBaseESP)
