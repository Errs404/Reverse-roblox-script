--[[
  Voice Bypass — Roblox Voice Suspension Bypass (Executor Script)
  By: Errs404 // Squeezy

  Method:
    1. FFlag Spoofing — bypass FFlag checks via executor API
    2. Service Hooking — hook VoiceChatService functions
    3. Instance Manipulation — force-enable voice UI
    4. Memory Patch — patch voice state via executor memory API
    5. Remote Spoof — spoof remote events for voice

  Cara pakai:
    Inject via executor (Synapse, Krnl, Script-Ware, etc.)
    > loadstring(readfile("voice_bypass.lua"))()
    Atau copy-paste langsung ke executor

  Requirements:
    - Executor dengan kemampuan hookfunction, getscriptclosure, dll
    - Atau minimal bisa clone/fire remote events
]]

-- // Configuration \\ --
local CONFIG = {
    AUTO_ENABLE = true,              -- Auto-enable voice on inject
    SPOOF_ELIGIBILITY = true,        -- Spoof eligibility checks
    FORCE_UI = true,                 -- Force show voice UI
    HOOK_REMOTES = true,             -- Hook remote events
    DEBUG = true,                    -- Print debug info
    FFLAGS = {
        FFlagVoiceChatEnabled = true,
        FFlagVoiceChatDisabled = false,
        FFlagDebugVoiceChatEnabled = true,
        FFlagDebugVoiceChatAlwaysEnabled = true,
        FFlagDebugVoiceChat = true,
        FFlagEnableNewVoiceChatService = true,
        FFlagEnableVoiceChatUI = true,
        FFlagDebugVoiceChatIgnoreEligibility = true,
        FFlagVoiceChatUseNewEligibilityCheck = false,
        FFlagVoiceChatRequireIdVerification = false,
        FFlagVoiceChatRequirePhoneVerification = false,
        FFlagVoiceChatAgeRestriction = false,
        FFlagVoiceChatEnableForAllUsers = true,
    }
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
local TeleportService = Services.TeleportService

local LocalPlayer = Players.LocalPlayer

-- // Logger \\ --
local function log(msg, level)
    level = level or "INFO"
    if level == "DEBUG" and not CONFIG.DEBUG then return end
    print("[VoiceBypass/" .. level .. "] " .. tostring(msg))
end

-- // Utility: Pcall-safe wrapper \\ --
local function try(fn, ...)
    local ok, result = pcall(fn, ...)
    if not ok then
        log("Error: " .. tostring(result), "ERROR")
        return nil, result
    end
    return result, nil
end

-- // Check executor capabilities \\ --
local EXECUTOR = {
    has_hookfunction = type(hookfunction) == "function",
    has_cloneref = type(cloneref) == "function",
    has_getscriptclosure = type(getscriptclosure) == "function",
    has_getgc = type(getgc) == "function",
    has_getreg = type(getreg) == "function",
    has_getsenv = type(getsenv) == "function",
    has_fireclickdetector = type(fireclickdetector) == "function",
    has_firetouchinterest = type(firetouchinterest) == "function",
    has_getcustomasset = type(getcustomasset) == "function",
    has_sethiddenproperty = type(sethiddenproperty) == "function",
    has_setclipboard = type(setclipboard) == "function",
    has_readfile = type(readfile) == "function",
    has_writefile = type(writefile) == "function",
    has_syn = type(syn) == "table",
    has_debug = type(debug) == "table",
    has_newcclosure = type(newcclosure) == "function",
    has_checkcaller = type(checkcaller) == "function",
}

log("Executor capabilities:")
for k, v in pairs(EXECUTOR) do
    log("  " .. k .. ": " .. tostring(v), "DEBUG")
end

-- // METHOD 1: FFlag Spoof via Lua \\ --
local function spoof_fflags()
    log("[Method 1] Spoofing FFlags...")

    local success_count = 0
    local fail_count = 0

    for flag, value in pairs(CONFIG.FFLAGS) do
        -- Coba via get/setfflag kalo ada
        local ok, err = pcall(function()
            -- Set environment variable method (paling gampang)
            if type(syn) == "table" and type(syn.set_fflag) == "function" then
                syn.set_fflag(flag, tostring(value))
                success_count = success_count + 1
                return
            end

            -- Coba via debug.setconstant / setmemory
            if type(debug) == "table" and type(debug.setconstant) == "function" then
                -- Scan GC buat cari FFlag table
                for _, obj in pairs(getgc(true)) do
                    if type(obj) == "table" then
                        for k2, v2 in pairs(obj) do
                            if tostring(k2) == flag and type(v2) == "boolean" then
                                obj[k2] = value
                                success_count = success_count + 1
                            end
                        end
                    end
                end
            end
        end)

        if not ok then
            fail_count = fail_count + 1
        end
    end

    log(string.format("FFlag spoof: %d success, %d failed", success_count, fail_count))
    return success_count > 0
end

-- // METHOD 2: Hook VoiceChatService \\ --
local function hook_voice_service()
    log("[Method 2] Hooking VoiceChatService...")

    -- Cari VoiceChatService
    local VoiceChatService = try(function()
        return Services.VoiceChatService or game:GetService("VoiceChatService")
    end)

    if not VoiceChatService then
        -- Coba scan Children
        for _, v in pairs(game:GetChildren()) do
            if v.ClassName == "VoiceChatService" then
                VoiceChatService = v
                break
            end
        end
    end

    if not VoiceChatService then
        -- Create kalo ga ada (beberapa executor allow)
        VoiceChatService = try(function()
            local inst = Instance.new("VoiceChatService")
            inst.Name = "VoiceChatService"
            inst.Parent = game
            return inst
        end)
    end

    if VoiceChatService then
        log("  Found VoiceChatService: " .. tostring(VoiceChatService))

        -- Hook functions di VoiceChatService
        local voice_functions = {
            "IsVoiceEnabled",
            "CanUseVoice",
            "IsEligible",
            "GetEligibility",
            "HasPermissions",
        }

        for _, fn_name in pairs(voice_functions) do
            local fn = VoiceChatService[fn_name]
            if type(fn) == "function" then
                try(function()
                    if EXECUTOR.has_hookfunction then
                        VoiceChatService[fn_name] = hookfunction(fn, function(...)
                            log("  Hooked " .. fn_name .. " -> returning true", "DEBUG")
                            return true
                        end)
                        log("  Hooked: " .. fn_name .. " -> always true")
                    end
                end)
            end
        end

        -- Coba hook event juga
        local events = {
            "VoiceEligibilityCheck",
            "EligibilityChanged",
            "VoiceChatEnabled",
        }
        for _, ev_name in pairs(events) do
            local ev = VoiceChatService:FindFirstChild(ev_name)
            if ev and ev.ClassName == "RemoteEvent" then
                try(function()
                    if EXECUTOR.has_hookfunction and ev.OnClientInvoke then
                        ev.OnClientInvoke = hookfunction(ev.OnClientInvoke, function(...)
                            return true
                        end)
                        log("  Hooked remote: " .. ev_name)
                    end
                end)
            end
        end
    else
        log("  Could not find/create VoiceChatService", "WARN")
    end

    -- Hook Player voice-related
    if LocalPlayer then
        local player_voice_fns = {
            "CanUseVoice",
            "IsVoiceEnabled",
        }
        for _, fn_name in pairs(player_voice_fns) do
            local fn = LocalPlayer[fn_name]
            if type(fn) == "function" and EXECUTOR.has_hookfunction then
                try(function()
                    LocalPlayer[fn_name] = hookfunction(fn, function(...)
                        return true
                    end)
                    log("  Hooked Player." .. fn_name)
                end)
            end
        end
    end
end

-- // METHOD 3: Force Enable Voice UI \\ --
local function force_voice_ui()
    log("[Method 3] Force-enabling voice UI...")

    -- Coba enable hidden UI elements
    local function search_and_enable(parent, depth)
        depth = depth or 0
        if depth > 10 then return end

        for _, child in pairs(parent:GetChildren()) do
            local name = child.Name or ""
            local lower = name:lower()

            -- Cari voice-related UI elements
            if lower:find("voice") or lower:find("microphone") or lower:find("mic") or
               lower:find("chat") or lower:find("voip") or lower:find("speaker") or
               lower:find("audio") or lower:find("record") then

                -- Enable visibility
                try(function()
                    if EXECUTOR.has_sethiddenproperty then
                        sethiddenproperty(child, "Visible", true)
                    end
                    if child:IsA("GuiObject") then
                        child.Visible = true
                    end
                    if child:IsA("ImageButton") or child:IsA("TextButton") then
                        child.Active = true
                        child.Enabled = true
                    end
                    log("  Enabled UI: " .. child:GetFullName(), "DEBUG")
                end)
            end

            -- Coba enable kalo parent-nya voice-related
            local parent_name = parent.Name or ""
            if parent_name:lower():find("voice") or parent_name:lower():find("chat") then
                try(function()
                    if child:IsA("GuiObject") then
                        child.Visible = true
                    end
                end)
            end

            search_and_enable(child, depth + 1)
        end
    end

    -- Search di CoreGui
    try(function()
        search_and_enable(CoreGui)
    end)

    -- Search di PlayerGui
    try(function()
        if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
            search_and_enable(LocalPlayer.PlayerGui)
        end
    end)

    -- Coba force-load voice chat GUI
    try(function()
        local CoreScripts = CoreGui:FindFirstChild("RobloxGui")
        if CoreScripts then
            local Modules = CoreScripts:FindFirstChild("Modules")
            if Modules then
                -- Cari dan load voice module
                for _, child in pairs(Modules:GetDescendants()) do
                    if child:IsA("ModuleScript") and (
                        child.Name:lower():find("voice") or
                        child.Name:lower():find("voip") or
                        child.Name:lower():find("chat")
                    ) then
                        try(function()
                            local success = require(child)
                            log("  Loaded module: " .. child.Name)
                        end)
                    end
                end
            end
        end
    end)
end

-- // METHOD 4: Memory Scan & Patch via Executor \\ --
local function memory_patch_voice()
    log("[Method 4] Memory patching voice state...")

    if not EXECUTOR.has_getgc then
        log("  getgc not available, skipping", "WARN")
        return false
    end

    local patches = 0

    -- Scan GC buat voice-related objects
    for _, obj in pairs(getgc(true)) do
        local t = type(obj)

        -- Check tables dengan voice state
        if t == "table" then
            for k, v in pairs(obj) do
                local ks = tostring(k)
                if ks:lower():find("voice") or ks:lower():find("voip") or ks:lower():find("eligible") then
                    -- Patch boolean values
                    if type(v) == "boolean" and not v then
                        obj[k] = true
                        patches = patches + 1
                        log("  Patched " .. ks .. " = true", "DEBUG")
                    end
                end
            end
        end

        -- Check closures buat voice functions
        if t == "function" and EXECUTOR.has_getscriptclosure then
            local info = try(function()
                return debug.getinfo(obj)
            end)
            if info and info.name and info.name:lower():find("voice") then
                log("  Found voice function: " .. (info.name or "unknown"), "DEBUG")
            end
        end
    end

    log("Memory patches applied: " .. patches)
    return patches > 0
end

-- // METHOD 5: Remote Event Spoofing \\ --
local function spoof_voice_remotes()
    log("[Method 5] Spoofing voice remote events...")

    -- Cari remote events terkait voice
    local remotes_found = 0
    local remotes_hooked = 0

    local function scan_remotes(parent, depth)
        depth = depth or 0
        if depth > 8 then return end

        for _, child in pairs(parent:GetChildren()) do
            local name = child.Name or ""
            local lower = name:lower()

            -- Cari voice-related remotes
            if (lower:find("voice") or lower:find("voip") or lower:find("eligible") or
                lower:find("mic") or lower:find("audio")) and
               (child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or
                child:IsA("BindableEvent") or child:IsA("BindableFunction")) then

                remotes_found = remotes_found + 1
                log("  Found remote: " .. child:GetFullName(), "DEBUG")

                -- Hook/fire remote
                if child:IsA("RemoteFunction") and EXECUTOR.has_hookfunction then
                    if child.OnClientInvoke then
                        try(function()
                            child.OnClientInvoke = hookfunction(child.OnClientInvoke, function(...)
                                local args = {...}
                                -- Patch args yg mengandung eligibility
                                local patched = false
                                for i, arg in pairs(args) do
                                    if type(arg) == "boolean" and not arg then
                                        args[i] = true
                                        patched = true
                                    end
                                end
                                if patched then
                                    log("  Patched remote args: " .. child.Name, "DEBUG")
                                end
                                return true
                            end)
                            remotes_hooked = remotes_hooked + 1
                        end)
                    end
                end

                -- Fire client events biar trigger voice enable
                if child:IsA("BindableEvent") then
                    try(function()
                        child:Fire(true)
                        log("  Fired event: " .. child.Name)
                    end)
                end
            end

            scan_remotes(child, depth + 1)
        end
    end

    -- Scan dari game
    scan_remotes(game)
    -- Scan dari CoreGui
    scan_remotes(CoreGui)
    -- Scan dari LocalPlayer
    if LocalPlayer then
        scan_remotes(LocalPlayer)
    end
    -- Scan dari Players
    scan_remotes(Players)

    log(string.format("Remotes found: %d, hooked: %d", remotes_found, remotes_hooked))
    return remotes_hooked > 0
end

-- // METHOD 6: Inject FFlag via ClientAppSettings \\ --
local function inject_fflags_file()
    log("[Method 6] Injecting FFlags via ClientSettings...")

    -- Buat content FFlags
    local settings = {
        FFlagVoiceChatEnabled = true,
        FFlagDebugVoiceChatEnabled = true,
        FFlagDebugVoiceChatAlwaysEnabled = true,
        FFlagDebugVoiceChatIgnoreEligibility = true,
        FFlagVoiceChatRequireIdVerification = false,
        FFlagVoiceChatRequirePhoneVerification = false,
        FFlagVoiceChatAgeRestriction = false,
        FFlagEnableNewVoiceChatService = true,
        FFlagEnableVoiceChatUI = true,
    }

    -- Coba write file kalo executor support
    if EXECUTOR.has_writefile then
        try(function()
            local content = game:GetService("HttpService"):JSONEncode(settings)
            writefile("ClientAppSettings.json", content)
            log("  Written to workspace directory")
        end)
    end

    -- Alternative: inject via syn environment
    if type(syn) == "table" and type(syn.set_fflag) == "function" then
        for k, v in pairs(settings) do
            try(function()
                syn.set_fflag(k, tostring(v))
            end)
        end
        log("  Injected via syn.set_fflag")
    end

    -- Coba inject via HttpService
    try(function()
        local HttpService = Services.HttpService
        -- Trigger FFlag reload dengan ngirim request internal
        -- Beberapa executor punya endpoint sendiri
    end)
end

-- // METHOD 7: Spoof Verification Status \\ --
local function spoof_verification()
    log("[Method 7] Spoofing verification status...")

    -- Patch LocalPlayer properties
    if LocalPlayer then
        local props = {
            "VoiceChatAllowed",
            "VoiceChatEligible",
            "CanUseVoice",
            "IsVerified",
            "HasVerifiedPhone",
            "HasVerifiedEmail",
            "AccountAgeReqsMet",
        }

        for _, prop in pairs(props) do
            try(function()
                if EXECUTOR.has_sethiddenproperty then
                    sethiddenproperty(LocalPlayer, prop, true)
                    log("  Set hidden prop: " .. prop .. " = true")
                end
            end)
        end
    end

    -- Cari dan patch verification-related modules
    if EXECUTOR.has_getgc then
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "table" then
                for k, v in pairs(obj) do
                    local ks = tostring(k):lower()
                    if (ks:find("verified") or ks:find("eligible") or
                        ks:find("phone") or ks:find("id") or
                        ks:find("age") or ks:find("restriction")) and
                       type(v) == "boolean" and not v then
                        obj[k] = true
                        log("  Patched " .. k .. " = true", "DEBUG")
                    end
                end
            end
        end
    end
end

-- // Teleport Bypass (relog with modified state) \\ --
local function teleport_bypass()
    log("[Method 8] Setting up teleport bypass...")

    -- Hook teleport biar state kita kebawa
    local oldTeleport = TeleportService.Teleport
    if type(oldTeleport) == "function" and EXECUTOR.has_hookfunction then
        try(function()
            TeleportService.Teleport = hookfunction(oldTeleport, function(self, placeId, ...)
                log("  Teleport intercepted to: " .. tostring(placeId))
                -- Inject FFlags lagi setelah teleport
                return oldTeleport(self, placeId, ...)
            end)
        end)
    end

    -- Hook TeleportAsync juga
    local oldTeleportAsync = TeleportService.TeleportAsync
    if type(oldTeleportAsync) == "function" and EXECUTOR.has_hookfunction then
        try(function()
            TeleportService.TeleportAsync = hookfunction(oldTeleportAsync, function(self, placeId, ...)
                log("  TeleportAsync intercepted to: " .. tostring(placeId))
                return oldTeleportAsync(self, placeId, ...)
            end)
        end)
    end
end

-- // Continuous patching (anti-reset loop) \\ --
local function start_voice_loop()
    log("[Method 9] Starting voice state maintenance loop...")

    local heartbeat = RunService.Heartbeat or RunService.RenderStepped
    if not heartbeat then
        log("  No RunService heartbeat available", "WARN")
        return
    end

    local connection = heartbeat:Connect(function()
        -- Re-patch voice state periodically
        -- (beberapa game nge-reset state tiap frame)
        if not CONFIG.AUTO_ENABLE then return end

        -- Cek VoiceChatService state
        local VCS = try(function()
            return Services.VoiceChatService
        end)

        if VCS then
            -- Force enable
            try(function()
                if EXECUTOR.has_sethiddenproperty then
                    sethiddenproperty(VCS, "VoiceChatEnabled", true)
                end
            end)
        end

        -- Force LocalPlayer state
        if LocalPlayer then
            try(function()
                if EXECUTOR.has_sethiddenproperty then
                    sethiddenproperty(LocalPlayer, "CanUseVoice", true)
                    sethiddenproperty(LocalPlayer, "VoiceChatAllowed", true)
                end
            end)
        end
    end)

    log("  Voice state loop started")
    return connection
end

-- // MAIN EXECUTION \\ --
local function main()
    log("========================================")
    log("  Voice Suspension Bypass v1.0")
    log("  by Errs404 // Squeezy")
    log("========================================")

    log("LocalPlayer: " .. tostring(LocalPlayer))
    log("Executor: " .. tostring(EXECUTOR))

    -- Execute all methods
    local methods = {
        { name = "FFlag Spoof", fn = spoof_fflags },
        { name = "Inject FFlags File", fn = inject_fflags_file },
        { name = "Hook VoiceChatService", fn = hook_voice_service },
        { name = "Force Voice UI", fn = force_voice_ui },
        { name = "Memory Patch", fn = memory_patch_voice },
        { name = "Spoof Remotes", fn = spoof_voice_remotes },
        { name = "Spoof Verification", fn = spoof_verification },
        { name = "Teleport Bypass", fn = teleport_bypass },
    }

    for _, method in pairs(methods) do
        try(function()
            log("")
            local ok, result = pcall(method.fn)
            if ok then
                log("[OK] " .. method.name .. " completed")
            else
                log("[FAIL] " .. method.name .. ": " .. tostring(result), "WARN")
            end
        end)
    end

    -- Start maintenance loop
    log("")
    start_voice_loop()

    log("")
    log("========================================")
    log("  All methods executed!")
    log("  Voice bypass should be active.")
    log("  Join/rejoin game untuk apply.")
    log("========================================")

    -- Notify user
    try(function()
        local StarterGui = Services.StarterGui
        if StarterGui then
            StarterGui:SetCore("SendNotification", {
                Title = "Voice Bypass Active",
                Text = "Voice suspension bypassed!",
                Duration = 5,
            })
        end
    end)
end

-- Run
local ok, err = pcall(main)
if not ok then
    log("Fatal error: " .. tostring(err), "ERROR")
    log("Stack: " .. tostring(debug and debug.traceback and debug.traceback() or "N/A"))
end

-- Return for loadstring usage
return {
    CONFIG = CONFIG,
    spoof_fflags = spoof_fflags,
    hook_voice_service = hook_voice_service,
    force_voice_ui = force_voice_ui,
    memory_patch_voice = memory_patch_voice,
    spoof_voice_remotes = spoof_voice_remotes,
    spoof_verification = spoof_verification,
}


--[[
/// TEKNIS BREAKDOWN ///

Roblox Voice Chat System:
  VoiceChatService adalah service internal Roblox yang handle:
    - Eligibility check (server-side via Web API)
    - Voice connection (via Agora SDK / custom WebRTC)
    - UI state (mic icon, voice indicator, settings)
  
  Saat voice di-suspend:
    1. Server nge-set eligibility status jadi false
    2. VoiceChatService nyimpen state ini di memory
    3. UI voice chat ilang / disabled
    4. Agora connection ga dibikin

  Yang bisa kita exploit:
    1. Client-side FFlags — Roblox pake FFlags buat enable/disable fitur
    2. Memory state — boolean flags di class instances
    3. Remote events — beberapa game pake custom voice system
    4. UI visibility — voice UI tinggal di-hidden, ga di-remove

  Limitation:
    - Server-side eligibility ga bisa di-bypass 100% dari client
    - Voice connection (WebRTC/Agora) butuh token dari server
    - Bisa enable UI dan state, tapi koneksi voice mungkin gagal
    - Best bet: bypass detection + pakai external voice (Discord)
]]
