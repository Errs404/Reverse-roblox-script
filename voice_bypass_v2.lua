--[[
  Voice Bypass V2 — Roblox Voice Suspension Bypass (AGGRESSIVE MODE)
  By: Errs404 // Squeezy

  Masalah dari V1:
    - Notif muncul ✓ (FFlag inject jalan)
    - Mic tetap mati ✗ (state ga ke-patch beneran)
    - GUI mic ilang ✗ (module voice ga di-load)

  Solusi V2:
    1. Deep GC/Registry Scan — inject langsung ke state internal voice module
    2. Manual Voice UI — bikin mic button dari 0 kalo Roblox ga mau nampilin
    3. Audio Capture Hook — paksa audio input device enable
    4. CoreScript Env Injection — akses langsung environment voice module
    5. Persistent State Spoof — tiap frame paksa state voice

  Cara pakai:
    Inject via executor. Sama kaya V1.
]]

-- // Configuration \\ --
local CONFIG = {
    AUTO_ENABLE = true,
    CREATE_MANUAL_UI = true,        -- Bikin UI mic manual kalo ga muncul
    DEEP_GC_SCAN = true,            -- Scan GC dalem-dalem
    PATCH_INTERNAL_MODULES = true,  -- Patch module internal voice
    HOOK_AUDIO = true,              -- Hook audio capture
    FORCE_VOICE_SETTINGS = true,    -- Paksa settings voice
    DEBUG = true,
    MIC_BUTTON_KEY = Enum.KeyCode.V, -- Tombol shortcut buat mic
}

-- // Services \\ --
local Services = setmetatable({}, { __index = function(t, k)
    local s = game:GetService(k)
    rawset(t, k, s)
    return s
end})

local Players = Services.Players
local CoreGui = Services.CoreGui
local RunService = Services.RunService
local UserInputService = Services.UserInputService
local VirtualInputManager = Services.VirtualInputManager
local TextChatService = Services.TextChatService
local StarterGui = Services.StarterGui

local LocalPlayer = Players.LocalPlayer

-- // Logger \\ --
local function log(msg, level)
    level = level or "[+]"
    if level == "[DEBUG]" and not CONFIG.DEBUG then return end
    print("[VoiceV2/" .. level .. "] " .. tostring(msg))
end

-- // Safe wrapper \\ --
local function try(...)
    local fn = select(1, ...)
    if type(fn) ~= "function" then return nil, "not a function" end
    local ok, result = pcall(fn, select(2, ...))
    if not ok then
        log(tostring(result), "[ERROR]")
        return nil, result
    end
    return result, nil
end

-- // Check executor capabilities \\ --
local EXECUTOR = {
    hookfunction = type(hookfunction) == "function",
    cloneref = type(cloneref) == "function",
    getgc = type(getgc) == "function",
    getreg = type(getreg) == "function",
    getsenv = type(getsenv) == "function",
    getscriptclosure = type(getscriptclosure) == "function",
    getupvalue = type(getupvalue) == "function",
    setupvalue = type(setupvalue) == "function",
    getconstants = type(getconstants) == "function",
    setconstant = type(setconstant) == "function",
    sethiddenproperty = type(sethiddenproperty) == "function",
    getconnections = type(getconnections) == "function",
    firetouchinterest = type(firetouchinterest) == "function",
    fireclickdetector = type(fireclickdetector) == "function",
    checkcaller = type(checkcaller) == "function",
    newcclosure = type(newcclosure) == "function",
    islclosure = type(islclosure) == "function",
    iscclosure = type(iscclosure) == "function",
    debug_getupvalue = type(debug) == "table" and type(debug.getupvalue) == "function",
    debug_setupvalue = type(debug) == "table" and type(debug.setupvalue) == "function",
    loadstring = type(loadstring) == "function",
}

local CAPS = {}
for k, v in pairs(EXECUTOR) do
    if v then table.insert(CAPS, k) end
end
log("Executor caps: " .. table.concat(CAPS, ", "), "[INFO]")

-- // Voice-related patterns buat scanning \\ --
local VOICE_KEYWORDS = {
    "voice", "voip", "mic", "microphone", "audio", "speaker",
    "eligible", "canuse", "chat", "speech", "record",
    "agora", "webrtc", "rtc", "media", "capture",
    "sound", "talk", "mute", "unmute", "deafen",
}

local function is_voice_related(str)
    if type(str) ~= "string" then return false end
    local lower = str:lower()
    for _, kw in ipairs(VOICE_KEYWORDS) do
        if lower:find(kw, 1, true) then return true end
    end
    return false
end


