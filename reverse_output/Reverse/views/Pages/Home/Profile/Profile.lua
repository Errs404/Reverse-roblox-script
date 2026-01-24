local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local bl = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Canvas").default
local c1 = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Card").default
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local an =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local ar = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2").px
local l7 = a.import(script, script.Parent, "Actions").default
local l8 = a.import(script, script.Parent, "Avatar").default
local lT = a.import(script, script.Parent, "Info").default
local l_ = a.import(script, script.Parent, "Sliders").default
local la = a.import(script, script.Parent, "Username").default
local function lO()
	local aW = ei("home").profile
	return b.createElement(
		c1,
		{ index = 1, page = an.Home, theme = aW, size = ar(326, 648), position = UDim2.new(0, 0, 1, 0) },
		{
			b.createElement(
				bl,
				{ padding = { left = 24, right = 24 } },
				{ b.createElement(l8), b.createElement(la), b.createElement(lT), b.createElement(l_), b.createElement(
					l7
				) }
			),
		}
	)
end
local f = i(lO)
return { default = f }
