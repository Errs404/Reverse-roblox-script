local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local cM = a.import(script, a.getModule(script, "@rbxts", "flipper").src)
local cN = cM.GroupMotor
local bw = cM.Spring
local ey = a.import(script, a.getModule(script, "@rbxts", "services"))
local dV = ey.Players
local ez = ey.RunService
local bx = ey.UserInputService
local n = ey.Workspace
local eA = a.import(script, script.Parent.Parent, "helpers", "job-store").onJobChange
local eB = dV.LocalPlayer
local eC = {
	forward = Vector3.new(),
	backward = Vector3.new(),
	left = Vector3.new(),
	right = Vector3.new(),
	up = Vector3.new(),
	down = Vector3.new(),
}
local eD = false
local eE = 16
local eF
local eG
local eH = cN.new({ 0, 0, 0 }, false)
local eI, eJ, eK, eL
local et = a.async(function()
	a.await(eA("flight", function(eM)
		eD = eM.active
		eE = eM.value
		if eD then
			eI()
			eJ()
		end
	end))
	bx.InputBegan:Connect(function(bV, eN)
		if eN then
			return nil
		end
		eK(bV.KeyCode, true)
	end)
	bx.InputEnded:Connect(function(bV)
		eK(bV.KeyCode, false)
	end)
	ez.Heartbeat:Connect(function(eO)
		if eD and (eF and eG) then
			eL(eO)
			eH:setGoal({ bw.new(eG.X), bw.new(eG.Y), bw.new(eG.Z) })
			eH:step(eO)
			local Z = eH:getValue()
			local bU = Z[1]
			local ed = Z[2]
			local eP = Z[3]
			eF.AssemblyLinearVelocity = Vector3.new()
			local eQ = n.CurrentCamera.CFrame.Rotation
			local eR = Vector3.new(bU, ed, eP)
			eF.CFrame = eQ + eR
		end
	end)
	ez.RenderStepped:Connect(function()
		if eD and (eF and eG) then
			local eQ = n.CurrentCamera.CFrame.Rotation
			local eS = eF.CFrame.Position
			eF.CFrame = eQ + eS
		end
	end)
	eB.CharacterAdded:Connect(function(eT)
		local eU = eT:WaitForChild("HumanoidRootPart", 5)
		if eU and eU:IsA("BasePart") then
			eF = eU
		end
		eI()
		eJ()
	end)
	local eV = eB.Character
	if eV ~= nil then
		eV = eV:FindFirstChild("HumanoidRootPart")
	end
	local eW = eV
	if eW and eW:IsA("BasePart") then
		eF = eW
		eI()
	end
end)
local function eX()
	local eY = Vector3.new()
	for ev, eZ in pairs(eC) do
		eY = eY + eZ
	end
	return eY.Magnitude > 0 and eY.Unit or eY
end
function eI()
	if not eF then
		return nil
	end
	local Z = n.CurrentCamera.CFrame
	local e_ = Z.XVector
	local f0 = Z.YVector
	local f1 = Z.ZVector
	eG = CFrame.fromMatrix(eF.Position, e_, f0, f1)
end
function eJ()
	if not eG then
		return nil
	end
	eH = cN.new({ eG.X, eG.Y, eG.Z }, false)
end
function eL(eO)
	if not eG then
		return nil
	end
	local Z = n.CurrentCamera.CFrame
	local e_ = Z.XVector
	local f0 = Z.YVector
	local f1 = Z.ZVector
	local f2 = eX()
	if f2.Magnitude > 0 then
		local y = eE * eO
		local dv = f2 * y
		local dO = dv.X
		local dP = dv.Y
		local f3 = dv.Z
		local aA = CFrame.fromMatrix(eG.Position, e_, f0, f1)
		local ab = CFrame.new(dO, dP, f3)
		eG = aA * ab
	else
		eG = CFrame.fromMatrix(eG.Position, e_, f0, f1)
	end
end
function eK(f4, f5)
	repeat
		if f4 == Enum.KeyCode.W then
			eC.forward = f5 and Vector3.new(0, 0, -1) or Vector3.new()
			break
		end
		if f4 == Enum.KeyCode.S then
			eC.backward = f5 and Vector3.new(0, 0, 1) or Vector3.new()
			break
		end
		if f4 == Enum.KeyCode.A then
			eC.left = f5 and Vector3.new(-1, 0, 0) or Vector3.new()
			break
		end
		if f4 == Enum.KeyCode.D then
			eC.right = f5 and Vector3.new(1, 0, 0) or Vector3.new()
			break
		end
		if f4 == Enum.KeyCode.Q then
			eC.up = f5 and Vector3.new(0, -1, 0) or Vector3.new()
			break
		end
		if f4 == Enum.KeyCode.E then
			eC.down = f5 and Vector3.new(0, 1, 0) or Vector3.new()
			break
		end
	until true
end
et():catch(function(dw)
	warn("[flight-worker] " .. tostring(dw))
end)
