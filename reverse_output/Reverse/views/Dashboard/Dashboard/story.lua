local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local am = a.import(script, a.getModule(script, "@rbxts", "roact-rodux-hooked").out).Provider
local an = a.import(script, script.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local ao = a.import(script, script.Parent.Parent.Parent, "store", "store").configureStore
local c = a.import(script, script.Parent, "Dashboard").default
return function(as)
	local at = b.mount(
		b.createElement(
			am,
			{ store = ao({ dashboard = { isOpen = true, page = an.Home, hint = nil, apps = {} } }) },
			{ b.createElement(c) }
		),
		as,
		"Dashboard"
	)
	return function()
		return b.unmount(at)
	end
end
