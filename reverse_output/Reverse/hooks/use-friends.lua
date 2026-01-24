local a = require(script.Parent.Parent.include.RuntimeLib)
local l = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out).useMemo
local dV = a.import(script, a.getModule(script, "@rbxts", "services")).Players
local du = a.import(script, script.Parent, "common", "use-promise").usePromise
local function dW(di)
	return du(
		a.async(function()
			return dV.LocalPlayer:GetFriendsOnline()
		end),
		di
	)
end
local function dX(di)
	local Z = dW(di)
	local dY = Z[1]
	local dw = Z[2]
	local dZ = Z[3]
	local d_ = dY
	if d_ ~= nil then
		local y = function(e0)
			return e0.PlaceId ~= nil and e0.GameId ~= nil
		end
		local e1 = {}
		local H = 0
		for J, K in ipairs(d_) do
			if y(K, J - 1, d_) == true then
				H = H + 1
				e1[H] = K
			end
		end
		d_ = e1
	end
	local e2 = d_
	return { e2, dw, dZ }
end
local function e3(di)
	local Z = dX(di)
	local dY = Z[1]
	local dw = Z[2]
	local dZ = Z[3]
	local e4 = l(function()
		return {}
	end, di)
	if not dY or #e4 > 0 then
		return { e4, dw, dZ }
	end
	local y = function(e0)
		local c7 = function(dF)
			return dF.placeId == e0.PlaceId
		end
		local b3 = nil
		for e5, K in ipairs(e4) do
			if c7(K, e5 - 1, e4) == true then
				b3 = K
				break
			end
		end
		local e6 = b3
		if not e6 then
			e6 = {
				friends = { e0 },
				placeId = e0.PlaceId,
				thumbnail = "https://www.roblox.com/asset-thumbnail/image?assetId="
					.. tostring(e0.PlaceId)
					.. "&width=768&height=432&format=png",
			}
			local e7 = e6
			e4[#e4 + 1] = e7
		else
			local e8 = e6.friends
			e8[#e8 + 1] = e0
		end
	end
	for J, K in ipairs(dY) do
		y(K, J - 1, dY)
	end
	return { e4, dw, dZ }
end
return { useFriends = dW, useFriendsPlaying = dX, useFriendActivity = e3 }