-- ============================================================================
-- METHOD 1: DEEP GC UPVALUE PATCH
-- ============================================================================
--[[
  Ini method paling powerful. Kita scan garbage collector buat cari:
    1. Closures (function) yang berhubungan sama voice
    2. Table state internal voice module
    3. Upvalues yang nyimpen boolean state

  Terus kita patch langsung upvalues itu biar selalu return true.
]]
local function deep_gc_upvalue_patch()
    log("[M1] Deep GC upvalue patching...")

    if not EXECUTOR.getgc then
        log("  getgc not available, skipping", "[SKIP]")
        return false
    end

    local patches = {
        tables = 0,
        upvalues = 0,
        constants = 0,
    }

    -- Phase 1: Scan all GC objects
    for _, obj in pairs(getgc(true)) do
        local t = type(obj)

        -- 1A: Tables — cari state internal voice module
        if t == "table" then
            -- Cari table yang isinya voice-related keys
            for k, v in pairs(obj) do
                local ks = tostring(k)
                if is_voice_related(ks) then
                    -- Patch boolean false -> true
                    if type(v) == "boolean" then
                        if not v then
                            obj[k] = true
                            patches.tables = patches.tables + 1
                            log("    Patched table[" .. ks .. "] = true", "[DEBUG]")
                        end
                    -- Patch number 0 -> 1 (enum value)
                    elseif type(v) == "number" and v == 0 then
                        obj[k] = 1
                        patches.tables = patches.tables + 1
                        log("    Patched table[" .. ks .. "] = 1", "[DEBUG]")
                    end
                end
            end

            -- Cari table yang child keys-nya voice-related
            -- (misal: { isEligible = false, canUseVoice = false })
            local voice_count = 0
            for k, _ in pairs(obj) do
                if is_voice_related(tostring(k)) then
                    voice_count = voice_count + 1
                end
            end
            -- Kalo ada 3+ voice keys, patch all booleans
            if voice_count >= 3 then
                for k, v in pairs(obj) do
                    if type(v) == "boolean" and not v then
                        obj[k] = true
                        patches.tables = patches.tables + 1
                        log("    Bulk patched " .. tostring(k) .. " = true", "[DEBUG]")
                    end
                end
            end
        end

        -- 1B: Functions — cari upvalues voice state
        if t == "function" and (EXECUTOR.getupvalue or EXECUTOR.debug_getupvalue) then
            local info
            local ok = pcall(debug.getinfo, obj)
            if ok then
                info = debug.getinfo(obj)
            end

            local is_voice_fn = false
            if info then
                local src = (info.name or "") .. " " .. (info.source or "")
                if is_voice_related(src) then
                    is_voice_fn = true
                end
            end

            -- Coba cari upvalues
            local idx = 1
            while true do
                local ok, name, val = pcall(debug.getupvalue, obj, idx)
                if not ok or not name then break end

                -- Patch upvalue boolean
                if type(val) == "boolean" and not val then
                    if is_voice_related(name) or is_voice_fn then
                        pcall(debug.setupvalue, obj, idx, true)
                        patches.upvalues = patches.upvalues + 1
                        log("    Patched upvalue " .. name .. " = true", "[DEBUG]")
                    end
                end

                -- Patch upvalue table (nested)
                if type(val) == "table" then
                    for k2, v2 in pairs(val) do
                        if is_voice_related(tostring(k2)) and type(v2) == "boolean" and not v2 then
                            val[k2] = true
                            patches.tables = patches.tables + 1
                            log("    Nested patch " .. tostring(k2) .. " = true", "[DEBUG]")
                        end
                    end
                end

                idx = idx + 1
            end

            -- 1C: Constants — patch constants di closure
            if EXECUTOR.getconstants then
                local ok2, constants = pcall(getconstants, obj)
                if ok2 and type(constants) == "table" then
                    for i, const in pairs(constants) do
                        if type(const) == "boolean" and not const then
                            -- Check kalo ini di voice function
                            if is_voice_fn then
                                pcall(setconstant, obj, i, true)
                                patches.constants = patches.constants + 1
                                log("    Patched constant[" .. i .. "] = true", "[DEBUG]")
                            end
                        end
                    end
                end
            end

            idx = 1
        end
    end

    log(string.format("  Total: %d table patches, %d upvalue patches, %d constant patches",
        patches.tables, patches.upvalues, patches.constants))
    return (patches.tables + patches.upvalues + patches.constants) > 0
end


