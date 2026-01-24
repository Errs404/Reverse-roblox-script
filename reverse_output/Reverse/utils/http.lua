local a = require(script.Parent.Parent.include.RuntimeLib)
local ia = a.import(script, a.getModule(script, "@rbxts", "services")).HttpService
local cv = a.import(script, script.Parent.Parent, "constants").IS_DEV
local kh
kh = a.async(function(ki)
	if cv then
		return ia:RequestAsync(ki)
	else
		local kj = syn and syn.request or kh
		if not kj then
			error("request/syn.request is not available")
		end
		return kj(ki)
	end
end)
local kk = a.async(function(kl, km)
	return game:HttpGetAsync(kl, km)
end)
local kn = a.async(function(kl, hG, ko, km)
	return game:HttpPostAsync(kl, hG, ko, km)
end)
return { request = kh, get = kk, post = kn }
