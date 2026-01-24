local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local j = h.useCallback
local k = h.useEffect
local l = h.useMemo
local m = h.useMutable
local n = a.import(script, a.getModule(script, "@rbxts", "services")).Workspace
local o = a.import(script, script.Parent, "acrylic-instance").acrylicInstance
local p = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "rodux-hooks").useAppSelector
local q = a.import(script, script.Parent.Parent.Parent, "utils", "number-util").map
local r = a.import(script, script.Parent.Parent.Parent, "utils", "udim2").scale
local s = CFrame.Angles(0, math.rad(90), 0)
local function t(u, v)
	local w = n.CurrentCamera:ScreenPointToRay(u.X, u.Y)
	local x = w.Origin
	local y = w.Direction * v
	return x + y
end
local function z()
	return q(n.CurrentCamera.ViewportSize.Y, 0, 2560, 8, 56)
end
local A
local function B(C)
	local D = C.radius
	local v = C.distance
	local E = p(function(F)
		return F.options.config.acrylicBlur
	end)
	local G = {}
	local H = #G
	local I = E and b.createElement(A, { radius = D, distance = v })
	if I then
		if I.elements ~= nil or I.props ~= nil and I.component ~= nil then
			G[H + 1] = I
		else
			for J, K in ipairs(I) do
				G[H + J] = K
			end
		end
	end
	return b.createFragment(G)
end
local f = i(B)
local function L(C)
	local D = C.radius
	if D == nil then
		D = 0
	end
	local v = C.distance
	if v == nil then
		v = 0.001
	end
	local M = m({
		topleft2d = Vector2.new(),
		topright2d = Vector2.new(),
		bottomright2d = Vector2.new(),
		topleftradius2d = Vector2.new(),
	})
	local N = l(function()
		local O = o:Clone()
		O.Parent = n
		return O
	end, {})
	k(function()
		return function()
			return N:Destroy()
		end
	end, {})
	local P = j(function(Q, R)
		local y = Q / 2
		local S = R - y
		local T = M.current
		T.topleft2d = Vector2.new(math.ceil(S.X), math.ceil(S.Y))
		local U = T.topleft2d
		local V = Vector2.new(Q.X, 0)
		T.topright2d = U + V
		T.bottomright2d = T.topleft2d + Q
		local W = T.topleft2d
		local X = Vector2.new(D, 0)
		T.topleftradius2d = W + X
	end, { v, D })
	local Y = j(function()
		local Z = M.current
		local _ = Z.topleft2d
		local a0 = Z.topright2d
		local a1 = Z.bottomright2d
		local a2 = Z.topleftradius2d
		local a3 = t(_, v)
		local a4 = t(a0, v)
		local a5 = t(a1, v)
		local a6 = t(a2, v)
		local a7 = (a6 - a3).Magnitude
		local a8 = (a4 - a3).Magnitude
		local a9 = (a4 - a5).Magnitude
		local aa = CFrame.fromMatrix(
			(a3 + a5) / 2,
			n.CurrentCamera.CFrame.XVector,
			n.CurrentCamera.CFrame.YVector,
			n.CurrentCamera.CFrame.ZVector
		)
		if D ~= nil and D > 0 then
			N.Horizontal.CFrame = aa
			N.Horizontal.Mesh.Scale = Vector3.new(a8 - a7 * 2, a9, 0)
			N.Vertical.CFrame = aa
			N.Vertical.Mesh.Scale = Vector3.new(a8, a9 - a7 * 2, 0)
		else
			N.Horizontal.CFrame = aa
			N.Horizontal.Mesh.Scale = Vector3.new(a8, a9, 0)
		end
		if D ~= nil and D > 0 then
			local ab = CFrame.new(-a8 / 2 + a7, a9 / 2 - a7, 0)
			N.TopLeft.CFrame = aa * ab * s
			N.TopLeft.Mesh.Scale = Vector3.new(0, a7 * 2, a7 * 2)
			local ac = CFrame.new(a8 / 2 - a7, a9 / 2 - a7, 0)
			N.TopRight.CFrame = aa * ac * s
			N.TopRight.Mesh.Scale = Vector3.new(0, a7 * 2, a7 * 2)
			local ad = CFrame.new(-a8 / 2 + a7, -a9 / 2 + a7, 0)
			N.BottomLeft.CFrame = aa * ad * s
			N.BottomLeft.Mesh.Scale = Vector3.new(0, a7 * 2, a7 * 2)
			local ae = CFrame.new(a8 / 2 - a7, -a9 / 2 + a7, 0)
			N.BottomRight.CFrame = aa * ae * s
			N.BottomRight.Mesh.Scale = Vector3.new(0, a7 * 2, a7 * 2)
		end
	end, { D, v })
	k(function()
		Y()
		local af = n.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(Y)
		local ag = n.CurrentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(Y)
		local ah = n.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(Y)
		return function()
			af:Disconnect()
			ag:Disconnect()
			ah:Disconnect()
		end
	end, { Y })
	return b.createElement("Frame", {
		[b.Change.AbsoluteSize] = function(ai)
			local aj = z()
			local ak = ai.AbsoluteSize
			local V = Vector2.new(aj, aj)
			local Q = ak - V
			local al = ai.AbsolutePosition
			local y = ai.AbsoluteSize / 2
			local R = al + y
			P(Q, R)
			task.spawn(Y)
		end,
		[b.Change.AbsolutePosition] = function(ai)
			local aj = z()
			local ak = ai.AbsoluteSize
			local V = Vector2.new(aj, aj)
			local Q = ak - V
			local al = ai.AbsolutePosition
			local y = ai.AbsoluteSize / 2
			local R = al + y
			P(Q, R)
			task.spawn(Y)
		end,
		Size = r(1, 1),
		BackgroundTransparency = 1,
	})
end
A = i(L)
return { default = f }
