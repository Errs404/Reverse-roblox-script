local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local j = h.useCallback
local aK = h.useState
local function dd()
	local Z = aK(0)
	local de = Z[2]
	return j(function()
		return de(function(F)
			return F + 1
		end)
	end, {})
end
return { useForcedUpdate = dd }
