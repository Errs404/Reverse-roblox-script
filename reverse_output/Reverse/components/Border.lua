local a = require(script.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local b8 = a.import(script, script.Parent.Parent, "utils", "binding-util")
local b9 = b8.asBinding
local ba = b8.mapBinding
local ap = a.import(script, script.Parent.Parent, "utils", "color3").hex
local ar = a.import(script, script.Parent.Parent, "utils", "udim2").px
local function bb(C)
	local Q = C.size
	if Q == nil then
		Q = 1
	end
	local D = C.radius
	if D == nil then
		D = 0
	end
	local bc = C.color
	if bc == nil then
		bc = ap("#ffffff")
	end
	local bd = C.transparency
	if bd == nil then
		bd = 0
	end
	local be = C[b.Children]
	local bf = {
		Size = ba(Q, function(bg)
			return UDim2.new(1, -bg * 2, 1, -bg * 2)
		end),
		Position = ba(Q, function(bg)
			return ar(bg, bg)
		end),
		BackgroundTransparency = 1,
	}
	local G = {}
	local H = #G
	local bh = { Thickness = Q, Color = bc, Transparency = bd }
	local bi = {}
	local bj = #bi
	if be then
		for J, K in pairs(be) do
			if type(J) == "number" then
				bi[bj + J] = K
			else
				bi[J] = K
			end
		end
	end
	G[H + 1] = b.createElement("UIStroke", bh, bi)
	G[H + 2] = b.createElement(
		"UICorner",
		{
			CornerRadius = b.joinBindings({ radius = b9(D), size = b9(Q) }):map(function(bk)
				local D = bk.radius
				local Q = bk.size
				return D == "circular" and UDim.new(1, 0) or UDim.new(0, D - Q * 2)
			end),
		}
	)
	return b.createElement("Frame", bf, G)
end
local f = i(bb)
return { default = f }