-- ============================================================================
-- METHOD 2: CORE SCRIPT ENVIRONMENT INJECTION
-- ============================================================================
--[[
  Roblox voice chat di-implementasi di CoreScript (CoreGui.RobloxGui.Modules).
  Kita inject langsung ke environment modules itu pake getsenv/setupvalue.
]]
local function core_script_env_injection()
    log("[M2] CoreScript environment injection...")

    if not EXECUTOR.getsenv and not EXECUTOR.getgc then
        log("  getsenv/getgc not available", "[SKIP]")
        return false
    end

    -- Cari RobloxGui CoreScripts
    local robloxGui = CoreGui:FindFirstChild("RobloxGui")
    if not robloxGui then
        log("  No RobloxGui found in CoreGui", "[SKIP]")
        return false
    end
    log("  Found RobloxGui: " .. tostring(robloxGui))

    -- Phase 2A: Scan semua ModuleScript di CoreGui buat voice modules
    local voice_modules = {}
    for _, child in pairs(robloxGui:GetDescendants()) do
        if child:IsA("ModuleScript") and is_voice_related(child.Name) then
            table.insert(voice_modules, child)
            log("    Voice module: " .. child:GetFullName(), "[DEBUG]")
        end

        -- Cek parent chain
        local p = child.Parent
        while p and p ~= robloxGui do
            if is_voice_related(p.Name) then
                if child:IsA("ModuleScript") and not table.find(voice_modules, child) then
                    table.insert(voice_modules, child)
                    log("    Voice module (parent): " .. child:GetFullName(), "[DEBUG]")
                end
                break
            end
            p = p.Parent
        end
    end

    log("  Found " .. #voice_modules .. " voice-related modules")

    -- Phase 2B: Inject ke environment setiap voice module
    for _, module in pairs(voice_modules) do
        -- Dapatkan environment module
        local env
        if EXECUTOR.getsenv then
            env = try(function()
                return getsenv(module)
            end)
        end

        if not env then
            -- Fallback: coba require dan dapetin return value
            env = try(function()
                local result = require(module)
                if type(result) == "table" then return result end
                return nil
            end)
        end

        if type(env) == "table" then
            log("    Injecting into: " .. module.Name, "[DEBUG]")

            -- Patch semua boolean di environment
            local inject_count = 0
            for k, v in pairs(env) do
                local ks = tostring(k)

                -- Voice state booleans
                if is_voice_related(ks) and type(v) == "boolean" then
                    if not v then
                        env[k] = true
                        inject_count = inject_count + 1
                        log("      Env patch: " .. ks .. " = true", "[DEBUG]")
                    end
                end

                -- Nested tables di environment
                if type(v) == "table" then
                    for k2, v2 in pairs(v) do
                        if is_voice_related(tostring(k2)) and type(v2) == "boolean" and not v2 then
                            v[k2] = true
                            inject_count = inject_count + 1
                            log("      Nested env patch: " .. tostring(k2) .. " = true", "[DEBUG]")
                        end
                    end
                end

                -- Functions di environment — cek upvalues
                if type(v) == "function" and EXECUTOR.getupvalue then
                    local ui = 1
                    while true do
                        local ok2, uv_name, uv_val = pcall(debug.getupvalue, v, ui)
                        if not ok2 or not uv_name then break end

                        if type(uv_val) == "boolean" and not uv_val and is_voice_related(uv_name) then
                            pcall(debug.setupvalue, v, ui, true)
                            inject_count = inject_count + 1
                            log("      Fn upvalue patch: " .. uv_name .. " = true", "[DEBUG]")
                        end
                        ui = ui + 1
                    end
                end
            end

            log("    Injected " .. inject_count .. " patches into " .. module.Name)
        end
    end

    -- Phase 2C: Cari voice module via getgc (fallback)
    if EXECUTOR.getgc then
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "table" then
                -- Cari table dengan signature voice state
                local has_voice_state = false
                local voice_keys = {"isEligible", "canUseVoice", "voiceEnabled", "isMuted", "micEnabled"}
                for _, vk in ipairs(voice_keys) do
                    if obj[vk] ~= nil then
                        has_voice_state = true
                        break
                    end
                end

                if has_voice_state then
                    for k, v in pairs(obj) do
                        if type(v) == "boolean" and not v then
                            local ks = tostring(k):lower()
                            if not (ks:find("mute") or ks:find("ban") or ks:find("suspend") or ks:find("block")) then
                                obj[k] = true
                                log("      Voice state patch: " .. tostring(k) .. " = true", "[DEBUG]")
                            end
                        end
                    end
                end
            end
        end
    end

    return true
end


-- ============================================================================
-- METHOD 3: AUDIO CAPTURE HOOK
-- ============================================================================
--[[
  Force-enable audio capture di Roblox.
  Kita hook fungsi-fungsi audio biar selalu return true.
]]
local function audio_capture_hook()
    log("[M3] Audio capture hooking...")

    if not EXECUTOR.hookfunction and not EXECUTOR.getgc then
        log("  hookfunction/getgc not available", "[SKIP]")
        return false
    end

    -- Cari dan hook audio-related functions
    local hooked = 0

    -- Scan GC buat fungsi audio capture
    if EXECUTOR.getgc then
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "function" then
                local info = try(function()
                    return debug.getinfo(obj)
                end)
                if type(info) == "table" then
                    local name = (info.name or "") .. " " .. (info.source or "")
                    if is_voice_related(name) or
                       name:lower():find("capture") or
                       name:lower():find("microphone") or
                       name:lower():find("audioinput") or
                       name:lower():find("sound") then

                        -- Cek upvalues buat boolean yang bisa dipatch
                        if EXECUTOR.getupvalue then
                            local ui = 1
                            while true do
                                local ok2, uv_name, uv_val = pcall(debug.getupvalue, obj, ui)
                                if not ok2 or not uv_name then break end
                                if type(uv_val) == "boolean" and not uv_val then
                                    local uv_lower = uv_name:lower()
                                    if uv_lower:find("enable") or uv_lower:find("active") or
                                       uv_lower:find("allow") or uv_lower:find("capture") then
                                        pcall(debug.setupvalue, obj, ui, true)
                                        hooked = hooked + 1
                                        log("    Patched audio upvalue: " .. uv_name, "[DEBUG]")
                                    end
                                end
                                ui = ui + 1
                            end
                        end

                        -- Hook function kalo executable
                        if EXECUTOR.hookfunction and EXECUTOR.checkcaller then
                            local ok3, name3 = pcall(function()
                                -- Coba hook
                                local old_env = getsenv(obj)
                                -- (complex hook logic skipped for now)
                            end)
                        end
                    end
                end
            end
        end
    end

    log("  Audio hooks applied: " .. hooked)
    return hooked > 0
end


-- ============================================================================
-- METHOD 4: MANUAL VOICE UI CREATOR
-- ============================================================================  
--[[
  Kalo Roblox ga mau nampilin voice UI (mic button), kita bikin sendiri.
  Ini biar user punya kontrol mic.
]]
local function create_manual_voice_ui()
    log("[M4] Creating manual voice UI...")

    -- Cek kalo voice UI udah ada (dari Roblox atau dari kita)
    local function find_existing_mic_button()
        -- Cari di CoreGui
        for _, child in pairs(CoreGui:GetDescendants()) do
            local n = child.Name or ""
            local nl = n:lower()
            if (nl:find("mic") or nl:find("voice") or nl:find("talk")) and
               (child:IsA("ImageButton") or child:IsA("ImageLabel") or child:IsA("TextButton")) then
                return child
            end
        end
        -- Cari di PlayerGui
        if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
            for _, child in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                local n = child.Name or ""
                local nl = n:lower()
                if (nl:find("mic") or nl:find("voice")) and
                   (child:IsA("ImageButton") or child:IsA("ImageLabel")) then
                    return child
                end
            end
        end
        return nil
    end

    local existing = find_existing_mic_button()
    if existing then
        log("  Voice UI already exists: " .. existing:GetFullName())
        -- Enable visible
        try(function()
            existing.Visible = true
            existing.Active = true
            if existing:IsA("ImageButton") then
                existing.Enabled = true
            end
            -- Cari parent dan enable
            local p = existing.Parent
            while p and p ~= CoreGui do
                if p:IsA("GuiObject") then
                    p.Visible = true
                end
                p = p.Parent
            end
        end)
        return true
    end

    if not CONFIG.CREATE_MANUAL_UI then
        log("  Manual UI creation disabled in config", "[SKIP]")
        return false
    end

    -- Create manual voice UI
    log("  Creating manual voice UI...")

    -- Cari parent yang tepat
    local parent = try(function()
        -- Coba taruh di CoreGui
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "VoiceBypassUI"
        screenGui.DisplayOrder = 999999
        screenGui.ResetOnSpawn = false
        screenGui.Parent = CoreGui
        return screenGui
    end)

    if not parent then
        -- Fallback: taruh di PlayerGui
        parent = try(function()
            if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
                local sg = Instance.new("ScreenGui")
                sg.Name = "VoiceBypassUI"
                sg.DisplayOrder = 999999
                sg.ResetOnSpawn = false
                sg.Parent = LocalPlayer.PlayerGui
                return sg
            end
            return nil
        end)
    end

    if not parent then
        log("  Failed to create UI parent", "[ERROR]")
        return false
    end

    -- Protect GUI kalo ada API
    try(function()
        if type(syn) == "table" and type(syn.protect_gui) == "function" then
            syn.protect_gui(parent)
        elseif type(protect_gui) == "function" then
            protect_gui(parent)
        end
    end)

    -- ===== MIC BUTTON =====
    local micFrame = Instance.new("Frame")
    micFrame.Name = "VoiceMicButton"
    micFrame.Size = UDim2.new(0, 48, 0, 48)
    micFrame.Position = UDim2.new(0.5, -24, 1, -64)
    micFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    micFrame.BackgroundTransparency = 0.3
    micFrame.BorderSizePixel = 0
    micFrame.Parent = parent

    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 24)
    corner.Parent = micFrame

    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 180, 75)
    stroke.Thickness = 2
    stroke.Parent = micFrame

    -- Button
    local micButton = Instance.new("ImageButton")
    micButton.Name = "MicButton"
    micButton.Size = UDim2.new(1, 0, 1, 0)
    micButton.BackgroundTransparency = 1
    micButton.BorderSizePixel = 0

    -- Roblox mic icon (Mute/unmute icon dari built-in)
    -- Fallback: pake teks kalo ga bisa load image
    local micLabel = Instance.new("TextLabel")
    micLabel.Name = "MicIcon"
    micLabel.Size = UDim2.new(1, 0, 1, 0)
    micLabel.BackgroundTransparency = 1
    micLabel.Text = "🎤"
    micLabel.TextSize = 24
    micLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    micLabel.Font = Enum.Font.GothamBold
    micLabel.Parent = micButton

    micButton.Parent = micFrame

    -- Status indicator
    local statusDot = Instance.new("Frame")
    statusDot.Name = "StatusDot"
    statusDot.Size = UDim2.new(0, 10, 0, 10)
    statusDot.Position = UDim2.new(1, -5, 1, -5)
    statusDot.BackgroundColor3 = Color3.fromRGB(60, 180, 75)  -- Green = active
    statusDot.BorderSizePixel = 0

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0, 5)
    dotCorner.Parent = statusDot

    statusDot.Parent = micFrame

    -- Drag functionality
    local dragging = false
    local dragStart = nil
    local frameStart = nil

    micButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            frameStart = micFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            micFrame.Position = UDim2.new(
                frameStart.X.Scale,
                frameStart.X.Offset + delta.X,
                frameStart.Y.Scale,
                frameStart.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- MIC STATE
    local micEnabled = true

    local function updateMicUI()
        if micEnabled then
            stroke.Color = Color3.fromRGB(60, 180, 75)   -- Green
            statusDot.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
            micLabel.Text = "🎤"
            micLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            stroke.Color = Color3.fromRGB(220, 60, 60)   -- Red
            statusDot.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
            micLabel.Text = "🔇"
            micLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end

    -- Toggle mic
    local function toggleMic()
        micEnabled = not micEnabled
        updateMicUI()

        -- Coba toggle juga di sistem Roblox
        try(function()
            -- Fire voice chat input
            if UserInputService then
                -- Simulasi push-to-talk key
                if micEnabled then
                    VirtualInputManager:SendKeyEvent(true, CONFIG.MIC_BUTTON_KEY, false, game)
                else
                    VirtualInputManager:SendKeyEvent(true, CONFIG.MIC_BUTTON_KEY, false, game)
                end
                task.wait(0.1)
                if not micEnabled then
                    VirtualInputManager:SendKeyEvent(false, CONFIG.MIC_BUTTON_KEY, false, game)
                end
            end
        end)

        -- Set hidden property kalo ada
        try(function()
            if EXECUTOR.sethiddenproperty and LocalPlayer then
                sethiddenproperty(LocalPlayer, "Muted", not micEnabled)
            end
        end)

        -- Patch GC state
        try(function()
            if EXECUTOR.getgc then
                for _, obj in pairs(getgc(true)) do
                    if type(obj) == "table" then
                        if obj.isMuted ~= nil and type(obj.isMuted) == "boolean" then
                            obj.isMuted = not micEnabled
                        end
                        if obj.muted ~= nil and type(obj.muted) == "boolean" then
                            obj.muted = not micEnabled
                        end
                    end
                end
            end
        end)

        log("  Mic toggled: " .. (micEnabled and "ON" or "OFF"))
    end

    micButton.MouseButton1Click:Connect(toggleMic)

    -- Keyboard shortcut
    local keyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == CONFIG.MIC_BUTTON_KEY then
            toggleMic()
        end
    end)

    updateMicUI()

    log("  Custom voice UI created successfully!")
    log("  Click mic button or press V to toggle mic")

    -- Notification
    try(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Voice UI Injected",
            Text = "Mic button added! Click it or press V to toggle.",
            Duration = 4,
        })
    end)

    return true
