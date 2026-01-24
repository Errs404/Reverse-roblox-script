local kb = os.clock()
local kc = "clock"
local kd = {}
local function ke(hv)
	local b5 = kd[hv]
	if b5 == nil then
		b5 = 0
	end
	kd[hv] = b5 + 1
	kc = hv
	kb = os.clock()
end
local function kf()
	local kg = os.clock() - kb
	local b5 = kd[kc]
	if b5 == nil then
		b5 = 0
	end
	local hX = b5
	print("\n[" .. kc .. " " .. tostring(hX) .. "]\n" .. tostring(kg * 1000) .. " ms\n\n")
end
return { startTimer = ke, endTimer = kf }
