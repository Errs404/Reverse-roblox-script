local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local k = h.useEffect
local l = h.useMemo
local aK = h.useState
local ey = a.import(script, a.getModule(script, "@rbxts", "services"))
local dV = ey.Players
local kB = ey.TextService
local bb = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Border").default
local bl = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Canvas").default
local bm = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Fill").default
local bn = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Glow")
local bo = bn.default
local bp = bn.GlowRadius
local cv = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "constants").IS_DEV
local cK = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "flipper-hooks").useLinear
local aM = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "rodux-hooks")
local aN = aM.useAppDispatch
local p = aM.useAppSelector
local b_ =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "use-delayed-update").useDelayedUpdate
local aO = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local c0 = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-current-page").useIsPageOpen
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local aP = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "actions", "dashboard.action")
local iv = aP.playerDeselected
local hu = aP.playerSelected
local an =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local jN = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "array-util").arrayToMap
local ku = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "number-util").lerp
local aq = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local lb = 20
local lc = 60
local ld = 326 - 24 * 2
local le = 60
local lf = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.05, 0),
	NumberSequenceKeypoint.new(0.9, 0),
	NumberSequenceKeypoint.new(0.95, 1),
	NumberSequenceKeypoint.new(1, 1),
})
local function lg()
	local Z = aK(dV:GetPlayers())
	local lh = Z[1]
	local li = Z[2]
	k(function()
		local lj = dV.PlayerAdded:Connect(function()
			li(dV:GetPlayers())
		end)
		local lk = dV.PlayerRemoving:Connect(function()
			li(dV:GetPlayers())
		end)
		return function()
			lj:Disconnect()
			lk:Disconnect()
		end
	end, {})
	return lh
