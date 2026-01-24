local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local dV = a.import(script, a.getModule(script, "@rbxts", "services")).Players
local bl = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Canvas").default
local b_ =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "use-delayed-update").useDelayedUpdate
local aO = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local c0 = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-current-page").useIsPageOpen
local dW = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-friends").useFriends
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local an =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local ar = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2").px
local function lT()
	local aW = ei("home").profile
	local c4 = c0(an.Home)
	local Z = dW()
	local dY = Z[1]
	if dY == nil then
		dY = {}
	end
	local dZ = Z[3]
	local lU = #dY
	local y = function(e0)
		return e0.PlaceId ~= nil and e0.PlaceId == game.PlaceId
	end
	local e1 = {}
	local H = 0
	for J, K in ipairs(dY) do
		if y(K, J - 1, dY) == true then
			H = H + 1
			e1[H] = K
		end
	end
	local lV = #e1
	local lW = b_(c4, 400, function(lX)
		return not lX
	end)
	local lY = b_(c4 and dZ ~= "pending", 500, function(lX)
		return not lX
	end)
	local lZ = b_(c4 and dZ ~= "pending", 600, function(lX)
		return not lX
	end)
	return b.createElement(
		bl,
		{ anchor = Vector2.new(0.5, 0), size = ar(278, 48), position = UDim2.new(0.5, 0, 0, 300) },
		{
			b.createElement(
				"Frame",
				{ Size = ar(0, 26), Position = ar(90, 11), BackgroundTransparency = 1 },
				{ b.createElement("UIStroke", { Thickness = 0.5, Color = aW.foreground, Transparency = 0.7 }) }
			),
			b.createElement(
				"Frame",
				{ Size = ar(0, 26), Position = ar(187, 11), BackgroundTransparency = 1 },
				{ b.createElement("UIStroke", { Thickness = 0.5, Color = aW.foreground, Transparency = 0.7 }) }
			),
			b.createElement(
				"TextLabel",
				{
					Font = "GothamBold",
					Text = "Joined\n" .. tostring(
						os.date("%m/%d/%Y", os.time() - dV.LocalPlayer.AccountAge * 24 * 60 * 60)
					),
					TextSize = 13,
					TextColor3 = aW.foreground,
					TextXAlignment = "Center",
					TextYAlignment = "Center",
					TextTransparency = aO(lW and 0.2 or 1, {}),
					Size = ar(85, 48),
					Position = aO(lW and ar(0, 0) or ar(-20, 0), {}),
					BackgroundTransparency = 1,
				}
			),
			b.createElement(
				"TextLabel",
				{
					Font = "GothamBold",
					Text = lV == 1 and "1 friend\njoined" or tostring(lV) .. " friends\njoined",
					TextSize = 13,
					TextColor3 = aW.foreground,
					TextXAlignment = "Center",
					TextYAlignment = "Center",
					TextTransparency = aO(lY and 0.2 or 1, {}),
					Size = ar(85, 48),
					Position = aO(lY and ar(97, 0) or ar(97 - 20, 0), {}),
					BackgroundTransparency = 1,
				}
			),
			b.createElement(
				"TextLabel",
				{
					Font = "GothamBold",
					Text = lU == 1 and "1 friend\nonline" or tostring(lU) .. " friends\nonline",
					TextSize = 13,
					TextColor3 = aW.foreground,
					TextXAlignment = "Center",
					TextYAlignment = "Center",
					TextTransparency = aO(lZ and 0.2 or 1, {}),
					Size = ar(85, 48),
					Position = aO(lZ and ar(193, 0) or ar(193 - 20, 0), {}),
					BackgroundTransparency = 1,
				}
			),
		}
	)
end
local f = i(lT)
return { default = f }
