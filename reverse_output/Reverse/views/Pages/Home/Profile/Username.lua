local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local dV = a.import(script, a.getModule(script, "@rbxts", "services")).Players
local bl = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Canvas").default
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local aq = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local function la()
	local aW = ei("home").profile
	return b.createElement(
		bl,
		{ anchor = Vector2.new(0.5, 0), size = ar(278, 49), position = UDim2.new(0.5, 0, 0, 231) },
		{
			b.createElement(
				"TextLabel",
				{
					Font = "GothamBlack",
					Text = dV.LocalPlayer.DisplayName,
					TextSize = 20,
					TextColor3 = aW.foreground,
					TextXAlignment = "Center",
					TextYAlignment = "Top",
					Size = r(1, 1),
					BackgroundTransparency = 1,
				}
			),
			b.createElement(
				"TextLabel",
				{
					Font = "GothamBold",
					Text = dV.LocalPlayer.Name,
					TextSize = 16,
					TextColor3 = aW.foreground,
					TextXAlignment = "Center",
					TextYAlignment = "Bottom",
					TextTransparency = 0.7,
					Size = r(1, 1),
					BackgroundTransparency = 1,
				}
			),
		}
	)
end
local f = i(la)
return { default = f }
