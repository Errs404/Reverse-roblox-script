local cv = getgenv == nil
local b5 = VERSION
if b5 == nil then
	b5 = "studio"
end
local cw = b5
return { IS_DEV = cv, VERSION_TAG = cw }
