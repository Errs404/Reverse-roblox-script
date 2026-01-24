local fR = math.pi
local fS = math.abs
local fT = math.clamp
local fU = math.exp
local fV = math.rad
local fW = math.sign
local fX = math.sqrt
local fY = math.tan
local fZ = game:GetService("ContextActionService")
local dV = game:GetService("Players")
local ez = game:GetService("RunService")
local f_ = game:GetService("StarterGui")
local bx = game:GetService("UserInputService")
local n = game:GetService("Workspace")
local g0 = dV.LocalPlayer
if not g0 then
	dV:GetPropertyChangedSignal("LocalPlayer"):Wait()
	g0 = dV.LocalPlayer
end
local g1 = n.CurrentCamera
n:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local g2 = n.CurrentCamera
	if g2 then
		g1 = g2
	end
end)
local g3 = Enum.ContextActionPriority.Low.Value
local g4 = Enum.ContextActionPriority.High.Value
local g5 = { Enum.KeyCode.LeftShift, Enum.KeyCode.P }
local g6 = game:GetService("HttpService"):GenerateGUID(false)
local g7 = Vector3.new(1, 1, 1) * 64
local g8 = Vector2.new(0.75, 1) * 8
local g9 = 300
local ga = fV(90)
local gb = 2.0
local gc = 3.0
local gd = 4.0
local bw = {}
do
	bw.__index = bw
	function bw.new(ge, gf)
		local self = setmetatable({}, bw)
		self.f = ge
		self.p = gf
		self.v = gf * 0
		return self
	end
	function bw:Update(gg, cF)
		local gh = self.f * 2 * fR
		local gi = self.p
		local gj = self.v
		local ct = cF - gi
		local gk = fU(-gh * gg)
		local gl = cF + (gj * gg - ct * (gh * gg + 1)) * gk
		local gm = (gh * gg * (ct * gh - gj) + gj) * gk
		self.p = gl
		self.v = gm
		return gl
	end
	function bw:Reset(gf)
		self.p = gf
		self.v = gf * 0
	end
end
local gn = Vector3.new()
local go = Vector2.new()
local gp = 0
local gq = bw.new(gb, Vector3.new())
local gr = bw.new(gc, Vector2.new())
local gs = bw.new(gd, 0)
local gt = {}
do
	local gu
	do
		local gv = 2.0
		local gw = 0.15
		local function gx(bU)
			return (fU(gv * bU) - 1) / (fU(gv) - 1)
		end
		local function gy(bU)
			return gx((bU - gw) / (1 - gw))
		end
		function gu(bU)
			return fW(bU) * fT(gy(fS(bU)), 0, 1)
		end
	end
	local gz = {
		ButtonX = 0,
		ButtonY = 0,
		DPadDown = 0,
		DPadUp = 0,
		ButtonL2 = 0,
		ButtonR2 = 0,
		Thumbstick1 = Vector2.new(),
		Thumbstick2 = Vector2.new(),
	}
	local gA =
		{ W = 0, A = 0, S = 0, D = 0, E = 0, Q = 0, U = 0, H = 0, J = 0, K = 0, I = 0, Y = 0, Up = 0, Down = 0, LeftShift = 0, RightShift = 0 }
	local gB = { Delta = Vector2.new(), MouseWheel = 0 }
	local gC = Vector3.new(1, 1, 1)
	local gD = Vector3.new(1, 1, 1)
	local gE = Vector2.new(1, 1) * fR / 64
	local gF = Vector2.new(1, 1) * fR / 8
	local gG = 1.0
	local gH = 0.25
	local gI = 0.75
	local gJ = 0.25
	local gK = 1
	function gt.Vel(gg)
		gK = fT(gK + gg * (gA.Up - gA.Down) * gI, 0.01, 4)
		local gL = Vector3.new(gu(gz.Thumbstick1.X), gu(gz.ButtonR2) - gu(gz.ButtonL2), gu(-gz.Thumbstick1.Y)) * gC
		local gM = Vector3.new(gA.D - gA.A + gA.K - gA.H, gA.E - gA.Q + gA.I - gA.Y, gA.S - gA.W + gA.J - gA.U) * gD
		local gN = bx:IsKeyDown(Enum.KeyCode.LeftShift) or bx:IsKeyDown(Enum.KeyCode.RightShift)
		return (gL + gM) * gK * (gN and gJ or 1)
	end
	function gt.Pan(gg)
		local gL = Vector2.new(gu(gz.Thumbstick2.Y), gu(-gz.Thumbstick2.X)) * gF
		local gO = gB.Delta * gE / (gg * 60)
		gB.Delta = Vector2.new()
		return gL + gO
	end
	function gt.Fov(gg)
		local gL = (gz.ButtonX - gz.ButtonY) * gH
		local gO = gB.MouseWheel * gG
		gB.MouseWheel = 0
		return gL + gO
	end
	do
		local function gP(aU, F, bV)
			gA[bV.KeyCode.Name] = F == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end
		local function gQ(aU, F, bV)
			gz[bV.KeyCode.Name] = F == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end
		local function gR(aU, F, bV)
			local gS = bV.Delta
			gB.Delta = Vector2.new(-gS.y, -gS.x)
			return Enum.ContextActionResult.Sink
		end
		local function gT(aU, F, bV)
			gz[bV.KeyCode.Name] = bV.Position
			return Enum.ContextActionResult.Sink
		end
		local function gU(aU, F, bV)
			gz[bV.KeyCode.Name] = bV.Position.z
			return Enum.ContextActionResult.Sink
		end
		local function gV(aU, F, bV)
			gB[bV.UserInputType.Name] = -bV.Position.z
			return Enum.ContextActionResult.Sink
		end
		local function gW(ek)
			for gX, bM in pairs(ek) do
				ek[gX] = bM * 0
			end
		end
		function gt.StartCapture()
			fZ:BindActionAtPriority(
				g6 .. "FreecamKeyboard",
				gP,
				false,
				g4,
				Enum.KeyCode.W,
				Enum.KeyCode.A,
				Enum.KeyCode.S,
				Enum.KeyCode.D,
				Enum.KeyCode.E,
				Enum.KeyCode.Q,
				Enum.KeyCode.Up,
				Enum.KeyCode.Down
			)
			fZ:BindActionAtPriority(g6 .. "FreecamMousePan", gR, false, g4, Enum.UserInputType.MouseMovement)
			fZ:BindActionAtPriority(g6 .. "FreecamMouseWheel", gV, false, g4, Enum.UserInputType.MouseWheel)
			fZ:BindActionAtPriority(
				g6 .. "FreecamGamepadButton",
				gQ,
				false,
				g4,
				Enum.KeyCode.ButtonX,
				Enum.KeyCode.ButtonY
			)
			fZ:BindActionAtPriority(
				g6 .. "FreecamGamepadTrigger",
				gU,
				false,
				g4,
				Enum.KeyCode.ButtonR2,
				Enum.KeyCode.ButtonL2
			)
			fZ:BindActionAtPriority(
				g6 .. "FreecamGamepadThumbstick",
				gT,
				false,
				g4,
				Enum.KeyCode.Thumbstick1,
				Enum.KeyCode.Thumbstick2
			)
		end
		function gt.StopCapture()
			gK = 1
			gW(gz)
			gW(gA)
			gW(gB)
			fZ:UnbindAction(g6 .. "FreecamKeyboard")
			fZ:UnbindAction(g6 .. "FreecamMousePan")
			fZ:UnbindAction(g6 .. "FreecamMouseWheel")
			fZ:UnbindAction(g6 .. "FreecamGamepadButton")
			fZ:UnbindAction(g6 .. "FreecamGamepadTrigger")
			fZ:UnbindAction(g6 .. "FreecamGamepadThumbstick")
		end
	end
