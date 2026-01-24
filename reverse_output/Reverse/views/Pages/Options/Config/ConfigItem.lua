local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local l5 = h.pure
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
local aO = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local aP = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "actions", "dashboard.action")
local aQ = aP.clearHint
local aR = aP.setHint
local ix = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "actions", "options.action").setConfig
local ku = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "number-util").lerp
local aq = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local lb = 20
local lc = 60
local ld = 326 - 24 * 2
local le = 16
local function ml(C)
	local aU = C.action
	local mo = C.description
	local aV = C.hint
	local c2 = C.index
	local aZ = aN()
	local mp = ei("options").config.configButton
	local a_ = p(function(F)
		return F.options.config[aU]
	end)
	local Z = aK(false)
	local b0 = Z[1]
	local b1 = Z[2]
	local b3
	if a_ then
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
	if a_ then
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
	local b7 = aO(a_ and mp.foregroundAccent and mp.foregroundAccent or mp.foreground, {})
	local bf = { size = ar(ld, lc), position = ar(0, (lb + lc) * c2), zIndex = c2 }
	local G = {
		b.createElement(
			bo,
			{
				radius = bp.Size70,
				color = ly,
				size = UDim2.new(1, 36, 1, 36),
				position = ar(-18, 5 - 18),
				transparency = aO(
					a_ and mp.glowTransparency
						or (b0 and ku(mp.dropshadowTransparency, mp.glowTransparency, 0.5) or mp.dropshadowTransparency),
					{}
				),
			}
		),
		b.createElement(bm, { color = b6, transparency = mp.backgroundTransparency, radius = 8 }),
		b.createElement(
			"TextLabel",
			{
				Text = mo,
				Font = "GothamBold",
				TextSize = 16,
				TextColor3 = b7,
				TextXAlignment = "Left",
				TextYAlignment = "Center",
				TextTransparency = aO(
					a_ and 0 or (b0 and mp.foregroundTransparency / 2 or mp.foregroundTransparency),
					{}
				),
				Position = ar(le, 1),
				Size = UDim2.new(1, -le, 1, -1),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
			}
		),
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
			return aZ(ix(aU, not a_))
		end,
		[b.Event.MouseEnter] = function()
			b1(true)
			aZ(aR(aV))
		end,
		[b.Event.MouseLeave] = function()
			b1(false)
			aZ(aQ())
		end,
		Text = "",
		Size = r(1, 1),
		Transparency = 1,
	})
	return b.createElement(bl, bf, G)
end
local f = l5(ml)
return { PADDING = lb, ENTRY_HEIGHT = lc, ENTRY_WIDTH = ld, ENTRY_TEXT_PADDING = le, default = f }
