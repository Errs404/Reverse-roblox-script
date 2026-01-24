local a = require(script.Parent.Parent.include.RuntimeLib)
local g = {}
g.default = a.import(script, script, "Clock").default
return g