end
local function gY(gZ)
	local g_ = 0.1
	local h0 = g1.ViewportSize
	local h1 = 2 * fY(gp / 2)
	local h2 = h0.x / h0.y * h1
	local h3 = gZ.rightVector
	local h4 = gZ.upVector
	local h5 = gZ.lookVector
	local h6 = Vector3.new()
	local h7 = 512
	for bU = 0, 1, 0.5 do
		for ed = 0, 1, 0.5 do
			local h8 = (bU - 0.5) * h2
			local h9 = (ed - 0.5) * h1
			local ct = h3 * h8 - h4 * h9 + h5
			local ha = gZ.p + ct * g_
			local ev, hb = n:FindPartOnRay(Ray.new(ha, ct.unit * h7))
			local hc = (hb - ha).magnitude
			if h7 > hc then
				h7 = hc
				h6 = ct.unit
			end
		end
	end
	return h5:Dot(h6) * h7
end
local function hd(gg)
	local he = gq:Update(gg, gt.Vel(gg))
	local hf = gr:Update(gg, gt.Pan(gg))
	local hg = gs:Update(gg, gt.Fov(gg))
	local hh = fX(fY(fV(70 / 2)) / fY(fV(gp / 2)))
	gp = fT(gp + hg * g9 * gg / hh, 1, 120)
	go = go + hf * g8 * gg / hh
	go = Vector2.new(fT(go.x, -ga, ga), go.y % (2 * fR))
	local fy = CFrame.new(gn) * CFrame.fromOrientation(go.x, go.y, 0) * CFrame.new(he * g7 * gg)
	gn = fy.p
	g1.CFrame = fy
	g1.Focus = fy * CFrame.new(0, 0, -gY(fy))
	g1.FieldOfView = gp
end
local hi = {}
do
	local hj
	local hk
	local hl
	local hm
	local fy
	local hn
	local ho = {}
	local hp = { Backpack = true, Chat = true, Health = true, PlayerList = true }
	local hq = { BadgesNotificationsActive = true, PointsNotificationsActive = true }
	function hi.Push()
		hn = g1.FieldOfView
		g1.FieldOfView = 70
		fy = g1.CFrame
		hm = g1.Focus
		hj = bx.MouseBehavior
		bx.MouseBehavior = Enum.MouseBehavior.Default
	end
	function hi.Pop()
		g1.FieldOfView = hn
		hn = nil
		g1.CFrame = fy
		fy = nil
		g1.Focus = hm
		hm = nil
		bx.MouseBehavior = hj
		hj = nil
	end
end
local function hr()
	local fy = g1.CFrame
	go = Vector2.new(fy:toEulerAnglesYXZ())
	gn = fy.p
	gp = g1.FieldOfView
	gq:Reset(Vector3.new())
	gr:Reset(Vector2.new())
	gs:Reset(0)
	hi.Push()
	ez:BindToRenderStep(g6, Enum.RenderPriority.Camera.Value + 1, hd)
	gt.StartCapture()
end
local function hs()
	gt.StopCapture()
	ez:UnbindFromRenderStep(g6)
	hi.Pop()
end
local eD = false
local function fQ()
	if not eD then
		hr()
		eD = true
	end
end
local function fP()
	if eD then
		hs()
		eD = false
	end
end
return { EnableFreecam = fQ, DisableFreecam = fP }
