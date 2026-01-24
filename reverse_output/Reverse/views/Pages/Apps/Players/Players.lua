local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local c1 = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Card").default
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local an =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local ar = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2").px
local l7 = a.import(script, script.Parent, "Actions").default
local l8 = a.import(script, script.Parent, "Avatar").default
local l9 = a.import(script, script.Parent, "Selection").default
local la = a.import(script, script.Parent, "Username").default
local function dV()
	local aW = ei("apps").players
	return b.createElement(
		c1,
		{ index = 1, page = an.Apps, theme = aW, size = ar(326, 648), position = UDim2.new(0, 0, 1, 0) },
		{ b.createElement(l8), b.createElement(la), b.createElement(l7), b.createElement(l9) }
	)
end
local f = i(dV)
return { default = f }
