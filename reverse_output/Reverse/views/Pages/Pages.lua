local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local i = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).hooked
local b_ = a.import(script, script.Parent.Parent.Parent, "hooks", "common", "use-delayed-update").useDelayedUpdate
local dU = a.import(script, script.Parent.Parent.Parent, "hooks", "use-current-page").useCurrentPage
local an = a.import(script, script.Parent.Parent.Parent, "store", "models", "dashboard.model").DashboardPage
local l6 = a.import(script, script.Parent, "Apps").default
local lR = a.import(script, script.Parent, "Home").default
local ms = a.import(script, script.Parent, "Options").default
local mG = a.import(script, script.Parent, "Scripts").default
local function kL()
	local mH = dU()
	local mI = b_(mH == an.Scripts, 2000, function(lt)
		return lt
	end)
	local G = { home = b.createFragment({ home = b.createElement(lR) }), apps = b.createFragment({
		apps = b.createElement(l6),
	}) }
	local H = #G
	local I = mI and b.createFragment({ scripts = b.createElement(mG) })
	if I then
		if I.elements ~= nil or I.props ~= nil and I.component ~= nil then
			G[H + 1] = I
		else
			for J, K in ipairs(I) do
				G[H + J] = K
			end
		end
	end
	H = #G
	G.options = b.createFragment({ options = b.createElement(ms) })
	return b.createFragment(G)
end
local f = i(kL)
return { default = f }
