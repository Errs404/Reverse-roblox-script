local a = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local l5 = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).pure
local bl = a.import(script, script.Parent.Parent.Parent.Parent, "components", "Canvas").default
local cd = a.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-scale").useScale
local r = a.import(script, script.Parent.Parent.Parent.Parent, "utils", "udim2").scale
local lC = a.import(script, script.Parent, "FriendActivity").default
local lO = a.import(script, script.Parent, "Profile").default
local lP = a.import(script, script.Parent, "Server").default
local lQ = a.import(script, script.Parent, "Title").default
local function lR()
	local ck = cd()
	return b.createElement(
		bl,
		{ position = r(0, 1), anchor = Vector2.new(0, 1) },
		{
			b.createElement("UIScale", { Scale = ck }),
			b.createElement(lQ),
			b.createElement(lP),
			b.createElement(lC),
			b.createElement(lO),
		}
	)
end
local f = l5(lR)
return { default = f }
