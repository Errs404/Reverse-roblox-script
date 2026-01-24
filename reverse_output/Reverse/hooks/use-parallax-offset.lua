local a = require(script.Parent.Parent.include.RuntimeLib)
local bw = a.import(script, a.getModule(script, "@rbxts", "flipper").src).Spring
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local by = a.import(script, script.Parent, "common", "flipper-hooks")
local bz = by.getBinding
local bA = by.useMotor
local dl = a.import(script, script.Parent, "common", "use-mouse-location").useMouseLocation
local dQ = a.import(script, script.Parent, "common", "use-viewport-size").useViewportSize
local function e9()
	local ea = bA({ 0, 0 })
	local eb = bz(ea)
	local ec = dQ()
	local ct = b.joinBindings({ viewportSize = ec, mouseLocation = eb }):map(function(C)
		local ec = C.viewportSize
		local Z = C.mouseLocation
		local bU = Z[1]
		local ed = Z[2]
		return Vector2.new((bU - ec.X / 2) / ec.X, (ed - ec.Y / 2) / ec.Y)
	end)
	dl(function(u)
		ea:setGoal({ bw.new(u.X, { dampingRatio = 5 }), bw.new(u.Y, { dampingRatio = 5 }) })
	end)
	return ct
end
return { useParallaxOffset = e9 }
