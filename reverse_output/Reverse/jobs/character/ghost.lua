local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local ey = a.import(script, a.getModule(script, "@rbxts", "services"))
local dV = ey.Players
local n = ey.Workspace
local f6 = a.import(script, script.Parent.Parent, "helpers", "job-store")
local em = f6.getStore
local eA = f6.onJobChange
local eB = dV.LocalPlayer
local f7 = {}
local f8
local f9
local fa
local function fb()
	local fc = eB:FindFirstChildWhichIsA("PlayerGui")
	if fc then
		for ev, fd in ipairs(fc:GetChildren()) do
			if fd:IsA("ScreenGui") and fd.ResetOnSpawn then
				f7[#f7 + 1] = fd
				fd.ResetOnSpawn = false
			end
		end
	end
end
local function fe()
	for ev, ff in ipairs(f7) do
		ff.ResetOnSpawn = true
	end
	table.clear(f7)
end
local fg, fh, fi, fj
local et = a.async(function()
	a.await(eA("ghost", function(eM, F)
		if F.jobs.refresh.active and eM.active then
			fg()
		elseif eM.active then
			fh():andThen(fi):catch(function(dw)
				warn("[ghost-worker-active] " .. tostring(dw))
				fg()
			end)
		elseif not F.jobs.refresh.active then
			fj():catch(function(dw)
				warn("[ghost-worker-inactive] " .. tostring(dw))
			end)
		end
	end))
end)
fg = a.async(function()
	local eu = a.await(em())
	eu:dispatch({ type = "jobs/setJobActive", jobName = "ghost", active = false })
end)
fi = a.async(function()
	a.await(a.Promise.fromEvent(eB.CharacterAdded, function(eT)
		return eT ~= f8 and eT ~= f9
	end))
	a.await(fg())
end)
fh = a.async(function()
	local eT = eB.Character
	local fk = eT
	if fk ~= nil then
		fk = fk:FindFirstChildWhichIsA("Humanoid")
	end
	local fl = fk
	if not eT or not fl then
		error("Character or Humanoid is null")
	end
	eT.Archivable = true
	f9 = eT:Clone()
	eT.Archivable = false
	local fm = eT:FindFirstChild("HumanoidRootPart")
	local b3 = fm
	if b3 ~= nil then
		b3 = b3:IsA("BasePart")
	end
	fa = b3 and fm.CFrame or nil
	f8 = eT
	local fn = f9:FindFirstChildWhichIsA("Humanoid")
	for ev, fo in ipairs(f9:GetDescendants()) do
		if fo:IsA("BasePart") then
			fo.Transparency = 1 - (1 - fo.Transparency) * 0.5
		end
	end
	if fn then
		fn.DisplayName = utf8.char(128123)
	end
	local b4 = f9:FindFirstChild("Animate")
	if b4 ~= nil then
		b4:Destroy()
	end
	local fp = f8:FindFirstChild("Animate")
	if fp then
		fp.Disabled = true
		fp.Parent = f9
	end
	fb()
	f9.Parent = eT.Parent
	eB.Character = f9
	n.CurrentCamera.CameraSubject = fn
	fe()
	if fp then
		fp.Disabled = false
	end
	local at
	at = fl.Died:Connect(function()
		at:Disconnect()
		fg()
	end)
end)
fj = a.async(function()
	if not f8 or not f9 then
		return nil
	end
	local fm = f8:FindFirstChild("HumanoidRootPart")
	local fq = f9:FindFirstChild("HumanoidRootPart")
	local b3 = fq
	if b3 ~= nil then
		b3 = b3:IsA("BasePart")
	end
	local fr = b3 and fq.CFrame or nil
	local fp = f9:FindFirstChild("Animate")
	if fp then
		fp.Disabled = true
		fp.Parent = nil
	end
	f9:Destroy()
	local fl = f8:FindFirstChildWhichIsA("Humanoid")
	local b4 = fl
	if b4 ~= nil then
		local aA = b4:GetPlayingAnimationTracks()
		local y = function(fs)
			return fs:Stop()
		end
		for J, K in ipairs(aA) do
			y(K, J - 1, aA)
		end
	end
	local R = fr or fa
	local ft = fm
	if ft ~= nil then
		ft = ft:IsA("BasePart")
	end
	local b5 = ft
	if b5 then
		b5 = R
	end
	if b5 then
		fm.CFrame = R
	end
	fb()
	eB.Character = f8
	n.CurrentCamera.CameraSubject = fl
	fe()
	if fp then
		fp.Parent = f8
		fp.Disabled = false
	end
	f8 = nil
	f9 = nil
	fa = nil
end)
et():catch(function(dw)
	warn("[ghost-worker] " .. tostring(dw))
end)
