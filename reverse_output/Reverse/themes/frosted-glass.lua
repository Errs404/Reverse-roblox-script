local a = require(script.Parent.Parent.include.RuntimeLib)
local eh = a.import(script, script.Parent, "dark-theme").darkTheme
local ap = a.import(script, script.Parent.Parent, "utils", "color3").hex
local b2 = ap("#000000")
local j0 = ColorSequence.new(ap("#000000"))
local j1 = {
	acrylic = true,
	outlined = true,
	foreground = ap("#ffffff"),
	background = ap("#ffffff"),
	backgroundGradient = nil,
	transparency = 0.9,
	dropshadow = ap("#ffffff"),
	dropshadowTransparency = 0,
	dropshadowGradient = { color = ColorSequence.new(ap("#000000")), transparency = NumberSequence.new(1, 0.8), rotation = 90 },
}
local ax = {}
for J, K in pairs(eh) do
	ax[J] = K
end
ax.name = "Frosted glass"
ax.preview = {
	foreground = { color = ColorSequence.new(ap("#ffffff")) },
	background = { color = ColorSequence.new(ap("#ffffff")) },
	accent = { color = j0 },
}
local ay = "navbar"
local az = {}
for J, K in pairs(eh.navbar) do
	az[J] = K
end
az.outlined = true
az.acrylic = true
az.foreground = ap("#ffffff")
az.background = ap("#ffffff")
az.backgroundGradient = nil
az.transparency = 0.9
az.dropshadow = ap("#000000")
az.dropshadowTransparency = 0.2
az.accentGradient = { color = ColorSequence.new(ap("#ffffff")), transparency = NumberSequence.new(0.8), rotation = 90 }
az.glowTransparency = 0.5
ax[ay] = az
ax.clock = {
	outlined = true,
	acrylic = true,
	foreground = ap("#ffffff"),
	background = ap("#ffffff"),
	backgroundGradient = nil,
	transparency = 0.9,
	dropshadow = ap("#000000"),
	dropshadowTransparency = 0.2,
}
local j2 = "home"
local aB = {}
local j3 = "title"
local aD = {}
for J, K in pairs(j1) do
	aD[J] = K
end
aB[j3] = aD
local j4 = "profile"
local aF = {}
for J, K in pairs(j1) do
	aF[J] = K
end
local j5 = "avatar"
local aH = {}
for J, K in pairs(eh.home.profile.avatar) do
	aH[J] = K
end
aH.background = ap("#ffffff")
aH.transparency = 0.7
aH.gradient =
	{ color = ColorSequence.new(ap("#ffffff"), ap("#ffffff")), transparency = NumberSequence.new(0.5, 1), rotation = 45 }
aF[j5] = aH
aF.highlight = { flight = b2, walkSpeed = b2, jumpHeight = b2, refresh = b2, ghost = b2, godmode = b2, freecam = b2 }
local j6 = "slider"
local aJ = {}
for J, K in pairs(eh.home.profile.slider) do
	aJ[J] = K
end
aJ.outlined = false
aJ.foreground = ap("#ffffff")
aJ.background = ap("#ffffff")
aJ.backgroundTransparency = 0.8
aJ.indicatorTransparency = 0.3
aF[j6] = aJ
local j7 = "button"
local j8 = {}
for J, K in pairs(eh.home.profile.button) do
	j8[J] = K
end
j8.outlined = false
j8.foreground = ap("#ffffff")
j8.background = ap("#ffffff")
j8.backgroundTransparency = 0.8
aF[j7] = j8
aB[j4] = aF
local j9 = "server"
local ja = {}
for J, K in pairs(j1) do
	ja[J] = K
end
local jb = "rejoinButton"
local jc = {}
for J, K in pairs(eh.home.server.rejoinButton) do
	jc[J] = K
end
jc.outlined = false
jc.foreground = ap("#ffffff")
jc.background = ap("#ffffff")
jc.foregroundTransparency = 0.5
jc.backgroundTransparency = 0.8
jc.accent = b2
ja[jb] = jc
local jd = "switchButton"
local je = {}
for J, K in pairs(eh.home.server.switchButton) do
	je[J] = K
