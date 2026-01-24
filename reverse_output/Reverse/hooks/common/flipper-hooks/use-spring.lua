local a = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local bw = a.import(script, a.getModule(script, "@rbxts", "flipper").src).Spring
local cE = a.import(script, script.Parent, "use-goal").useGoal
local function aO(cI, cL)
	return cE(bw.new(cI, cL))
end
return { useSpring = aO }