end
local ll
local function l9()
	local aZ = aN()
	local lh = lg()
	local hu = p(function(F)
		return F.dashboard.apps.playerSelected
	end)
	-- Search state
	local Z = aK("")
	local bP = Z[1]
	local bQ = Z[2]

	local lm = l(function()
		local y = function(kS)
			return kS.Name == hu
		end
		local b3 = nil
		for e5, K in ipairs(lh) do
			if y(K, e5 - 1, lh) == true then
				b3 = K
				break
			end
		end
		local ln = b3
		local c7 = function(kS)
			return kS.Name ~= hu and (kS ~= dV.LocalPlayer or cv)
		end
		local e1 = {}
		local H = 0
		for J, K in ipairs(lh) do
			if c7(K, J - 1, lh) == true then
				H = H + 1
				e1[H] = K
			end
		end
		-- Apply search filter
		local bS = bP:lower()
		if #bS > 0 then
			local e2 = {}
			local I = 0
			for J, K in ipairs(e1) do
				if K.Name:lower():find(bS, 1, true) or K.DisplayName:lower():find(bS, 1, true) then
					I = I + 1
					e2[I] = K
				end
			end
			e1 = e2
		end
		local lo = function(hD, dG)
			return string.lower(hD.Name) < string.lower(dG.Name)
		end
		table.sort(e1, lo)
		local lp = e1
		local b4
		if ln then
			if #bS == 0 or ln.Name:lower():find(bS, 1, true) or ln.DisplayName:lower():find(bS, 1, true) then
				local dk = { ln }
				local bj = #dk
				table.move(lp, 1, #lp, bj + 1, dk)
				b4 = dk
			else
				b4 = lp
			end
		else
			b4 = lp
		end
		return b4
	end, { lh, hu, bP })
	k(function()
		local b5 = hu ~= nil
		if b5 then
			local y = function(eB)
				return eB.Name == hu
			end
			local b3 = nil
			for e5, K in ipairs(lm) do
				if y(K, e5 - 1, lm) == true then
					b3 = K
					break
				end
			end
			b5 = not b3
		end
		if b5 then
			aZ(iv())
		end
	end, { lh, hu })
	local bf =
		{ size = ar(326, 280), position = ar(0, 368), padding = { left = 24, right = 24, top = 8 }, clipsDescendants = true }
	local G = {}
	local H = #G
	-- Search bar
	local aW = ei("apps").players
	local bU = ar(278, 32)
	local bV = aW.foreground or Color3.fromRGB(200, 200, 200)
	G[H + 1] = b.createElement("TextBox", {
		PlaceholderText = "Search players...",
		Text = bP,
		Font = "GothamBold",
		TextSize = 14,
		TextColor3 = bV,
		PlaceholderColor3 = Color3.fromRGB(140, 140, 140),
		BackgroundTransparency = 1,
		Size = bU,
		Position = ar(0, 0),
		ClearTextOnFocus = false,
		[b.Change.Text] = function(ai)
			bQ(ai.Text)
		end,
	})
	H = #G
	G[H + 1] = b.createElement("Frame", {
		Size = ar(278, 1),
		Position = ar(0, 36),
		BackgroundColor3 = bV,
		BackgroundTransparency = 0.7,
		BorderSizePixel = 0,
	})
	H = #G
	local bh = {
		Size = ar(278, 232),
		Position = ar(0, 40),
		CanvasSize = ar(0, #lm * (lc + lb) + lb),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarImageTransparency = 1,
		ScrollBarThickness = 0,
		ClipsDescendants = false,
	}
	local bi = {}
	local bj = #bi
	for J, K in
		pairs(jN(lm, function(eB, c2)
			return { eB.Name, b.createElement(
				ll,
				{ name = eB.Name, displayName = eB.DisplayName, userId = eB.UserId, index = c2 }
			) }
		end))
	do
		bi[J] = K
	end
	G[H + 1] = b.createElement("ScrollingFrame", bh, bi)
	return b.createElement(bl, bf, G)
end
local f = i(l9)
local function lq(C)
	local hv = C.name
	local lr = C.userId
	local ls = C.displayName
	local c2 = C.index
	local aZ = aN()
	local aW = ei("apps").players.playerButton
	local c4 = c0(an.Apps)
	local lt = b_(c4, c4 and 170 + c2 * 40 or 150)
	local lu = p(function(F)
		return F.dashboard.apps.playerSelected == hv
	end)
	local Z = aK(false)
	local b0 = Z[1]
	local b1 = Z[2]
	local lv = "  " .. ls .. " (@" .. hv .. ")"
	local lw = l(function()
		return kB:GetTextSize(lv, 14, Enum.Font.GothamBold, Vector2.new(1000, lc))
	end, { lv })
	local lx = cK(b0 and ld - le - 20 - lw.X or 0, { velocity = b0 and 40 or 150 }):map(function(bU)
		return UDim.new(0, math.min(bU, 0))
	end)
	local b3
	if lu then
		b3 = aW.accent
	else
		local b4
		if b0 then
			local b5 = aW.backgroundHovered
			if b5 == nil then
				b5 = aW.background:Lerp(aW.accent, 0.1)
			end
			b4 = b5
		else
			b4 = aW.background
		end
		b3 = b4
	end
	local b6 = aO(b3, {})
	local b4
	if lu then
		b4 = aW.accent
	else
		local ft
		if b0 then
			local b5 = aW.backgroundHovered
			if b5 == nil then
				b5 = aW.dropshadow:Lerp(aW.accent, 0.5)
			end
			ft = b5
		else
			ft = aW.dropshadow
		end
		b4 = ft
	end
	local ly = aO(b4, {})
	local b7 = aO(lu and aW.foregroundAccent and aW.foregroundAccent or aW.foreground, {})
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
					lu and aW.glowTransparency
						or (b0 and ku(aW.dropshadowTransparency, aW.glowTransparency, 0.5) or aW.dropshadowTransparency),
					{}
				),
			}
		),
		b.createElement(bm, { color = b6, transparency = aO(aW.backgroundTransparency, {}), radius = 8 }),
		b.createElement(
			"TextLabel",
			{
				Text = lv,
				Font = "GothamBold",
				TextSize = 14,
				TextColor3 = b7,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTransparency = aO(
					lu and 0 or (b0 and aW.foregroundTransparency / 2 or aW.foregroundTransparency),
					{}
				),
				BackgroundTransparency = 1,
				Position = ar(le, 1),
				Size = UDim2.new(1, -le, 1, -1),
				ClipsDescendants = true,
			},
			{ b.createElement("UIPadding", { PaddingLeft = lx }), b.createElement("UIGradient", { Transparency = lf }) }
		),
		b.createElement(
			"ImageLabel",
			{
				Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
					.. tostring(lr)
					.. "&width=60&height=60&format=png",
				Size = UDim2.new(0, lc, 0, lc),
				BackgroundTransparency = 1,
			},
			{ b.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }) }
		),
	}
	local H = #G
	local I = aW.outlined and b.createElement(bb, { color = b7, transparency = 0.8, radius = 8 })
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
			local eB = dV:FindFirstChild(hv)
			local b5 = not lu
			if b5 then
				local ft = eB
				if ft ~= nil then
					ft = ft:IsA("Player")
				end
				b5 = ft
			end
			if b5 then
				aZ(hu(eB))
			else
				aZ(iv())
			end
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
ll = i(lq)
return { default = f }
