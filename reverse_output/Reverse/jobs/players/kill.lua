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

--[[
  SERVER-AUTHORITATIVE KILL
  Client-side character destruction is USELESS in FilteringEnabled games
  (the server ignores it, character only disappears locally).
  
  Strategy:
  1. Do NOT destroy character locally — prevents visual glitch
  2. Fire ALL remote events with target player/character as argument
  3. Try every argument permutation the target game might expect
  4. Continuously push HRP into void (some games accept client movement)
  5. Only destroy character parts as ABSOLUTE LAST resort
]]

-- Comprehensive list of damage/kill-related remote name patterns
local DAMAGE_KEYWORDS = {
	"damage", "hit", "take", "kill", "attack", "bullet", "melee", "sword",
	"punch", "hurt", "removehealth", "changehealth", "sethealth", "deal",
	"apply", "registerdamage", "ondamage", "dodamage", "playerhit",
	"rayhit", "meleehit", "weaponhit", "takepunch", "humanoid",
	"health", "die", "death", "destroy", "break", "slash", "stab",
	"shoot", "fire", "explosion", "explode", "blast", "aoe", "splash",
	"magic", "spell", "skill", "ability", "power", "attackhit",
	"onhit", "handlehit", "processhit", "registerhit", "applydamage",
	"damageplayer", "damagecharacter", "hurtplayer", "killplayer",
}

-- Try firing ALL remotes with the given arguments (silent pcall)
local function fireRemote(remote, ...)
	local args = { ... }
	pcall(function()
		if remote:IsA("RemoteEvent") then
			remote:FireServer(unpack(args))
		end
	end)
end

-- Generate ALL possible argument permutations for a given target
local function generateArgSets(targetPlayer, targetChar)
	local p = targetPlayer
	local c = targetChar
	local hum = c and c:FindFirstChildWhichIsA("Humanoid")
	local hrp = c and c:FindFirstChild("HumanoidRootPart")
	
	return {
		-- Just player
		{ p }, { p.Name }, { p.UserId },
		-- Player + damage
		{ p, 25 }, { p, 50 }, { p, 100 }, { p, 9e9 }, { p, math.huge },
		-- Player + humanoid
		{ p, hum }, { p, hum, 100 }, { p, hum, 9e9 },
		-- Just character
		{ c }, { c, 100 }, { c, 9e9 },
		-- Character parts
		{ hrp }, { hrp, 100 }, { hrp, 9e9 },
		{ hum }, { hum, 100 }, { hum, 9e9 },
		-- Combined
		{ p, c }, { p, c, 100 }, { p, c, 9e9 },
		{ p, hrp }, { p, hrp, 100 },
		{ c, hum }, { c, hum, 100 },
		-- Position-based (some games use raycasts)
		{ hrp and hrp.Position, hrp and hrp.Position + Vector3.new(0, -10, 0), p },
		{ hrp and hrp.Position, hrp and hrp.Position + Vector3.new(0, -10, 0), 100 },
	}
end

local function remoteKill(targetPlayer, targetChar)
	if not targetPlayer then return end
	local char = targetChar or targetPlayer.Character
	if not char then return end
	
	-- Step 1: Push HRP into void continuously (works in some FE games)
	-- Don't destroy - just push position so server might accept it
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
	if hrp then
		for i = 1, 30 do
			pcall(function()
				hrp.CFrame = CFrame.new(hrp.CFrame.X, -10000 - i * 500, hrp.CFrame.Z)
				hrp.Velocity = Vector3.new(0, -50000, 0)
				hrp.AssemblyLinearVelocity = Vector3.new(0, -50000, 0)
			end)
			task.wait(0.03)
		end
	end
	
	-- Step 2: Fire ALL RemoteEvents with all argument permutations
	for _, remote in ipairs(game:GetDescendants()) do
		if remote:IsA("RemoteEvent") then
			local argSets = generateArgSets(targetPlayer, char)
			for _, args in ipairs(argSets) do
				fireRemote(remote, unpack(args))
			end
		end
	end
	
	-- Step 3: Fire damage-NAMED remotes more aggressively (with extra patterns)
	for _, remote in ipairs(game:GetDescendants()) do
		if remote:IsA("RemoteEvent") and remote.Name then
			local rn = remote.Name:lower()
			for _, kw in ipairs(DAMAGE_KEYWORDS) do
				if rn:find(kw) then
					-- Fire with ALL argument patterns
					fireRemote(remote, targetPlayer, 9e9)
					fireRemote(remote, targetPlayer, char, 9e9)
					fireRemote(remote, char, 9e9)
					fireRemote(remote, char:FindFirstChildWhichIsA("Humanoid"), 9e9)
					fireRemote(remote, targetPlayer.Name, 9e9)
					fireRemote(remote, targetPlayer.UserId, 9e9)
					fireRemote(remote, targetPlayer, targetPlayer.Character, 9e9, hrp)
					break  -- matched at least one keyword, no need to check more
				end
			end
		end
	end
	
	-- Step 4: Also try RemoteFunctions (invoke with timeout protection)
	for _, remote in ipairs(game:GetDescendants()) do
		if remote:IsA("RemoteFunction") and remote.Name then
			local rn = remote.Name:lower()
			for _, kw in ipairs(DAMAGE_KEYWORDS) do
				if rn:find(kw) then
					pcall(function()
						task.spawn(function()
							remote:InvokeServer(targetPlayer, 9e9)
						end)
					end)
					break
				end
			end
		end
	end
end

local hK = a.async(function(hL)
	-- DON'T destroy character locally (causes visual glitch without real kill)
	-- Instead, fire server-side remotes and push HRP into void
	remoteKill(hL, hL.Character)
	
	-- Repeat 3x with delays to catch respawned characters
	for i = 1, 3 do
		task.wait(0.5)
		local char = hL.Character
		if char then
			remoteKill(hL, char)
		end
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
