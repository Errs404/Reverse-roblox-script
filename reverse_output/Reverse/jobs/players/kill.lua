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

-- Void-kill: teleport victim HRP below kill plane + zero health
-- No tool dependency, no character refresh, no self-kill
local hK = a.async(function(hL)
	local void = CFrame.new(1000000, n.FallenPartsDestroyHeight - 500, 1000000)
	for _ = 1, 200 do
		local hO = hL.Character
		if not hO then
			break
		end
		local hR = hO:FindFirstChild("HumanoidRootPart")
		if hR then
			hR.CFrame = void
		end
		local hP = hO:FindFirstChildWhichIsA("Humanoid")
		if hP then
			hP.Health = 0
		end
		task.wait(0.1)
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
			hK(hu.current):catch(function(dw)
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
