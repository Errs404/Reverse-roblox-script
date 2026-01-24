local a = require(script.Parent.Parent.include.RuntimeLib)
local au = a.import(script, a.getModule(script, "@rbxts", "make"))
local el = a.import(script, a.getModule(script, "@rbxts", "services")).Lighting
local em = a.import(script, script.Parent, "helpers", "job-store").getStore
local cX = a.import(script, script.Parent.Parent, "utils", "timeout").setTimeout
local en = au("DepthOfFieldEffect", { FarIntensity = 0, InFocusRadius = 0.1, NearIntensity = 1 })
local eo = {}
local function ep()
	for eq in pairs(eo) do
		eq.Enabled = false
	end
	en.Parent = el
end
local function er()
	for eq, es in pairs(eo) do
		eq.Enabled = es.enabled
	end
	en.Parent = nil
end
local et = a.async(function()
	local eu = a.await(em())
	for ev, eq in ipairs(el:GetChildren()) do
		if eq:IsA("DepthOfFieldEffect") then
			local dz = { enabled = eq.Enabled }
			eo[eq] = dz
		end
	end
	local ew
	eu.changed:connect(function(ex)
		local b3 = ew
		if b3 ~= nil then
			b3:clear()
		end
		ew = nil
		if not ex.dashboard.isOpen then
			ew = cX(er, 500)
			return nil
		end
		if ex.options.config.acrylicBlur then
			ep()
		else
			er()
		end
	end)
end)
et():catch(function(dw)
	warn("[acrylic-worker] " .. tostring(dw))
end)
