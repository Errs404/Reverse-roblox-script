local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local aT = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "ActionButton").default
local bl = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Canvas").default
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local ar = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2").px
local function l7()
	local aW = ei("home").profile
	return b.createElement(
		bl,
		{ anchor = Vector2.new(0.5, 0), size = ar(278, 49), position = UDim2.new(0.5, 0, 0, 575) },
		{
			b.createElement(
				aT,
				{
					action = "refresh",
					hint = "<font face='GothamBlack'>Refresh</font> your character at this location",
					theme = aW,
					image = "rbxassetid://8992253511",
					position = ar(0, 0),
				}
			),
			b.createElement(
				aT,
				{
					action = "ghost",
					hint = "<font face='GothamBlack'>Spawn a ghost</font> and go to it when disabled",
					theme = aW,
					image = "rbxassetid://8992253792",
					position = ar(72, 0),
					canDeactivate = true,
				}
			),
			b.createElement(
				aT,
				{
					action = "godmode",
					hint = "<font face='GothamBlack'>Set godmode</font>, may break respawn",
					theme = aW,
					image = "rbxassetid://8992253678",
					position = ar(145, 0),
				}
			),
			b.createElement(
				aT,
				{
					action = "freecam",
					hint = "<font face='GothamBlack'>Set freecam</font>, use Q & E to move vertically",
					theme = aW,
					image = "rbxassetid://8992253933",
					position = ar(217, 0),
					canDeactivate = true,
				}
			),
		}
	)
end
local f = i(l7)
return { default = f }
