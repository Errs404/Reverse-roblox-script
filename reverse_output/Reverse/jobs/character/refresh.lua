local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local ey = a.import(script, a.getModule(script, "@rbxts", "services"))
local dV = ey.Players
local n = ey.Workspace
local f6 = a.import(script, script.Parent.Parent, "helpers", "job-store")
local em = f6.getStore
local eA = f6.onJobChange
local fI = 10
local eB = dV.LocalPlayer
local fJ
local et = a.async(function()
	local eu = a.await(em())
	local function fg()
		eu:dispatch({ type = "jobs/setJobActive", jobName = "refresh", active = false })
	end
	a.await(eA("refresh", function(eM, F)
		if F.jobs.ghost.active and eM.active then
			fg()
		elseif eM.active then
			fJ():catch(function(dw)
				return warn("[refresh-worker-respawn] " .. tostring(dw))
			end):finally(function()
				return fg()
			end)
		end
	end))
end)
fJ = a.async(function()
	local eT = eB.Character
	if not eT then
		error("Character is null")
	end
	local fK = eT:FindFirstChild("HumanoidRootPart")
	if fK ~= nil then
		fK = fK.CFrame
	end
	local fL = fK
	local fl = eT:FindFirstAncestorWhichIsA("Humanoid")
	local b3 = fl
	if b3 ~= nil then
		b3:ChangeState(Enum.HumanoidStateType.Dead)
	end
	eT:ClearAllChildren()
	local fM = Instance.new("Model", n)
	eB.Character = fM
	eB.Character = eT
	fM:Destroy()
	if not fL then
		return nil
	end
	local fN = a.await(a.Promise.fromEvent(eB.CharacterAdded):timeout(fI, "CharacterAdded event timed out"))
	local eF = fN:WaitForChild("HumanoidRootPart", 5)
	if eF and (eF:IsA("BasePart") and fL) then
		task.delay(0.1, function()
			eF.CFrame = fL
		end)
	end
end)
et():catch(function(dw)
	warn("[refresh-worker] " .. tostring(dw))
end)