end
je.outlined = false
je.foreground = ap("#ffffff")
je.background = ap("#ffffff")
je.foregroundTransparency = 0.5
je.backgroundTransparency = 0.8
je.accent = b2
ja[jd] = je
aB[j9] = ja
local jf = "friendActivity"
local jg = {}
for J, K in pairs(j1) do
	jg[J] = K
end
local jh = "friendButton"
local ji = {}
for J, K in pairs(eh.home.friendActivity.friendButton) do
	ji[J] = K
end
ji.outlined = false
ji.foreground = ap("#ffffff")
ji.background = ap("#ffffff")
ji.dropshadow = ap("#ffffff")
ji.backgroundTransparency = 0.7
jg[jh] = ji
aB[jf] = jg
ax[j2] = aB
local jj = "apps"
local jk = {}
local jl = "players"
local jm = {}
for J, K in pairs(j1) do
	jm[J] = K
end
jm.highlight = { teleport = b2, hide = b2, kill = b2, spectate = b2 }
local jn = "avatar"
local jo = {}
for J, K in pairs(eh.apps.players.avatar) do
	jo[J] = K
end
jo.background = ap("#ffffff")
jo.transparency = 0.7
jo.gradient =
	{ color = ColorSequence.new(ap("#ffffff"), ap("#ffffff")), transparency = NumberSequence.new(0.5, 1), rotation = 45 }
jm[jn] = jo
local jp = "button"
local jq = {}
for J, K in pairs(eh.apps.players.button) do
	jq[J] = K
end
jq.outlined = false
jq.foreground = ap("#ffffff")
jq.background = ap("#ffffff")
jq.backgroundTransparency = 0.8
jm[jp] = jq
local jr = "playerButton"
local js = {}
for J, K in pairs(eh.apps.players.playerButton) do
	js[J] = K
end
js.outlined = false
js.foreground = ap("#ffffff")
js.background = ap("#ffffff")
js.dropshadow = ap("#ffffff")
js.accent = b2
js.backgroundTransparency = 0.8
js.dropshadowTransparency = 0.7
jm[jr] = js
jk[jl] = jm
ax[jj] = jk
local jt = "options"
local ju = {}
local jv = "config"
local jw = {}
for J, K in pairs(j1) do
	jw[J] = K
end
local jx = "configButton"
local jy = {}
for J, K in pairs(eh.options.config.configButton) do
	jy[J] = K
end
jy.outlined = false
jy.foreground = ap("#ffffff")
jy.background = ap("#ffffff")
jy.dropshadow = ap("#ffffff")
jy.accent = b2
jy.backgroundTransparency = 0.8
jy.dropshadowTransparency = 0.7
jw[jx] = jy
ju[jv] = jw
local jz = "shortcuts"
local jA = {}
for J, K in pairs(j1) do
	jA[J] = K
end
local jB = "shortcutButton"
local jC = {}
for J, K in pairs(eh.options.shortcuts.shortcutButton) do
	jC[J] = K
end
jC.outlined = false
jC.foreground = ap("#ffffff")
jC.background = ap("#ffffff")
jC.dropshadow = ap("#ffffff")
jC.accent = b2
jC.backgroundTransparency = 0.8
jC.dropshadowTransparency = 0.7
jA[jB] = jC
ju[jz] = jA
local jD = "themes"
local jE = {}
for J, K in pairs(j1) do
	jE[J] = K
end
local jF = "themeButton"
local jG = {}
for J, K in pairs(eh.options.themes.themeButton) do
	jG[J] = K
end
jG.outlined = false
jG.foreground = ap("#ffffff")
jG.background = ap("#ffffff")
jG.dropshadow = ap("#ffffff")
jG.accent = b2
jG.backgroundTransparency = 0.8
jG.dropshadowTransparency = 0.7
jE[jF] = jG
ju[jD] = jE
ax[jt] = ju
local iV = ax
return { frostedGlass = iV }
