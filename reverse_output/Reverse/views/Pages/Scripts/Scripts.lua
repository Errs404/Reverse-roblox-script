local a = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local l5 = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).pure
local bl = a.import(script, script.Parent.Parent.Parent.Parent, "components", "Canvas").default
local ic = a.import(script, script.Parent.Parent.Parent.Parent, "utils", "http")
local r = a.import(script, script.Parent.Parent.Parent.Parent, "utils", "udim2").scale
local n1 = a.import(script, script.Parent, "constants")
local n2 = n1.BASE_PADDING
local n3 = n1.BASE_WINDOW_HEIGHT
local mL = a.import(script, script.Parent, "Content").default
local mR = a.import(script, script.Parent, "ScriptCard").default
local n4 = a.async(function(kl, n5)
	local iN, iO = a.try(function()
		local iI = a.await(ic.get(kl))
		local kj, dw = loadstring(iI, "@" .. n5)
		local dz = "Failed to call loadstring on Lua script from '" .. kl .. "': " .. tostring(dw)
		assert(kj, dz)
		task.defer(kj)
	end, function(n6)
		warn("Failed to run Lua script from '" .. kl .. "': " .. tostring(n6))
		return a.TRY_RETURN, { "" }
	end)
	if iN then
		return unpack(iO)
	end
end)
local function mG()
	return b.createElement(
		bl,
		{ position = r(0, 1), anchor = Vector2.new(0, 1) },
		{
			b.createElement(mR, {
				onActivate = function()
					return n4("https://solarishub.dev/script.lua", "Solaris")
				end,
				index = 4,
				backgroundImage = "rbxassetid://8992292705",
				backgroundImageSize = Vector2.new(1023, 682),
				dropshadow = "rbxassetid://8992292536",
				dropshadowSize = Vector2.new(1.15, 1.25),
				dropshadowPosition = Vector2.new(0.5, 0.55),
				anchorPoint = Vector2.new(0, 0),
				size = UDim2.new(1 / 3, -n2 * 2 / 3, (416 + n2 / 2) / n3, -n2 / 2),
				position = r(0, 0),
			}, { b.createElement(mL, { header = "ComingSoon", body = "", footer = "ReverseInc." }) }),
		}
	)
end
local f = l5(mG)
return { default = f }