end


-- ============================================================================
-- METHOD 5: VoiceChatService INSTANCE PATCH
-- ============================================================================
--[[
  Patch langsung VoiceChatService instance + buat kalo perlu.
]]
local function voice_service_patch()
    log("[M5] VoiceChatService instance patching...")

    -- Cari atau buat VoiceChatService
    local vcs = Services.VoiceChatService
    if not vcs then
        vcs = try(function()
            return game:GetService("VoiceChatService")
        end)
    end
    if not vcs then
        vcs = try(function()
            local inst = Instance.new("VoiceChatService")
            inst.Name = "VoiceChatService"
            inst.Parent = game
            return inst
        end)
    end

    if not vcs then
        log("  Could not get/create VoiceChatService", "[ERROR]")
        return false
    end

    log("  VoiceChatService: " .. tostring(vcs))

    -- Hidden properties
    local hidden_props = {
        VoiceChatEnabled = true,
        VoiceChatAllowed = true,
        IsVoiceEnabled = true,
        CanUseVoice = true,
        VoiceChatEligible = true,
    }

    for prop, val in pairs(hidden_props) do
        try(function()
            if EXECUTOR.sethiddenproperty then
                sethiddenproperty(vcs, prop, val)
                log("    Set " .. prop .. " = " .. tostring(val), "[DEBUG]")
            end
        end)
    end

    -- Hook functions
    if EXECUTOR.hookfunction then
        local function_names = {
            "IsVoiceEnabled",
            "CanUseVoice",
            "GetVoiceChatEligibility",
            "VoiceChatEnabled",
        }

        for _, fn_name in pairs(function_names) do
            local fn = vcs[fn_name]
            if type(fn) == "function" then
                try(function()
                    vcs[fn_name] = hookfunction(fn, function(self, ...)
                        -- Kalo fungsi dipanggil tanpa self (global call)
                        -- atau dari caller kita (checkcaller)
                        return true
                    end)
                    log("    Hooked " .. fn_name)
                end)
            end
        end
    end

    -- Fire events
    local events_to_fire = {
        "VoiceEligibilityCheck",
        "EligibilityChanged",
        "VoiceChatEnabled",
        "OnVoiceChatEnabled",
    }

    for _, ev_name in pairs(events_to_fire) do
        local ev = vcs:FindFirstChild(ev_name)
        if ev then
            try(function()
                if ev:IsA("BindableEvent") then
                    ev:Fire(true)
                    log("    Fired event: " .. ev_name)
                elseif ev:IsA("RemoteEvent") then
                    ev:FireServer(true)
                    log("    Fired remote: " .. ev_name)
                end
            end)
        end
    end

    return true
