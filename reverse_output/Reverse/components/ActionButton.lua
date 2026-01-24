local a = require(script.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local aK = h.useState
local aL = a.import(script, script.Parent, "BrightButton").default
local aM = a.import(script, script.Parent.Parent, "hooks", "common", "rodux-hooks")
local aN = aM.useAppDispatch
local p = aM.useAppSelector
local aO = a.import(script, script.Parent.Parent, "hooks", "common", "use-spring").useSpring
local aP = a.import(script, script.Parent.Parent, "store", "actions", "dashboard.action")
local aQ = aP.clearHint
local aR = aP.setHint
local aS = a.import(script, script.Parent.Parent, "store", "actions", "jobs.action").setJobActive
local ar = a.import(script, script.Parent.Parent, "utils", "udim2").px
local function aT(C)
	local aU = C.action
	local aV = C.hint
	local aW = C.theme
	local aX = C.image
	local R = C.position
	local aY = C.canDeactivate
	local aZ = aN()
	local a_ = p(function(F)
		return F.jobs[aU].active
	end)
	local Z = aK(false)
	local b0 = Z[1]
	local b1 = Z[2]
	local b2 = aW.highlight[aU] ~= nil and aW.highlight[aU] or aW.background
	if not (aW.highlight[aU] ~= nil) then
		warn("ActionButton: " .. aU .. " is not in theme.highlight")
	end
	local b3
	if a_ then
		b3 = b2
	else
		local b4
		if b0 then
			local b5 = aW.button.backgroundHovered
			if b5 == nil then
				b5 = aW.button.background:Lerp(b2, 0.1)
			end
			b4 = b5
		else
			b4 = aW.button.background
		end
		b3 = b4
	end
	local b6 = aO(b3, {})
	local b7 = aO(a_ and aW.button.foregroundAccent and aW.button.foregroundAccent or aW.button.foreground, {})
	return b.createElement(
		aL,
		{
			onActivate = function()
				if a_ and aY then
					aZ(aS(aU, false))
				elseif not a_ then
					aZ(aS(aU, true))
				end
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
			size = ar(61, 49),
			position = R,
			radius = 8,
			color = b6,
			borderEnabled = aW.button.outlined,
			borderColor = b7,
			transparency = aW.button.backgroundTransparency,
		},
		{
			b.createElement(
				"ImageLabel",
				{
					Image = aX,
					ImageColor3 = b7,
					ImageTransparency = aO(
						a_ and 0 or (b0 and aW.button.foregroundTransparency - 0.25 or aW.button.foregroundTransparency),
						{}
					),
					Size = ar(36, 36),
					Position = ar(12, 6),
					BackgroundTransparency = 1,
				}
			),
		}
	)
end
local f = i(aT)
return { default = f }
