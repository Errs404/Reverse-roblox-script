local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local dV = a.import(script, a.getModule(script, "@rbxts", "services")).Players
local ht = a.import(script, script.Parent.Parent, "helpers", "get-selected-player").getSelectedPlayer
local f6 = a.import(script, script.Parent.Parent, "helpers", "job-store")
local em = f6.getStore
local eA = f6.onJobChange
local aS = a.import(script, script.Parent.Parent.Parent, "store", "actions", "jobs.action").setJobActive
local hE = {}
local function hF(eB)
	if hE[eB] ~= nil then
		return nil
	end
	local eT = eB.Character
	local hG
	hG =
		{ character = eT, parent = eT.Parent, handle = eB.CharacterAdded:Connect(function(fN)
			fN.Parent = nil
			hG.character = eT
		end) }
	hE[eB] = hG
	eT.Parent = nil
end
local function hH(eB, hI)
	if not (hE[eB] ~= nil) then
		return nil
	end
	local hG = hE[eB]
	if hI then
		hG.character.Parent = hG.parent
	end
	hG.handle:Disconnect()
	hE[eB] = nil
end
local et = a.async(function()
	local eu = a.await(em())
	local hu = a.await(ht(function(eB)
		local hJ = eu
		local b3
		if eB then
			b3 = hE[eB] ~= nil
		else
			b3 = false
		end
		hJ:dispatch(aS("hide", b3))
	end))
	dV.PlayerRemoving:Connect(function(eB)
		if eB == hu.current then
			eu:dispatch(aS("hide", false))
		else
			hH(eB, false)
		end
	end)
	a.await(eA("hide", function(eM)
		local eB = hu.current
		if not eB then
			eu:dispatch(aS("hide", false))
			return nil
		end
		if eM.active and eB.Character then
			hF(eB)
		elseif not eM.active then
			hH(eB, true)
		end
	end))
end)
et():catch(function(dw)
	warn("[hide-worker] " .. tostring(dw))
end)
