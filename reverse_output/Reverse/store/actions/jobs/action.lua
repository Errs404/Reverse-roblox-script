local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local it = a.import(script, a.getModule(script, "@rbxts", "rodux").src)
local aS = it.makeActionCreator("jobs/setJobActive", function(hB, a_)
	return { jobName = hB, active = a_ }
end)
local iw = it.makeActionCreator("jobs/setJobValue", function(hB, d3)
	return { jobName = hB, value = d3 }
end)
return { setJobActive = aS, setJobValue = iw }
