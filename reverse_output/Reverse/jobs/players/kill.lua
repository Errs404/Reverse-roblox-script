local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local ey = a.import(script, a.getModule(script, "@rbxts", "services"))
local dV = ey.Players
local n = ey.Workspace
local ht = a.import(script, script.Parent.Parent, "helpers", "get-selected-player").getSelectedPlayer
local f6 = a.import(script, script.Parent.Parent, "helpers", "job-store")
local em = f6.getStore
local eA = f6.onJobChange
local aS = a.import(script, script.Parent.Parent.Parent, "store", "actions", "jobs.action").setJobActive
local eB = dV.LocalPlayer
local hK = a.async(function(hL)
	local hM = eB:FindFirstChildWhichIsA("Backpack")
	if not hM then
		error("No inventory found")
	end
	local hN = eB.Character
	local hO = hL.Character
	if not hN or not hO then
		error("Victim or local player has no character")
	end
	local hP = hN:FindFirstChildWhichIsA("Humanoid")
	local hQ = hN:FindFirstChild("HumanoidRootPart")
	local hR = hO:FindFirstChild("HumanoidRootPart")
	if not hP or (not hQ or not hR) then
		error("Victim or local player has no Humanoid or root part")
	end
	local dk = {}
	local H = #dk
	local hS = hN:GetChildren()
	local hT = #hS
	table.move(hS, 1, hT, H + 1, dk)
	H = H + hT
	local hU = hM:GetChildren()
	table.move(hU, 1, #hU, H + 1, dk)
	local y = function(hV)
		return hV:IsA("Tool") and hV:FindFirstChild("Handle") ~= nil
	end
	local b3 = nil
	for e5, K in ipairs(dk) do
		if y(K, e5 - 1, dk) == true then
			b3 = K
			break
		end
	end
	local hW = b3
	if not hW then
		error("A tool with a handle is required to kill this victim")
	end
	hP.Name = ""
	local fz = hP:Clone()
	fz.DisplayName = utf8.char(128298)
	fz.Parent = hN
	fz.Name = "Humanoid"
	task.wait()
	hP:Destroy()
	n.CurrentCamera.CameraSubject = fz
	hW.Parent = hN
	do
		local hX = 0
		local hY = false
		while true do
			if hY then
				hX = hX + 1
			else
				hY = true
			end
			if not (hX < 250) then
				break
			end
			if hR.Parent ~= hO or hQ.Parent ~= hN then
				error("Victim or local player has no root part; did a player respawn?")
			end
			if hW.Parent ~= hN then
				return hQ
			end
			hQ.CFrame = hR.CFrame
			task.wait(0.1)
		end
	end
	error("Failed to attach to victim")
end)
local hZ = a.async(function(hL)
	local eu = a.await(em())
	local h_ = eB.Character
	if h_ ~= nil then
		h_ = h_:FindFirstChild("HumanoidRootPart")
	end
	local i0 = h_
	local b3 = i0
	if b3 ~= nil then
		b3 = b3:IsA("BasePart")
	end
	local u = b3 and i0.CFrame or nil
	eu:dispatch(aS("refresh", true))
	a.await(a.Promise.fromEvent(eB.CharacterAdded, function(eT)
		return eT:WaitForChild("HumanoidRootPart", 5) ~= nil
	end))
	task.wait(0.3)
	local fm = a.await(hK(hL))
	local Z = { hL.Character, eB.Character }
	local hO = Z[1]
	local hN = Z[2]
	repeat
		do
			task.wait(0.1)
			fm.CFrame = CFrame.new(1000000, n.FallenPartsDestroyHeight + 5, 1000000)
		end
		local b4 = hO
		if b4 ~= nil then
			b4 = b4:FindFirstChild("HumanoidRootPart")
		end
		local b5 = b4 ~= nil
		if b5 then
			local ft = hN
			if ft ~= nil then
				ft = ft:FindFirstChild("HumanoidRootPart")
			end
			b5 = ft ~= nil
		end
	until not b5
	local fN = a.await(a.Promise.fromEvent(eB.CharacterAdded, function(eT)
		return eT:WaitForChild("HumanoidRootPart", 5) ~= nil
	end))
	if u then
		fN.HumanoidRootPart.CFrame = u
	end
end)
local et = a.async(function()
	local eu = a.await(em())
	local hu = a.await(ht())
	a.await(eA("kill", function(eM)
		if eM.active then
			if not hu.current then
				eu:dispatch(aS("kill", false))
				return nil
			end
			hZ(hu.current):catch(function(dw)
				return warn("[kill-worker] " .. tostring(dw))
			end):finally(function()
				return eu:dispatch(aS("kill", false))
			end)
		end
	end))
end)
et():catch(function(dw)
	warn("[kill-worker] " .. tostring(dw))
end)
