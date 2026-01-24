local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local aK = h.useState
local aN = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "rodux-hooks").useAppDispatch
local aO = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local c0 = a.import(script, script.Parent.Parent.Parent, "hooks", "use-current-page").useIsPageOpen
local ei = a.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local iu = a.import(script, script.Parent.Parent.Parent, "store", "actions", "dashboard.action").setDashboardPage
local kY = a.import(script, script.Parent.Parent.Parent, "store", "models", "dashboard.model")
local iE = kY.PAGE_TO_ICON
local iD = kY.PAGE_TO_INDEX
local aq = a.import(script, script.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local l3 = ar(100, 56)
local function k_(C)
	local c3 = C.page
	local aW = ei("navbar")
	local c5 = c0(c3)
	local aZ = aN()
	local Z = aK(false)
	local l4 = Z[1]
	local b1 = Z[2]
	return b.createElement(
		"TextButton",
		{
			Text = "",
			AutoButtonColor = false,
			Active = not c5,
			Size = l3,
			Position = r(iD[c3] / 4, 0),
			BackgroundTransparency = 1,
			[b.Event.Activated] = function()
				return aZ(iu(c3))
			end,
			[b.Event.MouseEnter] = function()
				return b1(true)
			end,
			[b.Event.MouseLeave] = function()
				return b1(false)
			end,
		},
		{
			b.createElement(
				"ImageLabel",
				{
					Image = iE[c3],
					ImageColor3 = aW.foreground,
					ImageTransparency = aO(c5 and 0 or (l4 and 0.5 or 0.75), {}),
					Size = ar(36, 36),
					Position = r(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
				}
			),
		}
	)
end
local f = i(k_)
return { default = f }
