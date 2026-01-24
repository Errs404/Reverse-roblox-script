local a = require(script.Parent.Parent.include.RuntimeLib)
local p = a.import(script, script.Parent, "common", "rodux-hooks").useAppSelector
local function dU()
	return p(function(F)
		return F.dashboard.page
	end)
end
local function c0(c3)
	return p(function(F)
		return F.dashboard.isOpen and F.dashboard.page == c3
	end)
end
return { useCurrentPage = dU, useIsPageOpen = c0 }
