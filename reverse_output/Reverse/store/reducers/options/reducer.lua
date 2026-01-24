local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local it = a.import(script, a.getModule(script, "@rbxts", "rodux").src)
local iK = a.import(script, script.Parent.Parent, "persistent-state").persistentState
local dB = iK(
	"options",
	function(F)
		return F.options
	end,
	{ currentTheme = "Sorbet", config = { acrylicBlur = true }, shortcuts = { toggleDashboard = Enum.KeyCode.K.Value } }
)
local iT = it.createReducer(dB, {
	["options/setConfig"] = function(F, aU)
		local ax = {}
		for J, K in pairs(F) do
			ax[J] = K
		end
		local ay = "config"
		local az = {}
		for J, K in pairs(F.config) do
			az[J] = K
		end
		az[aU.name] = aU.active
		ax[ay] = az
		return ax
	end,
	["options/setTheme"] = function(F, aU)
		local ax = {}
		for J, K in pairs(F) do
			ax[J] = K
		end
		ax.currentTheme = aU.theme
		return ax
	end,
	["options/setShortcut"] = function(F, aU)
		local ax = {}
		for J, K in pairs(F) do
			ax[J] = K
		end
		local ay = "shortcuts"
		local az = {}
		for J, K in pairs(F.shortcuts) do
			az[J] = K
		end
		az[aU.shortcut] = aU.keycode
		ax[ay] = az
		return ax
	end,
	["options/removeShortcut"] = function(F, aU)
		local ax = {}
		for J, K in pairs(F) do
			ax[J] = K
		end
		local ay = "shortcuts"
		local az = {}
		for J, K in pairs(F.shortcuts) do
			az[J] = K
		end
		az[aU.shortcut] = nil
		ax[ay] = az
		return ax
	end,
})
return { optionsReducer = iT }
