local a = require(script.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local c = a.import(script, script.Parent, "views", "Dashboard").default
local d = 7
local function e()
	return b.createElement(
		"ScreenGui",
		{ IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = "Sibling", DisplayOrder = d },
		{ b.createElement(c) }
	)
end
local f = e
return { default = f }
