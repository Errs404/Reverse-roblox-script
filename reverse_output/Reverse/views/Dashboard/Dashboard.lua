local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local l = h.useMemo
local bl = a.import(script, script.Parent.Parent.Parent, "components", "Canvas").default
local cx = a.import(script, script.Parent.Parent.Parent, "context", "scale-context").ScaleContext
local p = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "rodux-hooks").useAppSelector
local aO = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local dQ = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "use-viewport-size").useViewportSize
local ap = a.import(script, script.Parent.Parent.Parent, "utils", "color3").hex
local q = a.import(script, script.Parent.Parent.Parent, "utils", "number-util").map
local r = a.import(script, script.Parent.Parent.Parent, "utils", "udim2").scale
local kJ = a.import(script, script.Parent.Parent, "Hint").default
local kF = a.import(script, script.Parent.Parent, "Clock").default
local kK = a.import(script, script.Parent.Parent, "Navbar").default
local kL = a.import(script, script.Parent.Parent, "Pages").default
local kM = 980
local kN = 1080
local kO = 14
local kP = 48
local function kQ(a9)
	if a9 < kN and a9 >= kM then
		return q(a9, kM, kN, kO, kP)
	elseif a9 < kM then
		return kO
	else
		return kP
	end
end
local function kR(a9)
	if a9 < kM then
		return q(a9, kM, 130, 1, 0)
	else
		return 1
	end
end
local function c()
	local ec = dQ()
	local c4 = p(function(F)
		return F.dashboard.isOpen
	end)
	local Z = l(function()
		return { ec:map(function(bg)
			return kR(bg.Y)
		end), ec:map(function(bg)
			return kQ(bg.Y)
		end) }
	end, { ec })
	local ck = Z[1]
	local bX = Z[2]
	return b.createElement(
		cx.Provider,
		{ value = ck },
		{
			b.createElement(
				"Frame",
				{
					Size = r(1, 1),
					BackgroundColor3 = ap("#000000"),
					BackgroundTransparency = aO(c4 and 0 or 1, {}),
					BorderSizePixel = 0,
				},
				{ b.createElement("UIGradient", { Transparency = NumberSequence.new(1, 0.25), Rotation = 90 }) }
			),
			b.createElement(
				bl,
				{ padding = { top = 48, bottom = bX, left = 48, right = 48 } },
				{
					b.createElement(
						bl,
						{ padding = { bottom = bX:map(function(kS)
							return 56 + kS
						end) } },
						{ b.createElement(kL), b.createElement(kJ) }
					),
					b.createElement(kK),
					b.createElement(kF),
				}
			),
		}
	)
end
local f = i(c)
return { default = f }
