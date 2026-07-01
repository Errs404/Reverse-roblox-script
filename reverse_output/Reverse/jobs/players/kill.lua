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

-- Nuclear kill: BreakJoints + ChangeState + void teleport + ClearAllChildren
-- Covers R6, R15, custom rigs, force fields, and anti-kill protections
local hK = a.async(function(hL)
	local char = hL.Character
	if not char then return end

	-- Method 1: BreakJoints — destroys all welds/joints, kills R6/R15 instantly
	pcall(function() char:BreakJoints() end)

	-- Method 2: Humanoid nuke — zero health + force death state
	local hum = char:FindFirstChildWhichIsA("Humanoid")
	if hum then
		pcall(function() hum.Health = 0 end)
		pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
	end

	-- Method 3: Void teleport — send HRP below kill plane
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		pcall(function() hrp.CFrame = CFrame.new(1e6, -5000, 1e6) end)
	end

	-- Method 4: Clean sweep — destroy all parts after delay
	-- Catches games with custom rigs, respawn protection, etc.
	task.delay(0.5, function()
		if char and char.Parent then
			for _, v in ipairs(char:GetChildren()) do
				if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("Model") or v:IsA("Accessory") or v:IsA("Tool") then
					pcall(function() v:Destroy() end)
				end
			end
		end
	end)
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
