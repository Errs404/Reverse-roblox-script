local a = require(script.Parent.Parent.include.RuntimeLib)
local ez = a.import(script, a.getModule(script, "@rbxts", "services")).RunService
local kv
do
	kv = setmetatable({}, {
		__tostring = function()
			return "Timeout"
		end,
	})
	kv.__index = kv
	function kv.new(...)
		local self = setmetatable({}, kv)
		return self:constructor(...) or self
	end
	function kv:constructor(da, kw, ...)
		local kx = { ... }
		self.running = true
		task.delay(kw / 1000, function()
			if self.running then
				da(unpack(kx))
			end
		end)
	end
	function kv:clear()
		self.running = false
	end
end
local function cX(da, kw, ...)
	local kx = { ... }
	return kv.new(da, kw, unpack(kx))
end
local function cW(ew)
	ew:clear()
end
local ky
do
	ky = setmetatable({}, {
		__tostring = function()
			return "Interval"
		end,
	})
	ky.__index = ky
	function ky.new(...)
		local self = setmetatable({}, ky)
		return self:constructor(...) or self
	end
	function ky:constructor(da, kw, ...)
		local kx = { ... }
		self.running = true
		task.defer(function()
			local kb = 0
			local kz
			kz = ez.Heartbeat:Connect(function(kA)
				kb = kb + kA
				if not self.running then
					kz:Disconnect()
				elseif kb >= kw / 1000 then
					kb = kb - kw / 1000
					da(unpack(kx))
				end
			end)
		end)
	end
	function ky:clear()
		self.running = false
	end
end
local function dg(da, kw, ...)
	local kx = { ... }
	return ky.new(da, kw, unpack(kx))
end
local function df(dj)
	dj:clear()
end
return { setTimeout = cX, clearTimeout = cW, setInterval = dg, clearInterval = df, Timeout = kv, Interval = ky }
