local function jT(bc)
	if typeof(bc) == "ColorSequence" then
		bc = bc.Keypoints[1].Value
	end
	return bc.R * 0.2126 + bc.G * 0.7152 + bc.B * 0.0722
end
local function jU(jV, bN)
	local c2 = math.floor(bN * (#jV.Keypoints - 1))
	local jW = math.min(c2 + 1, #jV.Keypoints - 1)
	local b5 = jV.Keypoints[c2 + 1]
	if b5 == nil then
		b5 = jV.Keypoints[1]
	end
	local jX = b5
	local jY = jV.Keypoints[jW + 1]
	if jY == nil then
		jY = jX
	end
	local jZ = jY
	return jX.Value:Lerp(jZ.Value, bN * (#jV.Keypoints - 1) - c2)
end
local j_ = function(ap)
	local k0 = string.gsub(ap, "#", "0x", 1)
	local b5 = tonumber(k0)
	if b5 == nil then
		b5 = 0
	end
	return b5
end
local k1 = function(k2)
	return Color3.fromRGB(math.floor(k2 / 65536) % 256, math.floor(k2 / 256) % 256, k2 % 256)
end
local ap = function(ap)
	return k1(j_(ap))
end
local k3 = function(cb, dF, dG)
	return Color3.fromRGB(cb, dF, dG)
end
local k4 = function(k5, bg, bM)
	return Color3.fromHSV(k5 / 360, bg / 100, bM / 100)
end
local k6 = function(k5, bg, k7)
	local k8 = bg * (k7 < 50 and k7 or 100 - k7) / 100
	local k9 = k8 == 0 and 0 or 2 * k8 / (k7 + k8) * 100
	local ka = k7 + k8
	return Color3.fromHSV(k5 / 255, k9 / 100, ka / 100)
end
return { getLuminance = jT, getColorInSequence = jU, hex = ap, rgb = k3, hsv = k4, hsl = k6 }
