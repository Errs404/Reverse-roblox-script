local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local g = {}
g.getBinding = a.import(script, script, "get-binding").getBinding
g.useGoal = a.import(script, script, "use-goal").useGoal
g.useInstant = a.import(script, script, "use-instant").useInstant
g.useLinear = a.import(script, script, "use-linear").useLinear
g.useMotor = a.import(script, script, "use-motor").useMotor
g.useSpring = a.import(script, script, "use-spring").useSpring
return g
