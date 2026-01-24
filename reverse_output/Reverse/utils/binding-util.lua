local a = require(script.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local function jR(cC)
	return type(cC) == "table" and cC.getValue ~= nil
end
local function ba(d3, jS)
	return jR(d3) and d3:map(jS) or b.createBinding(jS(d3))
end
local function b9(d3)
	return jR(d3) and d3 or b.createBinding(d3)
end
return { isBinding = jR, mapBinding = ba, asBinding = b9 }
