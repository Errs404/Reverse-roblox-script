local a = require(script.Parent.include.RuntimeLib)
local au = a.import(script, a.getModule(script, "@rbxts", "make"))
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local am = a.import(script, a.getModule(script, "@rbxts", "roact-rodux-hooked").out).Provider
local dV = a.import(script, a.getModule(script, "@rbxts", "services")).Players
local cv = a.import(script, script.Parent, "constants").IS_DEV
local hw = a.import(script, script.Parent, "jobs").setStore
local im = a.import(script, script.Parent, "store", "actions", "dashboard.action").toggleDashboard
local ao = a.import(script, script.Parent, "store", "store").configureStore
local e = a.import(script, script.Parent, "App").default
local eu = ao()
hw(eu)
local io = a.async(function()
	local ip = au("Folder", {})
	b.mount(b.createElement(am, { store = eu }, { b.createElement(e) }), ip)
	return ip:WaitForChild(1)
end)
local function iq(ir)
	local is = syn and syn.protect_gui or protect_gui
	if is then
		is(ir)
	end
	if cv then
		ir.Parent = dV.LocalPlayer:WaitForChild("PlayerGui")
	elseif gethui then
		ir.Parent = gethui()
	else
		ir.Parent = game:GetService("CoreGui")
	end
end
local et = a.async(function()
	if getgenv and getgenv()._ORCA_IS_LOADED ~= nil then
		error("Reverse is already loaded!")
	end
	local ir = a.await(io())
	iq(ir)
	if time() > 3 then
		task.defer(function()
			return eu:dispatch(im())
		end)
	end
	if getgenv then
		getgenv()._ORCA_IS_LOADED = true
	end
end)
et():catch(function(dw)
	warn("Reverse failed to load: " .. tostring(dw))
end)
