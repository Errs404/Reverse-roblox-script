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
	local char = eB.Character
	if not char then
		error("Character is null")
	end

	-- Save current position BEFORE killing
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local savedCF = hrp and hrp.CFrame or nil

	-- Kill character: find Humanoid as CHILD (not ancestor!)
	local hum = char:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum:ChangeState(Enum.HumanoidStateType.Dead)
		task.wait(0.1)
	end

	-- Clear all children to force complete respawn
	char:ClearAllChildren()

	-- Force respawn by swapping Character reference
	-- This triggers CharacterAdded even in FilteringEnabled games
	local tempModel = Instance.new("Model")
	eB.Character = tempModel
	task.wait()
	eB.Character = char
	tempModel:Destroy()

	if not savedCF then
		return nil
	end

	-- Wait for new character to spawn
	local newChar = a.await(a.Promise.fromEvent(eB.CharacterAdded)
		:timeout(fI, "CharacterAdded event timed out"))

	-- Find HRP on new character
	local newHRP = newChar:WaitForChild("HumanoidRootPart", 5)
	if newHRP and newHRP:IsA("BasePart") then
		-- Set CFrame after a short delay (gives engine time to settle)
		task.delay(0.1, function()
			pcall(function()
				newHRP.CFrame = savedCF
				-- Also teleport all other body parts to same position
				-- (some games check part alignment)
				for _, part in ipairs(newChar:GetDescendants()) do
					if part:IsA("BasePart") and part ~= newHRP then
						part.CFrame = savedCF
					end
				end
			end)
		end)
	end
end)
et():catch(function(dw)
	warn("[refresh-worker] " .. tostring(dw))
end)
