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

-- ABSOLUTE KILL: multi-layer nuke covering R6, R15, Motor6D, custom rigs,
-- server-authoritative characters, and remote-based damage systems.
-- Loops continuously to catch respawns and anti-kill scripts.
local function nukeCharacter(char)
	if not char then return end

	-- Layer 1: Destroy ALL joint types (covers R6 + R15 + custom welds)
	pcall(char.BreakJoints, char)
	for _, joint in ipairs(char:GetDescendants()) do
		local className = joint.ClassName
		if className == "Motor6D" or className == "Weld" or className == "Snap"
			or className == "Glue" or className == "WeldConstraint" or className == "JointInstance" then
			pcall(joint.Destroy, joint)
		end
	end

	-- Layer 2: Humanoid annihilation
	local hum = char:FindFirstChildWhichIsA("Humanoid")
	if hum then
		pcall(function() hum.Health = -1e9 end)
		pcall(function() hum.MaxHealth = 0 end)
		pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
		pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end)
		pcall(function() hum.Parent = nil end)  -- detach from character
		pcall(function() hum:Destroy() end)
	end

	-- Layer 3: Void teleport ALL body parts
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		pcall(function()
			hrp.Anchored = false
			hrp.CFrame = CFrame.new(9e9, -9e9, 9e9)
			hrp.Velocity = Vector3.new(0, -1e5, 0)
		end)
	end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			pcall(function()
				part.Anchored = false
				part.CanCollide = false
				part.CFrame = CFrame.new(9e9, -9e9, 9e9)
				part.Velocity = Vector3.new(0, -1e5, 0)
			end)
		end
	end

	-- Layer 4: Fire damage-related remotes (game-specific)
	-- Searches workspace + Players for RemoteEvents/RemoteFunctions
	-- that look like they handle damage/hit/kill
	for _, remote in ipairs(game:GetDescendants()) do
		if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) and remote.Name then
			local rn = remote.Name:lower()
			if rn:find("damage") or rn:find("hit") or rn:find("take") or rn:find("kill")
				or rn:find("attack") or rn:find("bullet") or rn:find("melee") or rn:find("sword")
				or rn:find("punch") or rn:find("hurt") or rn:find("removehealth") then
				local args = { remote:IsA("RemoteEvent") and "FireServer" or "InvokeServer" }
				pcall(function()
					if remote:IsA("RemoteEvent") then
						remote:FireServer(unpack(args))
					else
						remote:InvokeServer(unpack(args))
					end
				end)
				-- try with character/humanoid as arg
				pcall(function()
					if remote:IsA("RemoteEvent") then
						remote:FireServer(hum or char, 9e9)
						remote:FireServer(char, hum or char, 9e9)
					end
				end)
			end
		end
	end

	-- Layer 5: Destroy all children (complete character wipe)
	for _, child in ipairs(char:GetChildren()) do
		pcall(child.Destroy, child)
	end
end

local hK = a.async(function(hL)
	-- Loop kill 10x over 3s to catch respawns + anti-kill resets
	for i = 1, 10 do
		local char = hL.Character
		if char then
			nukeCharacter(char)
		end
		task.wait(0.3)
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
