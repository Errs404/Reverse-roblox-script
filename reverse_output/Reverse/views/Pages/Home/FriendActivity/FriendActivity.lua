local a = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local k = h.useEffect
local dn = h.useReducer
local aK = h.useState
local bl = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Canvas").default
local c1 = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "components", "Card").default
local dh = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "use-interval").useInterval
local aO = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "common", "use-spring").useSpring
local e3 = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-friends").useFriendActivity
local ei = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local an =
	a.import(script, script.Parent.Parent.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local jN = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "array-util").arrayToMap
local aq = a.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils", "udim2")
local ar = aq.px
local r = aq.scale
local lz = a.import(script, script.Parent, "GameItem")
local lA = lz.default
local lB = lz.GAME_PADDING
local function lC()
	local aW = ei("home").friendActivity
	local Z = dn(function(F)
		return F + 1
	end, 0)
	local d2 = Z[1]
	local lD = Z[2]
	local dv = e3({ d2 })
	local lE = dv[1]
	local dZ = dv[3]
	local lF = aK(lE)
	local e4 = lF[1]
	local lG = lF[2]
	k(function()
		if #lE > 0 then
			local y = function(hD, dG)
				return #hD.friends > #dG.friends
			end
			table.sort(lE, y)
			lG(lE)
		end
	end, { lE })
	dh(function()
		return lD()
	end, #lE == 0 and dZ ~= "pending" and 5000 or 30000)
	local bf = { index = 3, page = an.Home, theme = aW, size = ar(326, 416), position = UDim2.new(0, 374, 1, 0) }
	local G = {
		b.createElement(
			"TextLabel",
			{
				Text = "Friend Activity",
				Font = "GothamBlack",
				TextSize = 20,
				TextColor3 = aW.foreground,
				TextXAlignment = "Left",
				TextYAlignment = "Top",
				Position = ar(24, 24),
				BackgroundTransparency = 1,
			}
		),
	}
	local H = #G
	local bh = {
		anchor = Vector2.new(0, 1),
		size = aO(#e4 > 0 and UDim2.new(1, 0, 0, 344) or UDim2.new(1, 0, 0, 0), {}),
		position = r(0, 1),
	}
	local bi = {}
	local bj = #bi
	local lH = {
		Size = r(1, 1),
		ScrollBarThickness = 0,
		ScrollBarImageTransparency = 1,
		ScrollingDirection = "Y",
		CanvasSize = ar(0, #e4 * (lB + 156) + lB),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}
	local lI = {}
	local lJ = #lI
	for J, K in
		pairs(jN(e4, function(e6, c2)
			return { tostring(e6.placeId), b.createElement(lA, { gameActivity = e6, index = c2 }) }
		end))
	do
		lI[J] = K
	end
	bi[bj + 1] = b.createElement("ScrollingFrame", lH, lI)
	G[H + 1] = b.createElement(bl, bh, bi)
	return b.createElement(c1, bf, G)
end
local f = i(lC)
return { default = f }
