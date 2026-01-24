local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local l5 = h.pure
local k = h.useEffect
local aK = h.useState
local bx = a.import(script, a.getModule(script, "@rbxts", "services")).UserInputService
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
local mt = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "actions", "options.action")
local iB = mt.removeShortcut
local iy = mt.setShortcut
local an =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local ku = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "number-util").lerp
local aq = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local lb = 20
local lc = 60
local ld = 326 - 24 * 2
local le = 16
local function mu(C)
	local bs = C.onActivate
	local mv = C.onSelect
	local mw = C.selectedItem
	local aU = C.action
	local mo = C.description
	local c2 = C.index
	local aZ = aN()
	local mp = ei("options").shortcuts.shortcutButton
	local c4 = c0(an.Options)
	local lt = b_(c4, c4 and 250 + c2 * 40 or 230)
	local iz = p(function(F)
		return F.options.shortcuts[aU]
	end)
	local aA = Enum.KeyCode:GetEnumItems()
	local y = function(mx)
		return mx.Value == iz
	end
	local b3 = nil
	for e5, K in ipairs(aA) do
		if y(K, e5 - 1, aA) == true then
			b3 = K
			break
		end
	end
	local my = b3
	local ln = mw == aU
	local Z = aK(false)
	local b0 = Z[1]
	local b1 = Z[2]
	k(function()
		if mw ~= nil then
			return nil
		end
		local at = bx.InputBegan:Connect(function(bV, eN)
			if not eN and bV.KeyCode.Value == iz then
				bs()
			end
		end)
		return function()
			at:Disconnect()
		end
	end, { mw, iz })
	k(function()
		if not ln then
			return nil
		end
		local at = bx.InputBegan:Connect(function(bV, eN)
			if eN then
				return nil
			end
			if bV.UserInputType == Enum.UserInputType.MouseButton1 then
				mv(nil)
				return nil
			end
			local aC = bV.KeyCode
			repeat
				if aC == Enum.KeyCode.Unknown then
					break
				end
				if aC == Enum.KeyCode.Escape then
					aZ(iB(aU))
					mv(nil)
					break
				end
				if aC == Enum.KeyCode.Backspace then
					aZ(iB(aU))
					mv(nil)
					break
				end
				if aC == Enum.KeyCode.Return then
					mv(nil)
					break
				end
				aZ(iy(aU, bV.KeyCode.Value))
				mv(nil)
				break
			until true
		end)
		return function()
			at:Disconnect()
		end
	end, { ln })
	local b4
	if ln then
		b4 = mp.accent
	else
		local ft
		if b0 then
			local b5 = mp.backgroundHovered
			if b5 == nil then
				b5 = mp.background:Lerp(mp.accent, 0.1)
			end
			ft = b5
		else
			ft = mp.background
		end
		b4 = ft
	end
	local b6 = aO(b4, {})
	local ft
	if ln then
		ft = mp.accent
	else
		local mz
		if b0 then
			local b5 = mp.backgroundHovered
			if b5 == nil then
				b5 = mp.dropshadow:Lerp(mp.accent, 0.5)
			end
			mz = b5
		else
			mz = mp.dropshadow
		end
		ft = mz
	end
	local ly = aO(ft, {})
	local b7 = aO(ln and mp.foregroundAccent and mp.foregroundAccent or mp.foreground, {})
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
					ln and mp.glowTransparency
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
					ln and 0 or (b0 and mp.foregroundTransparency / 2 or mp.foregroundTransparency),
					{}
				),
				Position = ar(le, 1),
				Size = UDim2.new(1, -le, 1, -1),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
			}
		),
		b.createElement(
			"TextLabel",
			{
				Text = my and my.Name or "Not bound",
				Font = "GothamBold",
				TextSize = 16,
				TextColor3 = b7,
				TextXAlignment = "Center",
				TextYAlignment = "Center",
				TextTransparency = aO(
					ln and 0 or (b0 and mp.foregroundTransparency / 2 or mp.foregroundTransparency),
					{}
				),
				TextTruncate = "AtEnd",
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 1),
				Size = UDim2.new(0, 124, 1, -1),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
			}
		),
		b.createElement(
			"Frame",
			{
				Size = mp.outlined and UDim2.new(0, 1, 1, -2) or UDim2.new(0, 1, 1, -36),
				Position = mp.outlined and UDim2.new(1, -124, 0, 1) or UDim2.new(1, -124, 0, 18),
				BackgroundColor3 = b7,
				BackgroundTransparency = 0.8,
				BorderSizePixel = 0,
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
			return mv(aU)
		end,
		[b.Event.MouseEnter] = function()
			return b1(true)
		end,
		[b.Event.MouseLeave] = function()
			return b1(false)
		end,
		Text = "",
		Size = r(1, 1),
		Transparency = 1,
	})
	return b.createElement(bl, bf, G)
end
local f = l5(mu)
return { PADDING = lb, ENTRY_HEIGHT = lc, ENTRY_WIDTH = ld, ENTRY_TEXT_PADDING = le, default = f }
