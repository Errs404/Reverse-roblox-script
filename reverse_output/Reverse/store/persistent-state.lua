local a = require(script.Parent.Parent.include.RuntimeLib)
local ey = a.import(script, a.getModule(script, "@rbxts", "services"))
local ia = ey.HttpService
local dV = ey.Players
local em = a.import(script, script.Parent.Parent, "jobs", "helpers", "job-store").getStore
local dg = a.import(script, script.Parent.Parent, "utils", "timeout").setInterval
if makefolder and not isfolder("_orca") then
	makefolder("_orca")
end
local function iF(iG)
	if readfile then
		return isfile(iG) and readfile(iG) or nil
	else
		print("READ   " .. iG)
		return nil
	end
end
local function iH(iG, iI)
	if writefile then
		return writefile(iG, iI)
	else
		print("WRITE  " .. iG .. " => \n" .. iI)
		return nil
	end
end
local iJ
local function iK(hv, iL, iM)
	local iN, iO = a.try(function()
		local iP = iF("_orca/" .. hv .. ".json")
		if iP == nil then
			iH("_orca/" .. hv .. ".json", ia:JSONEncode(iM))
			return a.TRY_RETURN, { iM }
		end
		local d3 = ia:JSONDecode(iP)
		iJ(hv, iL):catch(function()
			warn("Autosave failed")
		end)
		return a.TRY_RETURN, { d3 }
	end, function(dw)
		warn("Failed to load " .. hv .. ".json: " .. tostring(dw))
		return a.TRY_RETURN, { iM }
	end)
	if iN then
		return unpack(iO)
	end
end
iJ = a.async(function(hv, iL)
	local eu = a.await(em())
	local function iQ()
		local F = iL(eu:getState())
		iH("_orca/" .. hv .. ".json", ia:JSONEncode(F))
	end
	dg(function()
		return iQ
	end, 60000)
	dV.PlayerRemoving:Connect(function(eB)
		if eB == dV.LocalPlayer then
			iQ()
		end
	end)
end)
return { persistentState = iK }
