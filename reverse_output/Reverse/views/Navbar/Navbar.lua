local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local B = a.import(script, script.Parent.Parent.Parent, "components", "Acrylic").default
local bb = a.import(script, script.Parent.Parent.Parent, "components", "Border").default
local bl = a.import(script, script.Parent.Parent.Parent, "components", "Canvas").default
local bm = a.import(script, script.Parent.Parent.Parent, "components", "Fill").default
local bn = a.import(script, script.Parent.Parent.Parent, "components", "Glow")
local bo = bn.default
local bp = bn.GlowRadius
local p = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "rodux-hooks").useAppSelector
local aO = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local dU = a.import(script, script.Parent.Parent.Parent, "hooks", "use-current-page").useCurrentPage
local ei = a.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local kY = a.import(script, script.Parent.Parent.Parent, "store", "models", "dashboard.model")
local an = kY.DashboardPage
local iD = kY.PAGE_TO_INDEX
local kZ = a.import(script, script.Parent.Parent.Parent, "utils", "color3")
local jU = kZ.getColorInSequence
local ap = kZ.hex
local aq = a.import(script, script.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local k_ = a.import(script, script.Parent, "NavbarTab").default
local l0 = ar(400, 56)
local l1
local function kK()
	local aW = ei("navbar")
	local c3 = dU()
	local c4 = p(function(F)
		return F.dashboard.isOpen
	end)
	local bN = aO(iD[c3] / 4, { frequency = 3.9, dampingRatio = 0.76 })
	local bf = {
		Size = l0,
		Position = aO(c4 and UDim2.new(0.5, 0, 1, 0) or UDim2.new(0.5, 0, 1, 48 + 56 + 20), {}),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundTransparency = 1,
	}
	local G = {
		b.createElement(
			bo,
			{
				radius = bp.Size146,
				size = UDim2.new(1, 80, 0, 146),
				position = ar(-40, -20),
				color = aW.dropshadow,
				gradient = aW.dropshadowGradient,
				transparency = aW.transparency,
			}
		),
		b.createElement(
			l1,
			{
				transparency = aW.glowTransparency,
				position = bN:map(function(hD)
					return hD + 0.125
				end),
				sequenceColor = bN:map(function(hD)
					return jU(aW.accentGradient.color, hD + 0.125)
				end),
			}
		),
		b.createElement(
			bm,
			{ color = aW.background, gradient = aW.backgroundGradient, radius = 8, transparency = aW.transparency }
		),
		b.createElement(
			bl,
			{ size = ar(100, 56), position = bN:map(function(hD)
				return r(math.round(hD * 800) / 800, 0)
			end), clipsDescendants = true },
			{
				b.createElement(
					"Frame",
					{
						Size = l0,
						Position = bN:map(function(hD)
							return r(-4 * math.round(hD * 800) / 800, 0)
						end),
						BackgroundColor3 = ap("#FFFFFF"),
						BorderSizePixel = 0,
					},
					{
						b.createElement(
							"UIGradient",
							{
								Color = aW.accentGradient.color,
								Transparency = aW.accentGradient.transparency,
								Rotation = aW.accentGradient.rotation,
							}
						),
						b.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
					}
				),
			}
		),
	}
	local H = #G
	local I = aW.outlined
		and b.createFragment({ border = b.createElement(bb, { color = aW.foreground, radius = 8, transparency = 0.8 }) })
	if I then
		if I.elements ~= nil or I.props ~= nil and I.component ~= nil then
			G[H + 1] = I
		else
			for J, K in ipairs(I) do
				G[H + J] = K
			end
		end
	end
	H = #G
	G[H + 1] = b.createElement(k_, { page = an.Home })
	G[H + 2] = b.createElement(k_, { page = an.Apps })
	G[H + 3] = b.createElement(k_, { page = an.Scripts })
	G[H + 4] = b.createElement(k_, { page = an.Options })
	local c9 = aW.acrylic and b.createElement(B)
	if c9 then
		if c9.elements ~= nil or c9.props ~= nil and c9.component ~= nil then
			G[H + 5] = c9
		else
			for J, K in ipairs(c9) do
				G[H + 4 + J] = K
			end
		end
	end
	return b.createElement("Frame", bf, G)
end
local f = i(kK)
function l1(l2)
	return b.createElement(
		"ImageLabel",
		{
			Image = "rbxassetid://8992238178",
			ImageColor3 = l2.sequenceColor,
			ImageTransparency = l2.transparency,
			Size = ar(148, 104),
			Position = l2.position:map(function(hD)
				return UDim2.new(hD, 0, 0, -18)
			end),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
		}
	)
end
return { default = f }
