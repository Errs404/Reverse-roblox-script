local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local aK = h.useState
local aL = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "BrightButton").default
local aM = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "rodux-hooks")
local aN = aM.useAppDispatch
local p = aM.useAppSelector
local aO = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local aP = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "actions", "dashboard.action")
local aQ = aP.clearHint
local aR = aP.setHint
local aS = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "actions", "jobs.action").setJobActive
local aq = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local function m6(C)
	local aU = C.action
	local aV = C.hint
	local md = C.icon
	local Q = C.size
	local R = C.position
	local aZ = aN()
	local aW = ei("home").server[aU == "switchServer" and "switchButton" or "rejoinButton"]
	local a_ = p(function(F)
		return F.jobs[aU].active
	end)
	local Z = aK(false)
	local b0 = Z[1]
	local b1 = Z[2]
	local b3
	if a_ then
		b3 = aW.accent
	else
		local b4
		if b0 then
			local b5 = aW.backgroundHovered
			if b5 == nil then
				b5 = aW.background:Lerp(aW.accent, 0.1)
			end
			b4 = b5
		else
			b4 = aW.background
		end
		b3 = b4
	end
	local b6 = aO(b3, {})
	local b7 = aO(a_ and aW.foregroundAccent and aW.foregroundAccent or aW.foreground, {})
	return b.createElement(
		aL,
		{
			onActivate = function()
				return aZ(aS(aU, not a_))
			end,
			onHover = function(b0)
				if b0 then
					b1(true)
					aZ(aR(aV))
				else
					b1(false)
					aZ(aQ())
				end
			end,
			size = Q,
			position = R,
			radius = 8,
			color = b6,
			borderEnabled = aW.outlined,
			borderColor = b7,
			transparency = aW.backgroundTransparency,
		},
		{
			b.createElement(
				"ImageLabel",
				{
					Image = md,
					ImageColor3 = b7,
					ImageTransparency = aO(
						a_ and 0 or (b0 and aW.foregroundTransparency - 0.25 or aW.foregroundTransparency),
						{}
					),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = ar(36, 36),
					Position = r(0.5, 0.5),
					BackgroundTransparency = 1,
				}
			),
		}
	)
end
local f = i(m6)
return { default = f }
