local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local k = h.useEffect
local m = h.useMutable
local function d9(da)
	local db = m(da)
	k(function()
		if db.current then
			db.current()
		end
	end, {})
	return db
end
local function dc()
	local db = m(true)
	k(function()
		db.current = false
	end, {})
	return db.current
end
return { useDidMount = d9, useIsMount = dc }
