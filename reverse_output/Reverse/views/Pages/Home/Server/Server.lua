local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local dV = a.import(script, a.getModule(script, "@rbxts", "services")).Players
local c1 = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Card").default
local cv = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "constants").IS_DEV
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local an =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local ar = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2").px
local m6 = a.import(script, script.Parent, "ServerAction").default
local m7 = a.import(script, script.Parent, "StatusLabel").default
local function lP()
	local aW = ei("home").server
	return b.createElement(
		c1,
		{ index = 2, page = an.Home, theme = aW, size = ar(326, 184), position = UDim2.new(0, 374, 1, -416 - 48) },
		{
			b.createElement(
				"TextLabel",
				{
					Text = "Server",
					Font = "GothamBlack",
					TextSize = 20,
					TextColor3 = aW.foreground,
					TextXAlignment = "Left",
					TextYAlignment = "Top",
					Position = ar(24, 24),
					BackgroundTransparency = 1,
				}
			),
			b.createElement(m7, {
				index = 0,
				offset = 69,
				units = "players",
				getValue = function()
					return tostring(#dV:GetPlayers()) .. " / " .. tostring(dV.MaxPlayers)
				end,
			}),
			b.createElement(m7, {
				index = 1,
				offset = 108,
				units = "elapsed",
				getValue = function()
					local m8 = cv and os.clock() or time()
					local m9 = math.floor(m8 / 86400)
					local ma = math.floor((m8 - m9 * 86400) / 3600)
					local mb = math.floor((m8 - m9 * 86400 - ma * 3600) / 60)
					local mc = math.floor(m8 - m9 * 86400 - ma * 3600 - mb * 60)
					return m9 > 0 and tostring(m9) .. " days"
						or (
							ma > 0 and tostring(ma) .. " hours"
							or (mb > 0 and tostring(mb) .. " minutes" or tostring(mc) .. " seconds")
						)
				end,
			}),
			b.createElement(m7, {
				index = 2,
				offset = 147,
				units = "ping",
				getValue = function()
					return tostring(math.round(dV.LocalPlayer:GetNetworkPing() * 1000)) .. " ms"
				end,
			}),
			b.createElement(
				m6,
				{
					action = "switchServer",
					hint = "<font face='GothamBlack'>Switch</font> to a different server",
					icon = "rbxassetid://8992259774",
					size = ar(66, 50),
					position = UDim2.new(1, -66 - 24, 1, -100 - 16 - 12),
				}
			),
			b.createElement(
				m6,
				{
					action = "rejoinServer",
					hint = "<font face='GothamBlack'>Rejoin</font> this server",
					icon = "rbxassetid://8992259894",
					size = ar(66, 50),
					position = UDim2.new(1, -66 - 24, 1, -50 - 16),
				}
			),
		}
	)
end
local f = i(lP)
return { default = f }
