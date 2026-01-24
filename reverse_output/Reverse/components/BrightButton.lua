local a = require(script.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local bb = a.import(script, script.Parent, "Border").default
local bl = a.import(script, script.Parent, "Canvas").default
local bm = a.import(script, script.Parent, "Fill").default
local bn = a.import(script, script.Parent, "Glow")
local bo = bn.default
local bp = bn.GlowRadius
local ap = a.import(script, script.Parent.Parent, "utils", "color3").hex
local aq = a.import(script, script.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local function aL(C)
	local Q = C.size
	if Q == nil then
		Q = ar(100, 100)
	end
	local R = C.position
	if R == nil then
		R = ar(0, 0)
	end
	local D = C.radius
	if D == nil then
		D = 8
	end
	local bc = C.color
	if bc == nil then
		bc = ap("#FFFFFF")
	end
	local bq = C.borderEnabled
	local br = C.borderColor
	if br == nil then
		br = ap("#FFFFFF")
	end
	local bd = C.transparency
	if bd == nil then
		bd = 0
	end
	local bs = C.onActivate
	local bt = C.onPress
	local bu = C.onRelease
	local bv = C.onHover
	local be = C[b.Children]
	local bf = { size = Q, position = R }
	local G = {
		b.createElement(
			bo,
			{ radius = bp.Size70, color = bc, size = UDim2.new(1, 36, 1, 36), position = ar(-18, 5 - 18), transparency = bd }
		),
		b.createElement(bm, { color = bc, radius = D, transparency = bd }),
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
	G[H + 1] = b.createElement("TextButton", {
		Text = "",
		AutoButtonColor = false,
		Size = r(1, 1),
		BackgroundTransparency = 1,
		[b.Event.Activated] = function()
			local b3 = bs
			if b3 ~= nil then
				b3 = b3()
			end
			return b3
		end,
		[b.Event.MouseButton1Down] = function()
			local b3 = bt
			if b3 ~= nil then
				b3 = b3()
			end
			return b3
		end,
		[b.Event.MouseButton1Up] = function()
			local b3 = bu
			if b3 ~= nil then
				b3 = b3()
			end
			return b3
		end,
		[b.Event.MouseEnter] = function()
			local b3 = bv
			if b3 ~= nil then
				b3 = b3(true)
			end
			return b3
		end,
		[b.Event.MouseLeave] = function()
			local b3 = bv
			if b3 ~= nil then
				b3 = b3(false)
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
local f = i(aL)
return { default = f }
