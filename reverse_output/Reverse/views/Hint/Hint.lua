local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local k = h.useEffect
local aK = h.useState
local p = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "rodux-hooks").useAppSelector
local b_ = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "use-delayed-update").useDelayedUpdate
local aO = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local cd = a.import(script, script.Parent.Parent.Parent, "hooks", "use-scale").useScale
local ap = a.import(script, script.Parent.Parent.Parent, "utils", "color3").hex
local r = a.import(script, script.Parent.Parent.Parent, "utils", "udim2").scale
local function kJ()
	local ck = cd()
	local aV = p(function(F)
		return F.dashboard.hint
	end)
	local kT = p(function(F)
		return F.dashboard.isOpen
	end)
	local b5 = aV
	if b5 == nil then
		b5 = ""
	end
	local Z = aK(b5)
	local kU = Z[1]
	local kV = Z[2]
	local kW = b_(aV ~= nil and kT, 500, function(kX)
		return not kX
	end)
	k(function()
		if kW and aV ~= nil then
			kV(aV)
		end
	end, { aV, kW })
	return b.createElement(
		"TextLabel",
		{
			RichText = true,
			Text = kU,
			TextXAlignment = "Right",
			TextYAlignment = "Bottom",
			TextColor3 = ap("#FFFFFF"),
			TextTransparency = aO(kW and 0.4 or 1, {}),
			Font = "GothamSemibold",
			TextSize = 18,
			BackgroundTransparency = 1,
			Position = aO(kW and r(1, 1) or UDim2.new(1, 0, 1, 48), {}),
		},
		{ b.createElement("UIScale", { Scale = ck }) }
	)
end
local f = i(kJ)
return { default = f }
