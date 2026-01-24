local a = require(script.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local cc = h.useBinding
local cd = a.import(script, script.Parent.Parent, "hooks", "use-scale").useScale
local b9 = a.import(script, script.Parent.Parent, "utils", "binding-util").asBinding
local q = a.import(script, script.Parent.Parent, "utils", "number-util").map
local aq = a.import(script, script.Parent.Parent, "utils", "udim2")
local ce = aq.applyUDim2
local ar = aq.px
local bl = a.import(script, script.Parent, "Canvas").default
local bp
do
	local cf = {}
	bp = setmetatable({}, { __index = cf })
	bp.Size70 = "rbxassetid://8992230903"
	cf["rbxassetid://8992230903"] = "Size70"
	bp.Size146 = "rbxassetid://8992584561"
	cf["rbxassetid://8992584561"] = "Size146"
	bp.Size198 = "rbxassetid://8992230677"
	cf["rbxassetid://8992230677"] = "Size198"
end
local cg = { [bp.Size70] = 70 / 2, [bp.Size146] = 146 / 2, [bp.Size198] = 198 / 2 }
local function bo(C)
	local D = C.radius
	local Q = C.size
	local R = C.position
	local bc = C.color
	local ca = C.gradient
	local bd = C.transparency
	if bd == nil then
		bd = 0
	end
	local ch = C.maintainCornerRadius
	local be = C[b.Children]
	local Z = cc(Vector2.new())
	local ci = Z[1]
	local cj = Z[2]
	local ck = cd()
	local cl = cg[D]
	local cm = ch
			and b.joinBindings({ absoluteSize = ci, scaleFactor = ck, size = b9(Q) }):map(function(bk)
				local ci = bk.absoluteSize
				local Q = bk.size
				local ck = bk.scaleFactor
				local cn = ce(ci, Q, ck)
				return ar(math.max(cn.X, cl * 2), math.max(cn.Y, cl * 2))
			end)
		or Q
	local co = ch
			and b.joinBindings({ absoluteSize = ci, scaleFactor = ck, size = b9(Q), transparency = b9(bd) })
				:map(function(bk)
					local ci = bk.absoluteSize
					local Q = bk.size
					local bd = bk.transparency
					local ck = bk.scaleFactor
					local cp = cl * 2
					local cn = ce(ci, UDim2.fromScale(Q.X.Scale, Q.Y.Scale), ck).X
					if cn < cp then
						return 1 - (1 - bd) * q(cn, 0, cp, 0, 1)
					else
						return bd
					end
				end)
		or bd
	local bf = { onChange = { AbsoluteSize = ch and function(ai)
		return cj(ai.AbsoluteSize)
	end or nil } }
	local G = {}
	local H = #G
	local bh = {
		Image = D,
		ImageColor3 = bc,
		ImageTransparency = co,
		ScaleType = "Slice",
		SliceCenter = Rect.new(Vector2.new(cl, cl), Vector2.new(cl, cl)),
		SliceScale = ck:map(function(cq)
			return cq * 0.1 + 0.9
		end),
		Size = cm,
		Position = R,
		BackgroundTransparency = 1,
	}
	local bi = {}
	local bj = #bi
	local I = ca
		and b.createFragment({
			gradient = b.createElement(
				"UIGradient",
				{ Color = ca.color, Transparency = ca.transparency, Rotation = ca.rotation }
			),
		})
	if I then
		if I.elements ~= nil or I.props ~= nil and I.component ~= nil then
			bi[bj + 1] = I
		else
			for J, K in ipairs(I) do
				bi[bj + J] = K
			end
		end
	end
	bj = #bi
	if be then
		for J, K in pairs(be) do
			if type(J) == "number" then
				bi[bj + J] = K
			else
				bi[J] = K
			end
		end
	end
	G[H + 1] = b.createElement("ImageLabel", bh, bi)
	return b.createElement(bl, bf, G)
end
local f = i(bo)
return { GlowRadius = bp, RADIUS_TO_CENTER_OFFSET = cg, default = f }