end


-- ============================================================================
-- METHOD 6: TEXTCHAT VOICE INTEGRATION
-- ============================================================================
--[[
  Roblox pake TextChatService buat chat + voice integration.
  Kita patch ini juga.
]]
local function textchat_voice_patch()
    log("[M6] TextChatService voice patching...")

    if not TextChatService then
        log("  No TextChatService", "[SKIP]")
        return false
    end

    -- Cari voice-related objects di TextChatService
    for _, child in pairs(TextChatService:GetDescendants()) do
        if is_voice_related(child.Name) then
            log("  Found: " .. child:GetFullName(), "[DEBUG]")
            try(function()
                if child:IsA("BindableEvent") then
                    child:Fire(true)
                elseif child:IsA("BoolValue") then
                    child.Value = true
                end
            end)
        end
    end

    -- Patch hidden properties
    local props = {
        "VoiceChatEnabled",
        "VoiceChatAllowed",
        "IsVoiceEnabled",
    }
    for _, prop in pairs(props) do
        try(function()
            if EXECUTOR.sethiddenproperty then
                sethiddenproperty(TextChatService, prop, true)
            end
        end)
    end

    return true
end


-- ============================================================================
-- METHOD 7: AGGRO HEAP STATE PATCH
-- ============================================================================
--[[
  Last resort: patch EVERY boolean di memory yang related ke voice.
  Brutal scan + replace.
]]
local function aggro_heap_patch()
    log("[M7] Aggressive heap state patching...")

    if not EXECUTOR.getgc and not EXECUTOR.getreg then
        log("  getgc/getreg not available", "[SKIP]")
        return false
    end

    local total_patches = 0
    local scanned = {
        gco = 0,
        reg = 0,
    }

    -- Scan getgc
    if EXECUTOR.getgc then
        for _, obj in pairs(getgc(true)) do
            scanned.gco = scanned.gco + 1

            if type(obj) == "table" then
                -- Check if this table has ANY voice-related content
                -- atau ini bagian dari voice module
                for k, v in pairs(obj) do
                    local ks = tostring(k):lower()

                    -- Patch: eligible-related
                    if (ks:find("eligible") or ks:find("eligibility")) and type(v) == "boolean" then
                        if not v then
                            obj[k] = true
                            total_patches = total_patches + 1
                        end
                        continue
                    end

                    -- Patch: voice status
                    if ks:find("canuse") and type(v) == "boolean" then
                        if not v then
                            obj[k] = true
                            total_patches = total_patches + 1
                        end
                        continue
                    end

                    -- Patch: provider active
                    if (ks:find("provider") or ks:find("agora") or ks:find("rtc") or
                        ks:find("webrtc") or ks:find("mediastream")) and type(v) == "boolean" then
                        if not v then
                            obj[k] = true
                            total_patches = total_patches + 1
                        end
                        continue
                    end

                    -- Patch: permission
                    if (ks:find("permission") or ks:find("allow") or
                        ks:find("authorize") or ks:find("grant")) and type(v) == "boolean" then
                        if not v then
                            obj[k] = true
                            total_patches = total_patches + 1
                        end
                        continue
                    end

                    -- Patch: active/enabled
                    if (ks == "active" or ks == "enabled" or ks == "connected") and type(v) == "boolean" then
                        -- Cuma patch kalo parent table-nya voice-related
                        for pk in pairs(obj) do
                            if is_voice_related(tostring(pk)) then
                                if not v then
                                    obj[k] = true
                                    total_patches = total_patches + 1
                                end
                                break
                            end
                        end
                        continue
                    end
                end
            end
        end
    end

    -- Scan getreg (registry)
    if EXECUTOR.getreg then
        for _, obj in pairs(getreg()) do
            scanned.reg = scanned.reg + 1
            if type(obj) == "table" then
                for k, v in pairs(obj) do
                    if is_voice_related(tostring(k)) and type(v) == "boolean" and not v then
                        obj[k] = true
                        total_patches = total_patches + 1
                    end
                end
            end
        end
    end

    log(string.format("  Scanned %d GC objects, %d registry objects", scanned.gco, scanned.reg))
    log("  Total aggressive patches: " .. total_patches)
    return total_patches > 0
