local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local it = a.import(script, a.getModule(script, "@rbxts", "rodux").src)
local an = a.import(script, script.Parent.Parent, "models", "dashboard.model").DashboardPage
local dB = { page = an.Home, isOpen = false, hint = nil, apps = { playerSelected = nil } }
local iR = it.createReducer(dB, {
	["dashboard/setDashboardPage"] = function(F, aU)
		local ax = {}
		for J, K in pairs(F) do
			ax[J] = K
		end
		ax.page = aU.page
		return ax
	end,
	["dashboard/toggleDashboard"] = function(F)
		local ax = {}
		for J, K in pairs(F) do
			ax[J] = K
		end
		ax.isOpen = not F.isOpen
		return ax
	end,
	["dashboard/setHint"] = function(F, aU)
		local ax = {}
		for J, K in pairs(F) do
			ax[J] = K
		end
		ax.hint = aU.hint
		return ax
	end,
	["dashboard/clearHint"] = function(F)
		local ax = {}
		for J, K in pairs(F) do
			ax[J] = K
		end
		ax.hint = nil
		return ax
	end,
	["dashboard/playerSelected"] = function(F, aU)
		local ax = {}
		for J, K in pairs(F) do
			ax[J] = K
		end
		local ay = "apps"
		local az = {}
		for J, K in pairs(F.apps) do
			az[J] = K
		end
		az.playerSelected = aU.name
		ax[ay] = az
		return ax
	end,
	["dashboard/playerDeselected"] = function(F)
		local ax = {}
		for J, K in pairs(F) do
			ax[J] = K
		end
		local ay = "apps"
		local az = {}
		for J, K in pairs(F.apps) do
			az[J] = K
		end
		az.playerSelected = nil
		ax[ay] = az
		return ax
	end,
})
return { dashboardReducer = iR }
