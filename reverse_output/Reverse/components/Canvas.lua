local a = require(script.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local ba = a.import(script, script.Parent.Parent, "utils", "binding-util").mapBinding
local r = a.import(script, script.Parent.Parent, "utils", "udim2").scale
local function bl(C)
	local Q = C.size
	if Q == nil then
		Q = r(1, 1)
	end
	local R = C.position
	if R == nil then
		R = r(0, 0)
	end
	local bW = C.anchor
	local bX = C.padding
	local bY = C.clipsDescendants
	local bZ = C.zIndex
	local bP = C.onChange
	if bP == nil then
		bP = {}
	end
	local be = C[b.Children]
	local bf =
		{ Size = Q, Position = R, AnchorPoint = bW, ClipsDescendants = bY, BackgroundTransparency = 1, ZIndex = bZ }
	for J, K in pairs(bP) do
		bf[b.Change[J]] = K
	end
	local G = {}
	local H = #G
	local I = bX ~= nil
		and b.createFragment({
			padding = b.createElement(
				"UIPadding",
				{
					PaddingTop = ba(bX.top, function(ar)
						return UDim.new(0, ar)
					end),
					PaddingRight = ba(bX.right, function(ar)
						return UDim.new(0, ar)
					end),
					PaddingBottom = ba(bX.bottom, function(ar)
						return UDim.new(0, ar)
					end),
					PaddingLeft = ba(bX.left, function(ar)
						return UDim.new(0, ar)
					end),
				}
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
local f = i(bl)
return { default = f }
