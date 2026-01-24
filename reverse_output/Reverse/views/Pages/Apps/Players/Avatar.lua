local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local dV = a.import(script, a.getModule(script, "@rbxts", "services")).Players
local bb = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Border").default
local bl = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Canvas").default
local p = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "rodux-hooks").useAppSelector
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local ar = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2").px
local function l8()
	local aW = ei("apps").players
	local hu = p(function(F)
		local b3
		if F.dashboard.apps.playerSelected ~= nil then
			b3 = dV:FindFirstChild(F.dashboard.apps.playerSelected)
		else
			b3 = nil
		end
		return b3
	end)
	return b.createElement(
		bl,
		{ anchor = Vector2.new(0.5, 0), size = ar(186, 186), position = UDim2.new(0.5, 0, 0, 24) },
		{
			b.createElement(
				"ImageLabel",
				{
					Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(
						hu and hu.UserId or dV.LocalPlayer.UserId
					) .. "&width=150&height=150&format=png",
					Size = ar(150, 150),
					Position = ar(18, 18),
					BackgroundColor3 = aW.avatar.background,
					BackgroundTransparency = aW.avatar.transparency,
				},
				{ b.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }) }
			),
			b.createElement(
				bb,
				{ size = 4, radius = "circular" },
				{
					b.createElement(
						"UIGradient",
						{
							Color = aW.avatar.gradient.color,
							Transparency = aW.avatar.gradient.transparency,
							Rotation = aW.avatar.gradient.rotation,
						}
					),
				}
			),
		}
	)
end
local f = i(l8)
return { default = f }
