local a = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local k = h.useEffect
local bb = a.import(script, script.Parent.Parent.Parent.Parent, "components", "Border").default
local bl = a.import(script, script.Parent.Parent.Parent.Parent, "components", "Canvas").default
local bm = a.import(script, script.Parent.Parent.Parent.Parent, "components", "Fill").default
local cr = a.import(script, script.Parent.Parent.Parent.Parent, "components", "ParallaxImage").default
local b_ =
	a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "common", "use-delayed-update").useDelayedUpdate
local dc = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "common", "use-did-mount").useIsMount
local dd = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "common", "use-forced-update").useForcedUpdate
local dA = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "common", "use-set-state").default
local aO = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local c0 = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-current-page").useIsPageOpen
local e9 = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-parallax-offset").useParallaxOffset
local an = a.import(script, script.Parent.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local ap = a.import(script, script.Parent.Parent.Parent.Parent, "utils", "color3").hex
local r = a.import(script, script.Parent.Parent.Parent.Parent, "utils", "udim2").scale
local mQ = { dampingRatio = 3, frequency = 2 }
local function mR(C)
	local c2 = C.index
	local mS = C.backgroundImage
	local mT = C.backgroundImageSize
	local ly = C.dropshadow
	local mU = C.dropshadowSize
	local mV = C.dropshadowPosition
	local mW = C.anchorPoint
	local Q = C.size
	local R = C.position
	local bs = C.onActivate
	local be = C[b.Children]
	local mX = dd()
	local mY = c0(an.Scripts)
	local b3
	if dc() then
		b3 = false
	else
		b3 = mY
	end
	local c4 = b3
	local mZ = b_(c4, c2 * 30)
	k(function()
		return mX()
	end, {})
	local ct = e9()
	local Z = dA({ isHovered = false, isPressed = false })
	local dv = Z[1]
	local l4 = dv.isHovered
	local m_ = dv.isPressed
	local n0 = Z[2]
	local bf = { anchor = mW, size = Q }
	local b4
	if mZ then
		b4 = R
	else
		local c6 = UDim2.new(0, 0, 1, 48 * 3 + 56)
		b4 = R + c6
	end
	bf.position = aO(b4, { frequency = 2.2, dampingRatio = 0.75 })
	local G = {}
	local H = #G
	local bh = {
		anchor = Vector2.new(0.5, 0.5),
		size = aO(l4 and not m_ and UDim2.new(1, 48, 1, 48) or r(1, 1), { frequency = 2 }),
		position = r(0.5, 0.5),
	}
	local bi = {
		b.createElement(
			"ImageLabel",
			{
				Image = ly,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = r(mU.X, mU.Y),
				Position = r(mV.X, mV.Y),
				BackgroundTransparency = 1,
			}
		),
		b.createElement(
			cr,
			{ image = mS, imageSize = mT, padding = Vector2.new(50, 50), offset = ct },
			{ b.createElement("UICorner", { CornerRadius = UDim.new(0, 16) }) }
		),
	}
	local bj = #bi
	local lH = { clipsDescendants = true }
	local lI = {}
	local lJ = #lI
	if be then
		for J, K in pairs(be) do
			if type(J) == "number" then
				lI[lJ + J] = K
			else
				lI[J] = K
			end
		end
	end
	bi[bj + 1] = b.createElement(bl, lH, lI)
	bi[bj + 2] = b.createElement(
		bm,
		{ radius = 16, color = ap("#ffffff"), transparency = aO(l4 and 0 or 1, mQ) },
		{
			b.createElement(
				"UIGradient",
				{
					Transparency = NumberSequence.new(0.75, 1),
					Offset = aO(l4 and Vector2.new(0, 0) or Vector2.new(-1, -1), mQ),
					Rotation = 45,
				}
			),
		}
	)
	bi[bj + 3] = b.createElement(
		bb,
		{ radius = 18, size = 3, color = ap("#ffffff"), transparency = aO(l4 and 0 or 1, mQ) },
		{
			b.createElement(
				"UIGradient",
				{
					Transparency = NumberSequence.new(0.7, 0.9),
					Offset = aO(l4 and Vector2.new(0, 0) or Vector2.new(-1, -1), mQ),
					Rotation = 45,
				}
			),
		}
	)
	bi[bj + 4] = b.createElement(bb, { color = ap("#ffffff"), radius = 16, transparency = aO(l4 and 1 or 0.8, {}) })
	G[H + 1] = b.createElement(bl, bh, bi)
	G[H + 2] = b.createElement("TextButton", {
		[b.Event.Activated] = function()
			return bs()
		end,
		[b.Event.MouseEnter] = function()
			return n0({ isHovered = true })
		end,
		[b.Event.MouseLeave] = function()
			return n0({ isHovered = false, isPressed = false })
		end,
		[b.Event.MouseButton1Down] = function()
			return n0({ isPressed = true })
		end,
		[b.Event.MouseButton1Up] = function()
			return n0({ isPressed = false })
		end,
		Size = r(1, 1),
		Text = "",
		Transparency = 1,
	})
	return b.createElement(bl, bf, G)
end
local f = i(mR)
return { default = f }
