local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local ey = a.import(script, a.getModule(script, "@rbxts", "services"))
local dV = ey.Players
local n = ey.Workspace
local f6 = a.import(script, script.Parent.Parent, "helpers", "job-store")
local em = f6.getStore
local eA = f6.onJobChange
local eB = dV.LocalPlayer
local fu
local fg, fv, fi
local et = a.async(function()
	local function fw(dw)
		warn("[godmode-worker] " .. tostring(dw))
		fg()
	end
	a.await(eA("godmode", function(eM, F)
		if F.jobs.ghost.active and eM.active then
			fg()
		elseif eM.active then
			fv():andThen(fi):catch(fw)
		end
	end))
end)
fg = a.async(function()
	local eu = a.await(em())
	eu:dispatch({ type = "jobs/setJobActive", jobName = "godmode", active = false })
end)
fi = a.async(function()
	local eu = a.await(em())
	a.await(a.Promise.fromEvent(eB.CharacterAdded, function(eT)
		local fx = eu:getState().jobs
		return not fx.ghost.active and eT ~= fu
	end))
	a.await(fg())
end)
fv = a.async(function()
	local fy = n.CurrentCamera.CFrame
	local eT = eB.Character
	if not eT then
		error("Character is null")
	end
	local fl = eT:FindFirstChildWhichIsA("Humanoid")
	if not fl then
		error("No humanoid found")
	end
	local fz = fl:Clone()
	fz.Parent = eT
	fu = eT
	eB.Character = nil
	fz:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	fz:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	fz:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	fz.BreakJointsOnDeath = true
	fz.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	fl:Destroy()
	eB.Character = eT
	n.CurrentCamera.CameraSubject = fz
	task.defer(function()
		n.CurrentCamera.CFrame = fy
	end)
	local fp = eT:FindFirstChild("Animate")
	if fp then
		fp.Disabled = true
		fp.Disabled = false
	end
	fz.MaxHealth = math.huge
	fz.Health = fz.MaxHealth
end)
et():catch(function(dw)
	warn("[godmode-worker] " .. tostring(dw))
end)
