local a = require(script.Parent.Parent.include.RuntimeLib)
local bw = a.import(script, a.getModule(script, "@rbxts", "flipper").src).Spring
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local j = h.useCallback
local k = h.useEffect
local aK = h.useState
local bx = a.import(script, a.getModule(script, "@rbxts", "services")).UserInputService
local by = a.import(script, script.Parent.Parent, "hooks", "common", "flipper-hooks")
local bz = by.getBinding
local bA = by.useMotor
local aq = a.import(script, script.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local bb = a.import(script, script.Parent, "Border").default
local bl = a.import(script, script.Parent, "Canvas").default
local bm = a.import(script, script.Parent, "Fill").default
local bn = a.import(script, script.Parent, "Glow")
local bo = bn.default
local bp = bn.GlowRadius
local bB = { frequency = 8 }
local bC
local function bD(C)
	local bE = C.min
	local bF = C.max
	local bG = C.initialValue
	local Q = C.size
	local R = C.position
	local D = C.radius
	local bc = C.color
	local bH = C.accentColor
	local bq = C.borderEnabled
	local br = C.borderColor
	local bd = C.transparency
	local bI = C.indicatorTransparency
	local bJ = C.onValueChanged
	local bu = C.onRelease
	local be = C[b.Children]
	local bK = bA(bG)
	local bL = bz(bK)
	k(function()
		local b3 = bJ
		if b3 ~= nil then
			b3(bG)
		end
	end, {})
	k(function()
		return function()
			return bK:destroy()
		end
	end, {})
	local bf = { size = Q, position = R }
	local G = {
		b.createElement(
			bo,
			{
				radius = bp.Size70,
				color = bH,
				size = bL:map(function(bM)
					return UDim2.new((bM - bE) / (bF - bE), 36, 1, 36)
				end),
				position = ar(-18, 5 - 18),
				transparency = 0,
				maintainCornerRadius = true,
			}
		),
		b.createElement(bm, { color = bc, radius = D, transparency = bd }),
		b.createElement(
			bl,
			{ size = bL:map(function(bM)
				return r((bM - bE) / (bF - bE), 1)
			end), clipsDescendants = true },
			{
				b.createElement(
					"Frame",
					{ Size = Q, BackgroundColor3 = bH, BackgroundTransparency = bI },
					{ b.createElement("UICorner", { CornerRadius = UDim.new(0, D) }) }
				),
			}
		),
	}
	local H = #G
	local I = bq and b.createElement(bb, { color = br, radius = D, transparency = 0.8 })
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
	G[H + 1] = b.createElement(bC, {
		onChange = function(bN)
			bK:setGoal(bw.new(bN * (bF - bE) + bE, bB))
			local b3 = bJ
			if b3 ~= nil then
				b3(bN * (bF - bE) + bE)
			end
		end,
		onRelease = function(bN)
			local b3 = bu
			if b3 ~= nil then
				b3 = b3(bN * (bF - bE) + bE)
			end
			return b3
		end,
	})
	if be then
		for J, K in pairs(be) do
			if type(J) == "number" then
				G[H + 1 + J] = K
			else
				G[J] = K
			end
		end
	end
	return b.createElement(bl, bf, G)
end
local f = i(bD)
local function bO(C)
	local bP = C.onChange
	local bu = C.onRelease
	local Z = aK()
	local bQ = Z[1]
	local bR = Z[2]
	local bS = j(function(bN)
		bN = math.clamp(bN, 0, 1)
		bP(bN)
	end, {})
	local bT = j(function(bU, ai)
		return (bU - ai.AbsolutePosition.X) / ai.AbsoluteSize.X
	end, {})
	k(function()
		return function()
			local b3 = bQ
			if b3 ~= nil then
				b3:Disconnect()
			end
		end
	end, {})
	return b.createElement("Frame", {
		Active = true,
		Size = r(1, 1),
		BackgroundTransparency = 1,
		[b.Event.InputBegan] = function(ai, bV)
			if bV.UserInputType == Enum.UserInputType.MouseButton1 then
				local b3 = bQ
				if b3 ~= nil then
					b3:Disconnect()
				end
				local at = bx.InputChanged:Connect(function(bV)
					if bV.UserInputType == Enum.UserInputType.MouseMovement then
						bS(bT(bV.Position.X, ai))
					end
				end)
				bR(at)
				bS(bT(bV.Position.X, ai))
			end
		end,
		[b.Event.InputEnded] = function(ai, bV)
			if bV.UserInputType == Enum.UserInputType.MouseButton1 then
				local b3 = bQ
				if b3 ~= nil then
					b3:Disconnect()
				end
				bR(nil)
				bu(bT(bV.Position.X, ai))
			end
		end,
	})
end
bC = i(bO)
return { default = f }
