local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local cQ = a.import(script, a.getModule(script, "@rbxts", "roact-rodux-hooked").out)
local cR = cQ.useDispatch
local cS = cQ.useSelector
local cT = cQ.useStore
local p = cS
local aN = function()
	return cR()
end
local cU = function()
	return cT()
end
return { useAppSelector = p, useAppDispatch = aN, useAppStore = cU }
