local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local k = h.useEffect
local m = h.useMutable
local aK = h.useState
local cV = a.import(script, script.Parent.Parent.Parent, "utils", "timeout")
local cW = cV.clearTimeout
local cX = cV.setTimeout
local cY = 0
local function cZ(c_, d0)
	for d1, d2 in pairs(c_) do
		if d0 == nil or d2.resolveTime >= d0 then
			c_[d1] = nil
			cW(d2.timeout)
		end
	end
end
local function b_(d3, d4, d5)
	local Z = aK(d3)
	local d6 = Z[1]
	local d7 = Z[2]
	local c_ = m({})
	k(function()
		local b3 = d5
		if b3 ~= nil then
			b3 = b3(d3)
		end
		if b3 then
			cZ(c_.current)
			d7(d3)
			return nil
		end
		local d8 = cY
		cY = cY + 1
		local d1 = d8
		local d2 = { timeout = cX(function()
			d7(d3)
			c_.current[d1] = nil
		end, d4), resolveTime = os.clock() + d4 }
		cZ(c_.current, d2.resolveTime)
		c_.current[d1] = d2
	end, { d3 })
	k(function()
		return function()
			return cZ(c_.current)
		end
	end, {})
	return d6
end
return { useDelayedUpdate = b_ }
