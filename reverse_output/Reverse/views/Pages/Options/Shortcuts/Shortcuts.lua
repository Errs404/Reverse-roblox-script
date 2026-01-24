local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local aK = h.useState
local bl = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Canvas").default
local c1 = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Card").default
local aM = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "rodux-hooks")
local aN = aM.useAppDispatch
local cU = aM.useAppStore
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local im =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "actions", "dashboard.action").toggleDashboard
local aS = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "actions", "jobs.action").setJobActive
local an =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local aq = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local mA = a.import(script, script.Parent, "ShortcutItem")
local mu = mA.default
local lc = mA.ENTRY_HEIGHT
local lb = mA.PADDING
local mm = 6
local function mq()
	local eu = cU()
	local aZ = aN()
	local aW = ei("options").shortcuts
	local Z = aK(nil)
	local mw = Z[1]
	local mB = Z[2]
	return b.createElement(
		c1,
		{ index = 1, page = an.Options, theme = aW, size = ar(326, 416), position = UDim2.new(0, 0, 1, 0) },
		{
			b.createElement(
				"TextLabel",
				{
					Text = "Shortcuts",
					Font = "GothamBlack",
					TextSize = 20,
					TextColor3 = aW.foreground,
					TextXAlignment = "Left",
					TextYAlignment = "Top",
					Position = ar(24, 24),
					BackgroundTransparency = 1,
				}
			),
			b.createElement(
				bl,
				{ size = ar(326, 348), position = ar(0, 68), padding = { left = 24, right = 24, top = 8 }, clipsDescendants = true },
				{
					b.createElement(
						"ScrollingFrame",
						{
							Size = r(1, 1),
							CanvasSize = ar(0, mm * (lc + lb) + lb),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ScrollBarImageTransparency = 1,
							ScrollBarThickness = 0,
							ClipsDescendants = false,
						},
						{
							b.createElement(mu, {
								onActivate = function()
									aZ(im())
								end,
								onSelect = mB,
								selectedItem = mw,
								action = "toggleDashboard",
								description = "Open Reverse Script",
								index = 0,
							}),
							b.createElement(mu, {
								onActivate = function()
									aZ(aS("flight", not eu:getState().jobs.flight.active))
								end,
								onSelect = mB,
								selectedItem = mw,
								action = "toggleFlight",
								description = "Toggle flight",
								index = 1,
							}),
							b.createElement(mu, {
								onActivate = function()
									aZ(aS("freecam", not eu:getState().jobs.freecam.active))
								end,
								onSelect = mB,
								selectedItem = mw,
								action = "setFreecam",
								description = "Set freecam",
								index = 2,
							}),
							b.createElement(mu, {
								onActivate = function()
									aZ(aS("ghost", not eu:getState().jobs.ghost.active))
								end,
								onSelect = mB,
								selectedItem = mw,
								action = "setGhost",
								description = "Set ghost mode",
								index = 3,
							}),
							b.createElement(mu, {
								onActivate = function()
									aZ(aS("walkSpeed", not eu:getState().jobs.walkSpeed.active))
								end,
								onSelect = mB,
								selectedItem = mw,
								action = "setSpeed",
								description = "Set walk speed",
								index = 4,
							}),
							b.createElement(mu, {
								onActivate = function()
									aZ(aS("jumpHeight", not eu:getState().jobs.jumpHeight.active))
								end,
								onSelect = mB,
								selectedItem = mw,
								action = "setJumpHeight",
								description = "Set jump height",
								index = 5,
							}),
						}
					),
				}
			),
		}
	)
end
local f = i(mq)
return { default = f }
