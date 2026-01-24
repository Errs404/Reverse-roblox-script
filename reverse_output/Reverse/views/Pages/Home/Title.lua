local a = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local bl = a.import(script, script.Parent.Parent.Parent.Parent, "components", "Canvas").default
local c1 = a.import(script, script.Parent.Parent.Parent.Parent, "components", "Card").default
local cr = a.import(script, script.Parent.Parent.Parent.Parent, "components", "ParallaxImage").default
local cw = a.import(script, script.Parent.Parent.Parent.Parent, "constants").VERSION_TAG
local b_ =
	a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "common", "use-delayed-update").useDelayedUpdate
local aO = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local c0 = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-current-page").useIsPageOpen
local e9 = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-parallax-offset").useParallaxOffset
local ei = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local an = a.import(script, script.Parent.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local aq = a.import(script, script.Parent.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local mh
local function lQ()
	local aW = ei("home").title
	local ct = e9()
	return b.createElement(
		c1,
		{ index = 0, page = an.Home, theme = aW, size = ar(326, 184), position = UDim2.new(0, 0, 1, -648 - 48) },
		{
			b.createElement(
				cr,
				{
					image = "rbxassetid://121717194038209",
					imageSize = Vector2.new(652, 368),
					padding = Vector2.new(30, 30),
					offset = ct,
				},
				{ b.createElement("UICorner", { CornerRadius = UDim.new(0, 12) }) }
			),
			b.createElement(
				"ImageLabel",
				{ Image = "rbxassetid://87706741779090", Size = r(1, 1), ImageTransparency = 0.3, BackgroundTransparency = 1 },
				{ b.createElement("UICorner", { CornerRadius = UDim.new(0, 12) }) }
			),
			b.createElement(
				bl,
				{ padding = { top = 24, left = 24 } },
				{
					b.createElement(
						mh,
						{ index = 0, text = "REVERSE", font = Enum.Font.GothamBlack, size = 20, position = ar(0, 0) }
					),
					b.createElement(mh, { index = 1, text = cw, position = ar(0, 40) }),
					b.createElement(mh, { index = 2, text = "ReverseInc.", position = ar(0, 63), transparency = 0.15 }),
					b.createElement(mh, { index = 3, text = "", position = ar(0, 86), transparency = 0.3 }),
					b.createElement(
						mh,
						{ index = 4, text = "By.Squeezy", position = UDim2.new(0, 0, 1, -40), transparency = 0.45 }
					),
				}
			),
		}
	)
end
local f = i(lQ)
local function mi(l2)
	local Z = l2
	local c2 = Z.index
	local lv = Z.text
	local mj = Z.font
	if mj == nil then
		mj = Enum.Font.GothamBold
	end
	local Q = Z.size
	if Q == nil then
		Q = 16
	end
	local R = Z.position
	local bd = Z.transparency
	if bd == nil then
		bd = 0
	end
	local aW = ei("home").title
	local c4 = c0(an.Home)
	local c5 = b_(c4, c2 * 100 + 300, function(hE)
		return not hE
	end)
	local bf = {
		Text = lv,
		Font = mj,
		TextColor3 = aW.foreground,
		TextSize = Q,
		TextTransparency = aO(c5 and bd or 1, { frequency = 2 }),
		TextXAlignment = "Left",
		TextYAlignment = "Top",
		Size = ar(200, 24),
	}
	local b3
	if c5 then
		b3 = R
	else
		local y = ar(24, 0)
		b3 = R - y
	end
	bf.Position = aO(b3, {})
	bf.BackgroundTransparency = 1
	return b.createElement("TextLabel", bf)
end
mh = i(mi)
return { default = f }
