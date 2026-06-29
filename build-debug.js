/**
 * build-debug.js — Generate Reverse-Control-DEBUG.lua
 *
 * Reads Reverse-Control.lua, injects:
 *   1. Debug GUI overlay (ScreenGui with ScrollingFrame)
 *   2. xpcall wrapping in loadModule()
 *   3. Error catching in init() task.spawn
 *   4. print/warn/error → screen override
 *
 * Output: Reverse-Control-DEBUG.lua
 */

const fs = require('fs');
const path = require('path');

const INPUT = path.join(__dirname, 'Reverse-Control.lua');
const OUTPUT = path.join(__dirname, 'Reverse-Control-DEBUG.lua');

// ── Debug overlay code ───────────────────────────────────────────────────────
const DEBUG_OVERLAY = `
--[[
  DEBUG OVERLAY — injected by build-debug.js
  Creates on-screen visual console inside the Roblox game window.
]]
do
	-- Services
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local player = Players.LocalPlayer

	-- Wait for PlayerGui
	local playerGui = player:WaitForChild("PlayerGui")

	-- Create main GUI (hidden until we have modules loaded)
	local gui = Instance.new("ScreenGui")
	gui.Name = "DebugConsole"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = playerGui

	-- Background
	local bg = Instance.new("Frame")
	bg.Name = "Background"
	bg.Size = UDim2.new(1, 0, 0, 250)
	bg.Position = UDim2.new(0, 0, 0, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 0.35
	bg.BorderSizePixel = 0
	bg.Parent = gui

	-- Title bar
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 24)
	title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	title.BackgroundTransparency = 0.2
	title.BorderSizePixel = 0
	title.Text = "DEBUG CONSOLE"
	title.TextColor3 = Color3.fromRGB(0, 255, 128)
	title.TextSize = 14
	title.Font = Enum.Font.SourceSansBold
	title.Parent = bg

	-- ScrollingFrame for log lines
	local logFrame = Instance.new("ScrollingFrame")
	logFrame.Name = "LogFrame"
	logFrame.Size = UDim2.new(1, 0, 1, -24)
	logFrame.Position = UDim2.new(0, 0, 0, 24)
	logFrame.BackgroundTransparency = 1
	logFrame.BorderSizePixel = 0
	logFrame.ScrollBarThickness = 6
	logFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
	logFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	logFrame.Parent = bg

	local layout = Instance.new("UIListLayout")
	layout.Parent = logFrame
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local MAX_LOG_LINES = 80
	local logCount = 0

	-- Log function
	local function addLog(level, message)
		local color = (level == "error" and Color3.fromRGB(255, 60, 60))
			or (level == "warn" and Color3.fromRGB(255, 200, 60))
			or Color3.fromRGB(200, 200, 200)

		local prefix = (level == "error" and "[ERR]")
			or (level == "warn" and "[WRN]")
			or "[INF]"

		local line = Instance.new("TextLabel")
		line.Name = "LogLine"
		line.Text = prefix .. " " .. tostring(message):sub(1, 300)
		line.TextColor3 = color
		line.TextSize = 12
		line.Font = Enum.Font.SourceSans
		line.TextXAlignment = Enum.TextXAlignment.Left
		line.RichText = true
		line.BackgroundTransparency = 1
		line.BorderSizePixel = 0
		line.Size = UDim2.new(1, -10, 0, 18)
		line.Parent = logFrame

		logCount = logCount + 1

		-- Remove old lines
		while logCount > MAX_LOG_LINES do
			local children = logFrame:GetChildren()
			local oldest = nil
			for _, child in ipairs(children) do
				if child:IsA("TextLabel") and child.Name == "LogLine" then
					oldest = child
					break
				end
			end
			if oldest then
				oldest:Destroy()
				logCount = logCount - 1
			else
				break
			end
		end

		-- Auto-scroll to bottom
		task.defer(function()
			logFrame.CanvasPosition = Vector2.new(0, logFrame.AbsoluteCanvasSize.Y)
		end)
	end

	-- Override print / warn / error
	local oldPrint = print
	local oldWarn = warn
	local oldError = error

	print = function(...)
		local parts = {}
		for i = 1, select("#", ...) do
			parts[i] = tostring(select(i, ...))
		end
		addLog("info", table.concat(parts, "\\t"))
		oldPrint(...)
	end

	warn = function(...)
		local parts = {}
		for i = 1, select("#", ...) do
			parts[i] = tostring(select(i, ...))
		end
		addLog("warn", table.concat(parts, "\\t"))
		oldWarn(...)
	end

	error = function(msg, level)
		local tb = debug and debug.traceback(tostring(msg), (level or 1) + 1) or tostring(msg)
		addLog("error", tb)
		oldError(msg, level)
	end

	-- Expose debug logger globally so patched runtime can reach it
	_G.__debugLog = addLog
	_G.__debugGui = gui
	_G.__debugReady = true

	-- Initial log
	addLog("info", "Debug overlay loaded. Waiting for modules...")
end

-- Helper: patched loadModule with xpcall
do
	-- We'll override loadModule and init AFTER they're defined below.
	-- Store a hook that the runtime's loadModule will call.
	_G.__debugOriginalLoadModule = nil  -- set later
end

`

