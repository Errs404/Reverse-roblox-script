local a = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local bl = a.import(script, script.Parent.Parent.Parent.Parent, "components", "Canvas").default
local cd = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-scale").useScale
local ap = a.import(script, script.Parent.Parent.Parent.Parent, "utils", "color3").hex
local aq = a.import(script, script.Parent.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local mJ, mK
local function mL(C)
	local mM = C.header
	local mN = C.body
	local mO = C.footer
	local ck = cd()
	local bf = {
		padding = {
			top = ck:map(function(bg)
				return bg * 48
			end),
			left = ck:map(function(bg)
				return bg * 48
			end),
			bottom = ck:map(function(bg)
				return bg * 48
			end),
			right = ck:map(function(bg)
				return bg * 48
			end),
		},
	}
	local G = {}
	local H = #G
	local I = mN == nil and b.createElement(mJ, { header = mM, scaleFactor = ck })
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
	local c9 = mN ~= nil and b.createElement(mK, { header = mM, scaleFactor = ck })
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
	local mP = mN ~= nil
		and b.createElement(
			"TextLabel",
			{
				Text = mN,
				TextColor3 = ap("#FFFFFF"),
				Font = "GothamBlack",
				TextSize = 36,
				TextXAlignment = "Left",
				TextYAlignment = "Top",
				Size = r(1, 70 / 416),
				Position = ck:map(function(bg)
					return ar(0, 110 * bg)
				end),
				BackgroundTransparency = 1,
			},
			{ b.createElement("UIScale", { Scale = ck }) }
		)
	if mP then
		if mP.elements ~= nil or mP.props ~= nil and mP.component ~= nil then
			G[H + 1] = mP
		else
			for J, K in ipairs(mP) do
				G[H + J] = K
			end
		end
	end
	H = #G
	G[H + 1] = b.createElement(
		"TextLabel",
		{
			Text = mO,
			TextColor3 = ap("#FFFFFF"),
			Font = "GothamBlack",
			TextSize = 18,
			TextXAlignment = "Center",
			TextYAlignment = "Bottom",
			AnchorPoint = Vector2.new(0.5, 1),
			Size = r(1, 20 / 416),
			Position = r(0.5, 1),
			BackgroundTransparency = 1,
		},
		{ b.createElement("UIScale", { Scale = ck }) }
	)
	return b.createElement(bl, bf, G)
end
function mK(l2)
	return b.createElement(
		"TextLabel",
		{
			Text = l2.header,
			TextColor3 = ap("#FFFFFF"),
			Font = "GothamBlack",
			TextSize = 64,
			TextXAlignment = "Left",
			TextYAlignment = "Top",
			Size = r(1, 70 / 416),
			BackgroundTransparency = 1,
		},
		{ b.createElement("UIScale", { Scale = l2.scaleFactor }) }
	)
end
function mJ(l2)
	return b.createElement(
		"TextLabel",
		{
			Text = l2.header,
			TextColor3 = ap("#FFFFFF"),
			Font = "GothamBlack",
			TextSize = 48,
			TextXAlignment = "Center",
			TextYAlignment = "Center",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = r(1, 1),
			Position = r(0.5, 0.5),
			BackgroundTransparency = 1,
		},
		{ b.createElement("UIScale", { Scale = l2.scaleFactor }) }
	)
end
local f = i(mL)
return { default = f }