end


-- ============================================================================
-- METHOD 8: PERSISTENT STATE LOOP (V2)
-- ============================================================================
--[[
  Improved version: tiap frame force state + fire events.
]]
local function persistent_state_loop()
    log("[M8] Starting persistent state loop (V2)...")

    local heartbeat = RunService.Heartbeat or RunService.RenderStepped
    if not heartbeat then
        log("  No heartbeat available", "[SKIP]")
        return nil
    end

    local frame_count = 0
    local connection = heartbeat:Connect(function()
        frame_count = frame_count + 1
        if not CONFIG.AUTO_ENABLE then return end

        -- [A] Force VoiceChatService state
        local vcs = Services.VoiceChatService
        if vcs and EXECUTOR.sethiddenproperty then
            pcall(sethiddenproperty, vcs, "VoiceChatEnabled", true)
            pcall(sethiddenproperty, vcs, "CanUseVoice", true)
            pcall(sethiddenproperty, vcs, "VoiceChatAllowed", true)
        end

        -- [B] Force LocalPlayer state
        if LocalPlayer and EXECUTOR.sethiddenproperty then
            pcall(sethiddenproperty, LocalPlayer, "CanUseVoice", true)
            pcall(sethiddenproperty, LocalPlayer, "VoiceChatAllowed", true)
            pcall(sethiddenproperty, LocalPlayer, "VoiceChatEligible", true)
            pcall(sethiddenproperty, LocalPlayer, "Muted", false)
        end

        -- [C] Force voice UI visibility (every 30 frames)
        if frame_count % 30 == 0 then
            for _, child in pairs(CoreGui:GetDescendants()) do
                local n = child.Name:lower()
                if (n:find("voice") or n:find("mic")) then
                    if child:IsA("GuiObject") then
                        child.Visible = true
                        child.Active = true
                    end
                    if child:IsA("ImageButton") then
                        child.Enabled = true
                    end
                    -- Enable parent chain
                    local p = child.Parent
                    while p and p:IsA("GuiObject") do
                        p.Visible = true
                        p.Active = true
                        p = p.Parent
                    end
                end
            end
        end

        -- [D] Force GC state (every 60 frames)
        if frame_count % 60 == 0 and EXECUTOR.getgc then
            for _, obj in pairs(getgc(true)) do
                if type(obj) == "table" then
                    -- Patch mute state
                    if obj.isMuted == true then obj.isMuted = false end
                    if obj.muted == true then obj.muted = false end

                    -- Re-patch voice enable
                    for k, v in pairs(obj) do
                        local ks = tostring(k):lower()
                        if (ks == "canusevoice" or ks == "voicechatenabled" or
                            ks == "iscapable" or ks == "isenabled" or
                            ks == "voiceeligible" or ks == "iseligible" or
                            ks == "active") and type(v) == "boolean" and not v then
                            obj[k] = true
                        end
                    end
                end
            end
        end
    end)

    log("  Persistent loop active")
    return connection