// ── Build ────────────────────────────────────────────────────────────────────
function build() {
	let src = fs.readFileSync(INPUT, 'utf-8');

	// Split into parts
	// Runtime: lines 1-154 (end of init function)
	// Blank separator: lines 155-156
	// Module definitions: lines 157-220
	// Blank: 221
	// init(): 222

	// Find the position of "local function init()"
	const initFuncStart = src.indexOf('local function init()');
	if (initFuncStart === -1) throw new Error('Could not find init() function');

	// Find the end of init() - it ends with "end" before the module definitions
	// The pattern is: init() function body, then "end", then blank lines, then newInstance/newModule calls

	// Let's find the position where newInstance("Reverse Community" starts
	const moduleStart = src.indexOf('newInstance("Reverse Community"');
	if (moduleStart === -1) throw new Error('Could not find module definitions start');

	// The runtime ends just before moduleStart
	const runtimeEnd = moduleStart;
	// Find the last "end" before moduleStart
	const lastEnd = src.lastIndexOf('end', moduleStart);
	if (lastEnd === -1) throw new Error('Could not find end of init()');

	// The runtime includes everything up to and including the last "end" before modules
	// Actually let's find the actual end of the init function properly
	// Pattern: 
	//   end  -- ends for object loop
	//   end  -- ends init function
	//   (blank lines)
	//   newInstance...

	// Let me find where init() body ends (the "end" that closes the for loop + the "end" that closes init)
	// Find the "end" that is right before module definitions
	let runtimeText = src.substring(0, runtimeEnd);
	// Get the last non-empty, non-comment lines before moduleStart
	let lines = runtimeText.split('\n');
	// Remove trailing empty lines
	while (lines.length > 0 && lines[lines.length - 1].trim() === '') {
		lines.pop();
	}
	// The last line should be "end" (closing init function)
	// Let's find the actual split point properly

	// Actually, simpler approach: split at the module definitions start
	const part1 = src.substring(0, moduleStart);  // runtime + blank lines
	const part2 = src.substring(moduleStart);      // module definitions + init() call

	// Now we need to insert our patched functions between part1 and part2
	// The patched functions will override the locals defined in part1

	const PATCHED_FUNCTIONS = `
--[[
  PATCHED RUNTIME — wraps loadModule and init with xpcall error handling
  Overrides the local functions defined above.
]]
do
	-- Reference the original loadModule (defined above in runtime)
	-- We need to patch the module loading to catch errors

	-- Save original loadModule reference for patching
	local origLoadModule = loadModule
	local origInit = init

	-- Patched loadModule with xpcall wrapping
	local function patchedLoadModule(obj, this)
		local cleanup = this and validateRequire(obj, this)
		local module = modules[obj]

		if module.isLoaded then
			if cleanup then cleanup() end
			return module.value
		else
			-- WRAP in xpcall
			local ok, data = xpcall(module.fn, function(err)
				local tb = debug.traceback(tostring(err), 3)
				return tb
			end)
			if ok then
				module.value = data
				module.isLoaded = true
				if cleanup then cleanup() end
				return data
			else
				-- Error occurred — log it and re-raise
				module.value = nil
				module.isLoaded = true  -- mark as loaded to prevent re-try loops
				if cleanup then cleanup() end
				local errMsg = "Module '" .. tostring(obj.Name) .. "' FAILED:\\\\n" .. tostring(data)
				if _G.__debugLog then
					_G.__debugLog("error", errMsg)
				end
				error(errMsg, 0)
			end
		end
	end

	-- Patched init with spawn error catching
	local function patchedInit()
		if not game:IsLoaded() then
			game.Loaded:Wait()
		end

		if _G.__debugLog then
			_G.__debugLog("info", "init() called — spawning " .. tostring(#modules) .. " modules")
		end

		local spawnCount = 0
		local errorCount = 0
		for object in pairs(modules) do
			if object:IsA("LocalScript") and not object.Disabled then
				spawnCount = spawnCount + 1
				local moduleName = object.Name
				task.spawn(function()
					local ok, err = xpcall(function()
						patchedLoadModule(object)
					end, function(e)
						local tb = debug.traceback(tostring(e), 2)
						return tb
					end)
					if not ok then
						errorCount = errorCount + 1
						if _G.__debugLog then
							_G.__debugLog("error", "init spawn: " .. moduleName .. " — " .. tostring(err))
						end
					else
						if _G.__debugLog then
							_G.__debugLog("info", "Module loaded: " .. moduleName)
						end
					end
				end)
			end
		end

		if _G.__debugLog then
			_G.__debugLog("info", "init() spawned " .. tostring(spawnCount) .. " modules")
		end

		-- Wait a bit then show final status
		task.delay(3, function()
			if _G.__debugLog then
				if errorCount > 0 then
					_G.__debugLog("warn", "--- " .. tostring(errorCount) .. " module(s) failed to load! ---")
				else
					_G.__debugLog("info", "--- All modules loaded OK ---")
				end
			end
		end)
	end

	-- Override the local functions by replacing in the module table assignments
	-- Since loadModule and init are local, we need to overwrite them
	loadModule = patchedLoadModule
	init = patchedInit
end

`

	// Build final output: overlay + runtime + patches + modules + init()
	let output = DEBUG_OVERLAY + '\n' + part1 + '\n' + PATCHED_FUNCTIONS + '\n' + part2;

	// Replace the original init() call with patchedInit()
	// Actually, init = patchedInit is set above, so calling init() at the end calls the patched version
	// No change needed there

	// Now replace the original loadModule usage inside init() with our patched version
	// Since we reassigned loadModule = patchedLoadModule, the original init() called loadModule
	// But we replaced init entirely, so this doesn't matter

	// Write output
	fs.writeFileSync(OUTPUT, output, 'utf-8');

	console.log('✅ Generated: ' + OUTPUT);
	console.log('   Size: ' + (output.length / 1024).toFixed(1) + ' KB');

	// Verify the output has the key pieces
	const checks = [
		['DebugConsole ScreenGui', output.includes('ScreenGui') && output.includes('DebugConsole')],
		['xpcall wrapper', output.includes('patchedLoadModule')],
		['patched init()', output.includes('patchedInit')],
		['init() call at end', output.trim().endsWith('init()')],
		['module definitions', output.includes('newInstance("Reverse Community"')],
	];
	console.log('\n--- Verification ---');
	let ok = true;
	for (const [name, pass] of checks) {
		console.log('   ' + (pass ? '✅' : '❌') + ' ' + name);
		if (!pass) ok = false;
	}
	if (ok) {
		console.log('\n✅ All checks passed! Execute Reverse-Control-DEBUG.lua in your executor.');
	} else {
		console.log('\n❌ Some checks failed — review the output.');
	}
}

build();
