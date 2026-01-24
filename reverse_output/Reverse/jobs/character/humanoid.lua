local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local dV = a.import(script, a.getModule(script, "@rbxts", "services")).Players
local f6 = a.import(script, script.Parent.Parent, "helpers", "job-store")
local em = f6.getStore
local eA = f6.onJobChange
local fA = 349.24
local eB = dV.LocalPlayer
local es = { walkSpeed = 16, jumpHeight = 7.2 }
local fB, fC, fD, fE
local et = a.async(function()
	local eu = a.await(em())
	local fk = eB.Character
	if fk ~= nil then
		fk = fk:FindFirstChildWhichIsA("Humanoid")
	end
	local fl = fk
	local F = eu:getState()
	local fF = F.jobs.walkSpeed
	local fG = F.jobs.jumpHeight
	a.await(eA("walkSpeed", function(eM)
		if eM.active and not fF.active then
			fB(fl)
		end
		fF = eM
		fC(fl, fF)
	end))
	a.await(eA("jumpHeight", function(eM)
		if eM.active and not fG.active then
			fD(fl)
		end
		fG = eM
		fE(fl, fG)
	end))
	eB.CharacterAdded:Connect(function(eT)
		local fH = eT:WaitForChild("Humanoid", 5)
		if fH and fH:IsA("Humanoid") then
			fl = fH
			fB(fH)
			fD(fH)
			if fF.active then
				fC(fH, fF)
			end
			if fG.active then
				fE(fH, fG)
			end
		end
	end)
	fB(fl)
	fD(fl)
end)
function fB(fl)
	if fl then
		es.walkSpeed = fl.WalkSpeed
	end
end
function fD(fl)
	if fl then
		es.jumpHeight = fl.JumpHeight
	end
end
function fC(fl, fF)
	if not fl then
		return nil
	end
	if fF.active then
		fl.WalkSpeed = fF.value
	else
		fl.WalkSpeed = es.walkSpeed
	end
end
function fE(fl, fG)
	if not fl then
		return nil
	end
	if fG.active then
		fl.JumpHeight = fG.value
		if fl.UseJumpPower then
			fl.JumpPower = math.sqrt(fA * fG.value)
		end
	else
		fl.JumpHeight = es.jumpHeight
		if fl.UseJumpPower then
			fl.JumpPower = math.sqrt(fA * es.jumpHeight)
		end
	end
end
et():catch(function(dw)
	warn("[humanoid-worker] " .. tostring(dw))
end)
