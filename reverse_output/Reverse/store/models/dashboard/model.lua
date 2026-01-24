local an
do
	local cf = {}
	an = setmetatable({}, { __index = cf })
	an.Home = "home"
	cf.home = "Home"
	an.Apps = "apps"
	cf.apps = "Apps"
	an.Scripts = "scripts"
	cf.scripts = "Scripts"
	an.Options = "options"
	cf.options = "Options"
end
local iD = { [an.Home] = 0, [an.Apps] = 1, [an.Scripts] = 2, [an.Options] = 3 }
local iE = {
	[an.Home] = "rbxassetid://8992031167",
	[an.Apps] = "rbxassetid://8992031246",
	[an.Scripts] = "rbxassetid://8992030918",
	[an.Options] = "rbxassetid://8992031056",
}
return { DashboardPage = an, PAGE_TO_INDEX = iD, PAGE_TO_ICON = iE }
