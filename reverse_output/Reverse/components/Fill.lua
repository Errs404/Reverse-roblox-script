local a = require(script.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local ba = a.import(script, script.Parent.Parent, "utils", "binding-util").mapBinding
local ap = a.import(script, script.Parent.Parent, "utils", "color3").hex
local r = a.import(script, script.Parent.Parent, "utils", "udim2").scale
local function bm(C)
	local bc = C.color
	if bc == nil then
		bc = ap("#ffffff")
	end
	local ca = C.gradient
	local bd = C.transparency
	if bd == nil then
		bd = 0
	end
	local D = C.radius
	if D == nil then
		D = 0
	end
	local be = C[b.Children]
	local bf = { Size = r(1, 1), BackgroundColor3 = bc, BackgroundTransparency = bd }
	local G = {}
	local H = #G
	local I = ca
		and b.createFragment({
			gradient = b.createElement(
				"UIGradient",
				{ Color = ca.color, Transparency = ca.transparency, Rotation = ca.rotation }
			),
		})
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
	local c9 = D ~= nil
		and b.createFragment({
			corner = b.createElement(
				"UICorner",
				{ CornerRadius = ba(D, function(cb)
					return cb == "circular" and UDim.new(1, 0) or UDim.new(0, cb)
				end) }
			),
		})
	if c9 then
		if c9.elements ~= nil or c9.props ~= nil and c9.component ~= nil then
			G[H + 1] = c9
		else
			for J, K in ipairs(c9) do
				G[H + J] = K
			end
		end
	end
	H = #G
	if be then
		for J, K in pairs(be) do
			if type(J) == "number" then
				G[H + J] = K
			else
				G[J] = K
			end
		end
	end
	return b.createElement("Frame", bf, G)
end
local f = i(bm)
return { default = f }