end


-- ============================================================================
-- METHOD 9: TRIGGER CORESCRIPTS VOICE MODULE
-- ============================================================================
--[[
  Trigger Roblox internal voice module buat jalan.
  Cari voice module di CoreScripts dan require ulang.
]]
local function trigger_core_voice_module()
    log("[M9] Triggering CoreScript voice module...")

    local robloxGui = CoreGui:FindFirstChild("RobloxGui")
    if not robloxGui then
        log("  No RobloxGui", "[SKIP]")
        return false
    end

    -- Cari semua voice modules
    local modules = {}
    for _, child in pairs(robloxGui:GetDescendants()) do
        if child:IsA("ModuleScript") then
            local path = child:GetFullName():lower()
            local name = child.Name:lower()

            -- Cari module yang explicitly voice
            if name:find("voice") or name:find("voip") or name:find("mic") then
                table.insert(modules, child)
                log("  Found voice module: " .. child:GetFullName(), "[DEBUG]")
            elseif path:find("voice") and child:IsA("ModuleScript") then
                table.insert(modules, child)
                log("  Found voice module (path): " .. child:GetFullName(), "[DEBUG]")
            end
        end

        -- Cari juga LocalScript yang handle voice
        if child:IsA("LocalScript") and (
            child.Name:lower():find("voice") or
            child.Name:lower():find("mic") or
            child.Name:lower():find("audio")
        ) then
            log("  Found voice script: " .. child:GetFullName(), "[DEBUG]")
            -- Clone dan run
            try(function()
                local clone = child:Clone()
                clone.Disabled = false
                clone.Parent = child.Parent
                -- Clone biar jalan lagi
                local newScript = Instance.new("LocalScript")
                newScript.Name = "VoiceBypass_" .. child.Name
                newScript.Source = child.Source
                newScript.Parent = child.Parent
                log("  Cloned and re-ran: " .. child.Name)
            end)
        end
    end

    -- Require ulang module
    for _, module in pairs(modules) do
        try(function()
            -- Disable dulu
            module.Source = module.Source  -- Trigger change
            -- Require
            local result = require(module)
            log("  Re-required module: " .. module.Name)
            -- Kalo return table, patch isinya
            if type(result) == "table" then
                for k, v in pairs(result) do
                    if type(v) == "boolean" and not v then
                        result[k] = true
                        log("    Patched module result: " .. tostring(k), "[DEBUG]")
                    end
                end
            end
        end)
    end

    return #modules > 0
