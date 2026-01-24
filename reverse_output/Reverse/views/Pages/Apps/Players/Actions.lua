local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local aT = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "ActionButton").default
local bl = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Canvas").default
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local ar = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2").px
local function l7()
	local aW = ei("apps").players
	return b.createElement(
		bl,
		{ anchor = Vector2.new(0.5, 0), size = ar(278, 49), position = UDim2.new(0.5, 0, 0, 304) },
		{
			b.createElement(
				aT,
				{
					action = "teleport",
					hint = "<font face='GothamBlack'>Teleport to</font> this player, tap again to cancel",
					theme = aW,
					image = "rbxassetid://8992042585",
					position = ar(0, 0),
					canDeactivate = true,
				}
			),
			b.createElement(
				aT,
				{
					action = "hide",
					hint = "<font face='GothamBlack'>Hide</font> this player's character; persists between players",
					theme = aW,
					image = "rbxassetid://8992042653",
					position = ar(72, 0),
					canDeactivate = true,
				}
			),
			b.createElement(
				aT,
				{
					action = "kill",
					hint = "<font face='GothamBlack'>Kill</font> this player with a tool handle",
					theme = aW,
					image = "rbxassetid://8992042471",
					position = ar(145, 0),
				}
			),
			b.createElement(
				aT,
				{
					action = "spectate",
					hint = "<font face='GothamBlack'>Spectate</font> this player",
					theme = aW,
					image = "rbxassetid://8992042721",
					position = ar(217, 0),
					canDeactivate = true,
				}
			),
		}
	)
end
local f = i(l7)
return { default = f }
