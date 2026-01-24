local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local aK = h.useState
local bb = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Border").default
local bl = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Canvas").default
local bm = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Fill").default
local bn = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Glow")
local bo = bn.default
local bp = bn.GlowRadius
local aM = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "rodux-hooks")
local aN = aM.useAppDispatch
local p = aM.useAppSelector
local b_ =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "use-delayed-update").useDelayedUpdate
local aO = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local c0 = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-current-page").useIsPageOpen
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local iC = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "actions", "options.action").setTheme
local an =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local kZ = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "color3")
local jT = kZ.getLuminance
local ap = kZ.hex
local ku = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "number-util").lerp
local aq = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local lb = 20
local lc = 60
local ld = 326 - 24 * 2
local le = 16
local mC
local function mD(C)
	local aW = C.theme
	local c2 = C.index
	local aZ = aN()
	local mp = ei("options").themes.themeButton
	local c4 = c0(an.Options)
	local lt = b_(c4, c4 and 300 + c2 * 40 or 280)
	local lu = p(function(F)
		return F.options.currentTheme == aW.name
	end)
	local Z = aK(false)
	local b0 = Z[1]
	local b1 = Z[2]
	local b3
	if lu then
		b3 = mp.accent
	else
		local b4
		if b0 then
			local b5 = mp.backgroundHovered
			if b5 == nil then
				b5 = mp.background:Lerp(mp.accent, 0.1)
			end
			b4 = b5
		else
			b4 = mp.background
		end
		b3 = b4
	end
	local b6 = aO(b3, {})
	local b4
	if lu then
		b4 = mp.accent
	else
		local ft
		if b0 then
			local b5 = mp.backgroundHovered
			if b5 == nil then
				b5 = mp.dropshadow:Lerp(mp.accent, 0.5)
			end
			ft = b5
		else
			ft = mp.dropshadow
		end
		b4 = ft
	end
	local ly = aO(b4, {})
	local b7 = aO(lu and mp.foregroundAccent and mp.foregroundAccent or mp.foreground, {})
	local bf =
		{ size = ar(ld, lc), position = aO(lt and ar(0, (lb + lc) * c2) or ar(-ld - 24, (lb + lc) * c2), {}), zIndex = c2 }
	local G = {
		b.createElement(
			bo,
			{
				radius = bp.Size70,
				color = ly,
				size = UDim2.new(1, 36, 1, 36),
				position = ar(-18, 5 - 18),
				transparency = aO(
					lu and mp.glowTransparency
						or (b0 and ku(mp.dropshadowTransparency, mp.glowTransparency, 0.5) or mp.dropshadowTransparency),
					{}
				),
			}
		),
		b.createElement(bm, { color = b6, transparency = mp.backgroundTransparency, radius = 8 }),
		b.createElement(
			"TextLabel",
			{
				Text = aW.name,
				Font = "GothamBold",
				TextSize = 16,
				TextColor3 = b7,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTransparency = aO(
					lu and 0 or (b0 and mp.foregroundTransparency / 2 or mp.foregroundTransparency),
					{}
				),
				BackgroundTransparency = 1,
				Position = ar(le, 1),
				Size = UDim2.new(1, -le, 1, -1),
				ClipsDescendants = true,
			}
		),
		b.createElement(mC, { color = b6, previewTheme = aW.preview }),
	}
	local H = #G
	local I = mp.outlined and b.createElement(bb, { color = b7, transparency = 0.8, radius = 8 })
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
	G[H + 1] = b.createElement("TextButton", {
		[b.Event.Activated] = function()
			return not lu and aZ(iC(aW.name))
		end,
		[b.Event.MouseEnter] = function()
			return b1(true)
		end,
		[b.Event.MouseLeave] = function()
			return b1(false)
		end,
		Text = "",
		Transparency = 1,
		Size = r(1, 1),
	})
	return b.createElement(bl, bf, G)
end
local f = i(mD)
function mC(C)
	local bc = C.color
	local mE = C.previewTheme
	return b.createElement(
		"Frame",
		{
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(0, 114, 1, -4),
			Position = UDim2.new(1, -2, 0, 2),
			BackgroundColor3 = bc,
			Transparency = 1,
			BorderSizePixel = 0,
		},
		{
			b.createElement("UICorner", { CornerRadius = UDim.new(0, 6) }),
			b.createElement(
				"Frame",
				{
					AnchorPoint = Vector2.new(0, 0.5),
					Size = ar(25, 25),
					Position = UDim2.new(0, 12, 0.5, 0),
					BackgroundColor3 = ap("#ffffff"),
					BorderSizePixel = 0,
				},
				{
					b.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
					b.createElement(
						"UIGradient",
						{
							Color = mE.foreground.color,
							Transparency = mE.foreground.transparency,
							Rotation = mE.foreground.rotation,
						}
					),
					b.createElement(
						"UIStroke",
						{
							Color = jT(mE.foreground.color) > 0.5 and ap("#000000") or ap("#ffffff"),
							Transparency = 0.5,
							Thickness = 2,
						}
					),
				}
			),
			b.createElement(
				"Frame",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = ar(25, 25),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					BackgroundColor3 = ap("#ffffff"),
					BorderSizePixel = 0,
				},
				{
					b.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
					b.createElement(
						"UIGradient",
						{
							Color = mE.background.color,
							Transparency = mE.background.transparency,
							Rotation = mE.background.rotation,
						}
					),
					b.createElement(
						"UIStroke",
						{
							Color = jT(mE.background.color) > 0.5 and ap("#000000") or ap("#ffffff"),
							Transparency = 0.5,
							Thickness = 2,
						}
					),
				}
			),
			b.createElement(
				"Frame",
				{
					AnchorPoint = Vector2.new(1, 0.5),
					Size = ar(25, 25),
					Position = UDim2.new(1, -12, 0.5, 0),
					BackgroundColor3 = ap("#ffffff"),
					BorderSizePixel = 0,
				},
				{
					b.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
					b.createElement(
						"UIGradient",
						{ Color = mE.accent.color, Transparency = mE.accent.transparency, Rotation = mE.accent.rotation }
					),
					b.createElement(
						"UIStroke",
						{ Color = jT(mE.accent.color) > 0.5 and ap("#000000") or ap("#ffffff"), Transparency = 0.5, Thickness = 2 }
					),
				}
			),
		}
	)
end
return { PADDING = lb, ENTRY_HEIGHT = lc, ENTRY_WIDTH = ld, ENTRY_TEXT_PADDING = le, default = f }
