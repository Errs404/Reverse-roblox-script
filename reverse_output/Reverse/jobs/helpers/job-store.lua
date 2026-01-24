local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local dg = a.import(script, script.Parent.Parent.Parent, "utils", "timeout").setInterval
local eu = {}
local function hw(hx)
	if eu.current then
		error("Store has already been set")
	end
	eu.current = hx
end
local em = a.async(function()
	if eu.current then
		return eu.current
	end
	return a.Promise.new(function(hy, ev, hz)
		local dj
		dj = dg(function()
			if eu.current then
				hy(eu.current)
				dj:clear()
			end
		end, 100)
		hz(function()
			dj:clear()
		end)
	end)
end)
local hA
local eA = a.async(function(hB, da)
	local eu = a.await(em())
	local hC = eu:getState().jobs[hB]
	return eu.changed:connect(function(ex)
		local eM = ex.jobs[hB]
		if not hA(eM, hC) then
			hC = eM
			task.defer(da, eM, ex)
		end
	end)
end)
function hA(hD, dG)
	for ej in pairs(hD) do
		if hD[ej] ~= dG[ej] then
			return false
		end
	end
	return true
end
return { setStore = hw, getStore = em, onJobChange = eA }
