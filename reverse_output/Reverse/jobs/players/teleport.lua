local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local dV = a.import(script, a.getModule(script, "@rbxts", "services")).Players
local ht = a.import(script, script.Parent.Parent, "helpers", "get-selected-player").getSelectedPlayer
local f6 = a.import(script, script.Parent.Parent, "helpers", "job-store")
local em = f6.getStore
local eA = f6.onJobChange
local aS = a.import(script, script.Parent.Parent.Parent, "store", "actions", "jobs.action").setJobActive
local cX = a.import(script, script.Parent.Parent.Parent, "utils", "timeout").setTimeout
local et = a.async(function()
	local eu = a.await(em())
	local hu = a.await(ht(function()
		eu:dispatch(aS("teleport", false))
	end))
	local ew
	a.await(eA("teleport", function(eM)
		local b3 = ew
		if b3 ~= nil then
			b3:clear()
		end
		ew = nil
		if eM.active then
			local i7 = dV.LocalPlayer.Character
			if i7 ~= nil then
				i7 = i7:FindFirstChild("HumanoidRootPart")
			end
			local fm = i7
			local i8 = hu.current
			if i8 ~= nil then
				i8 = i8.Character
				if i8 ~= nil then
					i8 = i8:FindFirstChild("HumanoidRootPart")
				end
			end
			local i9 = i8
			if not i9 or (not fm or (not fm:IsA("BasePart") or not i9:IsA("BasePart"))) then
				eu:dispatch(aS("teleport", false))
				warn("[teleport-worker] Failed to find root parts (" .. tostring(fm) .. " -> " .. tostring(i9) .. ")")
				return nil
			end
			ew = cX(function()
				eu:dispatch(aS("teleport", false))
				local ab = i9.CFrame
				local ac = CFrame.new(0, 0, 1)
				fm.CFrame = ab * ac
			end, 1000)
		end
	end))
end)
et():catch(function(dw)
	warn("[teleport-worker] " .. tostring(dw))
end)
