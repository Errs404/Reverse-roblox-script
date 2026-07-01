-- Polyfill critical globals that executors like Xeno block
if not warn then warn = function() end end
if not print then print = function() end end
if not debug then debug = {} end
if not debug.traceback then
	debug.traceback = function(msg, level)
		if msg ~= nil then return tostring(msg) end
		return ""
	end
end
if not debug.info then debug.info = function() end end
if not setfenv then setfenv = function(fn, _) return fn end end
if not getfenv then getfenv = function() return _G end end

-- Wrap entire runtime in pcall to catch nil value errors
local INIT_OK, INIT_ERR = pcall(function()

-- Runtime module

---@class Module
---@field fn function
---@field isLoaded boolean
---@field value any

---@type table<string, Instance>
local instanceFromId = {}

---@type table<Instance, string>
local idFromInstance = {}

---@type table<Instance, Module>
local modules = {}

---Stores currently loading modules.
---@type table<LocalScript | ModuleScript, ModuleScript>
local currentlyLoading = {}

-- Module resolution

---@param module LocalScript | ModuleScript
---@param caller? LocalScript | ModuleScript
---@return function | nil cleanup
local function validateRequire(module, caller)
	currentlyLoading[caller] = module

	local currentModule = module
	local depth = 0

	-- If the module is loaded, requiring it will not cause a circular dependency.
	if not modules[module] then
		while currentModule do
			depth = depth + 1
			currentModule = currentlyLoading[currentModule]

			if currentModule == module then
				local str = currentModule.Name -- Get the string traceback

				for _ = 1, depth do
					currentModule = currentlyLoading[currentModule]
					str = str .. "  ⇒ " .. currentModule.Name
				end

				error("Failed to load '" .. module.Name .. "'; Detected a circular dependency chain: " .. str, 2)
			end
		end
	end

	return function ()
		if currentlyLoading[caller] == module then -- Thread-safe cleanup!
			currentlyLoading[caller] = nil
		end
	end
end

---@param obj LocalScript | ModuleScript
---@param this? LocalScript | ModuleScript
---@return any
local function loadModule(obj, this)
	local cleanup = this and validateRequire(obj, this)
	local module = modules[obj]

	if module.isLoaded then
		if cleanup then
			cleanup()
		end
		return module.value
	else
		local ok, data = pcall(module.fn)
		if ok then
			module.value = data
			module.isLoaded = true
			if cleanup then
				cleanup()
			end
			return data
		else
			module.value = nil
			module.isLoaded = true
			if cleanup then
				cleanup()
			end
			warn(("Module '%s' failed to load: %s"):format(tostring(obj.Name), tostring(data)))
			error(data, 2)
		end
	end
end

---@param target ModuleScript
---@param this? LocalScript | ModuleScript
---@return any
local function requireModuleInternal(target, this)
	if modules[target] and target:IsA("ModuleScript") then
		return loadModule(target, this)
	else
		return require(target)
	end
end

-- Instance creation

---@param id string
---@return table<string, any> environment
local function newEnv(id)
	local global = getfenv(0)
	-- Inject debug directly into every module's environment
	-- This is more reliable than relying on __index for executors that block debug.*
	local env = {
		VERSION = "1.1.1",
		script = instanceFromId[id],
		require = function (module)
			return requireModuleInternal(module, instanceFromId[id])
		end,
		debug = global.debug or {},
	}
	if not env.debug.traceback then
		env.debug.traceback = function(msg, level)
			if msg ~= nil then return tostring(msg) end
			return ""
		end
	end
	return setmetatable(env, {
		__index = global,
		__metatable = "This metatable is locked",
	})
end

---@param name string
---@param className string
---@param path string
---@param parent string | nil
---@param fn function
local function newModule(name, className, path, parent, fn)
	local instance = Instance.new(className)
	instance.Name = name
	instance.Parent = instanceFromId[parent]

	instanceFromId[path] = instance
	idFromInstance[instance] = path

	modules[instance] = {
		fn = fn,
		isLoaded = false,
		value = nil,
	}
end

---@param name string
---@param className string
---@param path string
---@param parent string | nil
local function newInstance(name, className, path, parent)
	local instance = Instance.new(className)
	instance.Name = name
	instance.Parent = instanceFromId[parent]

	instanceFromId[path] = instance
	idFromInstance[instance] = path
end

-- Runtime

local function init()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
	for object in pairs(modules) do
		if object:IsA("LocalScript") and not object.Disabled then
			task.spawn(function()
				local ok, err = pcall(loadModule, object)
				if not ok then
					warn(string.format("[Module %s] FATAL: %s", tostring(object.Name), tostring(err)))
				end
			end)
		end
	end
end