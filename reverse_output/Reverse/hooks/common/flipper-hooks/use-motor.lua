local a = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local cM = a.import(script, a.getModule(script, "@rbxts", "flipper").src)
local cN = cM.GroupMotor
local cO = cM.SingleMotor
local m = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out.hooks).useMutable
local function cP(bG)
	if type(bG) == "number" then
		return cO.new(bG)
	elseif type(bG) == "table" then
		return cN.new(bG)
	else
		error("Invalid type for initialValue. Expected 'number' or 'table', got '" .. tostring(bG) .. "'")
	end
end
local function bA(bG)
	return m(cP(bG)).current
end
return { useMotor = bA }
