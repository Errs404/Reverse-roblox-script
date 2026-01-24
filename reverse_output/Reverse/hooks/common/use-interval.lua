local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local k = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).useEffect
local cV = a.import(script, script.Parent.Parent.Parent, "utils", "timeout")
local df = cV.clearInterval
local dg = cV.setInterval
local function dh(da, d4, di)
	if di == nil then
		di = {}
	end
	local aA = function()
		if d4 ~= nil then
			local dj = dg(da, d4)
			return function()
				return df(dj)
			end
		end
	end
	local dk = { da, d4 }
	local H = #dk
	table.move(di, 1, #di, H + 1, dk)
	k(aA, dk)
	return dg
end
return { useInterval = dh }
