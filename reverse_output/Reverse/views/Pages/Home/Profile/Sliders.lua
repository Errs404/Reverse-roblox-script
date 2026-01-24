local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local cc = h.useBinding
local aK = h.useState
local aL = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "BrightButton").default
local bD = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "BrightSlider").default
local bl = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Canvas").default
local aM = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "rodux-hooks")
local aN = aM.useAppDispatch
local p = aM.useAppSelector
local aO = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local aP = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "actions", "dashboard.action")
local aQ = aP.clearHint
local aR = aP.setHint
local m0 = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "actions", "jobs.action")
local aS = m0.setJobActive
local iw = m0.setJobValue
local aq = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local bB = { frequency = 5 }
local m1
local function l_()
	return b.createElement(
		bl,
		{ size = ar(278, 187), position = ar(0, 368) },
		{
			b.createElement(
				m1,
				{
					display = "Flight",
					hint = "<font face='GothamBlack'>Configure flight</font> in studs per second",
					jobName = "flight",
					units = "studs/s",
					min = 10,
					max = 100,
					position = 0,
				}
			),
			b.createElement(
				m1,
				{
					display = "Speed",
					hint = "<font face='GothamBlack'>Configure speed</font> in studs per second",
					jobName = "walkSpeed",
					units = "studs/s",
					min = 0,
					max = 100,
					position = 69,
				}
			),
			b.createElement(
				m1,
				{
					display = "Jump",
					hint = "<font face='GothamBlack'>Configure height</font> in studs",
					jobName = "jumpHeight",
					units = "studs",
					min = 0,
					max = 500,
					position = 138,
				}
			),
		}
	)
end
local f = l_
local function m2(l2)
	local aW = ei("home").profile
	local aZ = aN()
	local eM = p(function(F)
		return F.jobs[l2.jobName]
	end)
	local Z = cc(eM.value)
	local d3 = Z[1]
	local m3 = Z[2]
	local dv = aK(false)
	local b0 = dv[1]
	local b1 = dv[2]
	local b2 = aW.highlight[l2.jobName]
	local b3
	if eM.active then
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
	local m4 = aO(b3, {})
	local m5 = aO(eM.active and aW.button.foregroundAccent and aW.button.foregroundAccent or aW.foreground, {})
	return b.createElement(
		bl,
		{ size = ar(278, 49), position = ar(0, l2.position) },
		{
			b.createElement(
				bD,
				{
					onValueChanged = m3,
					onRelease = function()
						return aZ(iw(l2.jobName, math.round(d3:getValue())))
					end,
					min = l2.min,
					max = l2.max,
					initialValue = eM.value,
					size = ar(181, 49),
					position = ar(0, 0),
					radius = 8,
					color = aW.slider.background,
					accentColor = b2,
					borderEnabled = aW.slider.outlined,
					borderColor = aW.slider.foreground,
					transparency = aW.slider.backgroundTransparency,
					indicatorTransparency = aW.slider.indicatorTransparency,
				},
				{
					b.createElement(
						"TextLabel",
						{
							Font = "GothamBold",
							Text = d3:map(function(d3)
								return tostring(math.round(d3)) .. " " .. l2.units
							end),
							TextSize = 15,
							TextColor3 = aW.slider.foreground,
							TextXAlignment = "Center",
							TextYAlignment = "Center",
							TextTransparency = aW.slider.foregroundTransparency,
							Size = r(1, 1),
							BackgroundTransparency = 1,
						}
					),
				}
			),
			b.createElement(
				aL,
				{
					onActivate = function()
						return aZ(aS(l2.jobName, not eM.active))
					end,
					onHover = function(b0)
						if b0 then
							b1(true)
							aZ(aR(l2.hint))
						else
							b1(false)
							aZ(aQ())
						end
					end,
					size = ar(85, 49),
					position = ar(193, 0),
					radius = 8,
					color = m4,
					borderEnabled = aW.button.outlined,
					borderColor = m5,
					transparency = aW.button.backgroundTransparency,
				},
				{
					b.createElement(
						"TextLabel",
						{
							Font = "GothamBold",
							Text = l2.display,
							TextSize = 15,
							TextColor3 = m5,
							TextXAlignment = "Center",
							TextYAlignment = "Center",
							TextTransparency = aO(
								eM.active and 0
									or (
										b0 and aW.button.foregroundTransparency - 0.25
										or aW.button.foregroundTransparency
									),
								{}
							),
							Size = r(1, 1),
							BackgroundTransparency = 1,
						}
					),
				}
			),
		}
	)
end
m1 = i(m2)
return { default = f }
