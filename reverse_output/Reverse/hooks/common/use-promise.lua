local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local k = h.useEffect
local dn = h.useReducer
local function dp(dq)
	if type(dq) == "function" then
		return dq()
	end
	return dq
end
local dr = { pending = "pending", rejected = "rejected", resolved = "resolved" }
local ds = { err = nil, result = nil, state = dr.pending }
local function dt(F, aU)
	local aA = aU.type
	repeat
		if aA == dr.pending then
			return ds
		end
		if aA == dr.resolved then
			return { err = nil, result = aU.payload, state = dr.resolved }
		end
		if aA == dr.rejected then
			return { err = aU.payload, result = nil, state = dr.rejected }
		end
		return F
	until true
end
local function du(dq, di)
	if di == nil then
		di = {}
	end
	local Z = dn(dt, ds)
	local dv = Z[1]
	local dw = dv.err
	local dx = dv.result
	local F = dv.state
	local aZ = Z[2]
	k(function()
		dq = dp(dq)
		if not dq then
			return nil
		end
		local dy = false
		aZ({ type = dr.pending })
		local y = function(dx)
			return not dy and aZ({ payload = dx, type = dr.resolved })
		end
		local dz = function(dw)
			return not dy and aZ({ payload = dw, type = dr.rejected })
		end
		dq:andThen(y, dz)
		return function()
			dy = true
		end
	end, di)
	return { dx, dw, F }
end
return { usePromise = du }
