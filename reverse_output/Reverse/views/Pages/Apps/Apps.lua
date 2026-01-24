local a = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local l5 = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).pure
local bl = a.import(script, script.Parent.Parent.Parent.Parent, "components", "Canvas").default
local cd = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-scale").useScale
local r = a.import(script, script.Parent.Parent.Parent.Parent, "utils", "udim2").scale
local dV = a.import(script, script.Parent, "Players").default
local function l6()
	local ck = cd()
	return b.createElement(
		bl,
		{ position = r(0, 1), anchor = Vector2.new(0, 1) },
		{ b.createElement("UIScale", { Scale = ck }), b.createElement(dV) }
	)
end
local f = l5(l6)
return { default = f }