end


-- ============================================================================
-- MAIN EXECUTION
-- ============================================================================
local function main()
    log("==========================================")
    log("  Voice Bypass V2 — AGGRESSIVE MODE")
    log("  by Errs404 // Squeezy")
    log("==========================================")

    log("LocalPlayer: " .. tostring(LocalPlayer))
    log("Executor capabilities: " .. #CAPS .. " available")

    -- Execute all methods in order
    local methods = {
        { name = "VoiceChatService Patch",     fn = voice_service_patch },
        { name = "TextChat Voice Patch",       fn = textchat_voice_patch },
        { name = "Deep GC Upvalue Patch",      fn = deep_gc_upvalue_patch },
        { name = "CoreScript Env Injection",   fn = core_script_env_injection },
        { name = "Trigger Core Voice Module",  fn = trigger_core_voice_module },
        { name = "Audio Capture Hook",         fn = audio_capture_hook },
        { name = "Aggressive Heap Patch",      fn = aggro_heap_patch },
        { name = "Create Manual Voice UI",     fn = create_manual_voice_ui },
    }

    for _, method in ipairs(methods) do
        log("")
        local ok, result = pcall(method.fn)
        if ok then
            log("[OK] " .. method.name)
        else
            log("[FAIL] " .. method.name .. ": " .. tostring(result), "[ERROR]")
        end
    end

    -- Start persistent loop
    log("")
    persistent_state_loop()

    log("")
    log("==========================================")
    log("  V2 Bypass executed!")
    log("  - Mic UI should appear (green dot = active)")
    log("  - Click mic or press V to toggle")
    log("  - Jika masih tidak ada, re-inject")
    log("==========================================")
end

-- Run
local ok, err = pcall(main)
if not ok then
    log("FATAL: " .. tostring(err), "[FATAL]")
    if debug and debug.traceback then
        log("Trace: " .. debug.traceback(), "[FATAL]")
    end
end

-- Return module table
return {
    CONFIG = CONFIG,
    deep_gc_upvalue_patch = deep_gc_upvalue_patch,
    core_script_env_injection = core_script_env_injection,
    audio_capture_hook = audio_capture_hook,
    create_manual_voice_ui = create_manual_voice_ui,
    aggro_heap_patch = aggro_heap_patch,
}


--[[
/// V2 ARCHITECTURE ///

Masalah:
  V1 cuma patch public API (VoiceChatService functions).
  Tapi CoreScript voice module pake internal state yang di-cache
  di closures dan upvalues — ga kena patch public API.

Solusi V2:
  1. Deep GC Patch — inject langsung ke closures via upvalues
  2. Env Injection — akses environment module langsung
  3. Manual UI — fallback UI kalo Roblox ga nampilin
  4. Aggro Scan — brute force patch semua boolean di heap

Roblox Voice Flow:
  CoreScript voice module (CoreGui.RobloxGui.Modules)
    -> Check eligibility via internal API (bukan public)
    -> Store state di closures (upvalues)
    -> Create UI elements (ImageButton mic, etc.)
    -> Handle audio via audio capture API

  Yang kita exploit:
    - Upvalues: state boolean di closures
    - Env: variable di module environment
    - GC: semua object di garbage collector
    - HiddenProps: properties yang hidden dari Lua
    
  Yang GA bisa kita bypass:
    - Server-side token generation
    - WebRTC/Agora connection (butuh auth dari server)
    - Audio relay (server must forward audio)
]]
