local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local bw = a.import(script, a.getModule(script, "@rbxts", "flipper").src).Spring
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local by = a.import(script, script.Parent, "flipper-hooks")
local bz = by.getBinding
local bA = by.useMotor
local dD = by.useSpring
local dE = {
	number = dD,
	Color3 = function(bc, cL)
		local cB = bA({ bc.R, bc.G, bc.B })
		cB:setGoal({ bw.new(bc.R, cL), bw.new(bc.G, cL), bw.new(bc.B, cL) })
		return bz(cB):map(function(C)
			local cb = C[1]
			local dF = C[2]
			local dG = C[3]
			return Color3.new(cb, dF, dG)
		end)
	end,
	UDim = function(dH, cL)
		local cB = bA({ dH.Scale, dH.Offset })
		cB:setGoal({ bw.new(dH.Scale, cL), bw.new(dH.Offset, cL) })
		return bz(cB):map(function(C)
			local bg = C[1]
			local cu = C[2]
			return UDim.new(bg, cu)
		end)
	end,
	UDim2 = function(dI, cL)
		local cB = bA({ dI.X.Scale, dI.X.Offset, dI.Y.Scale, dI.Y.Offset })
		cB:setGoal({ bw.new(dI.X.Scale, cL), bw.new(dI.X.Offset, cL), bw.new(dI.Y.Scale, cL), bw.new(dI.Y.Offset, cL) })
		return bz(cB):map(function(C)
			local dJ = C[1]
			local dK = C[2]
			local dL = C[3]
			local dM = C[4]
			return UDim2.new(dJ, math.round(dK), dL, math.round(dM))
		end)
	end,
	Vector2 = function(dN, cL)
		local cB = bA({ dN.X, dN.Y })
		cB:setGoal({ bw.new(dN.X, cL), bw.new(dN.Y, cL) })
		return bz(cB):map(function(C)
			local dO = C[1]
			local dP = C[2]
			return Vector2.new(dO, dP)
		end)
	end,
}
local function aO(d3, cL)
	if not cL then
		return b.createBinding(d3)
	end
	local aO = dE[typeof(d3)]
	local dz = "useAnySpring: " .. typeof(d3) .. " is not supported"
	assert(aO, dz)
	return aO(d3, cL)
end
return { useSpring = aO }
