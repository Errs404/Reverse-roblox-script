local a = require(script.Parent.Parent.include.RuntimeLib)
local eh = a.import(script, script.Parent, "dark-theme").darkTheme
local ap = a.import(script, script.Parent.Parent, "utils", "color3").hex
local b2 = ap("#9029F6")
local j0 = ColorSequence.new(ap("#9029F6"))
local ax = {}
for J, K in pairs(eh) do
	ax[J] = K
end
ax.name = "Obsidian"
ax.preview = {
	foreground = { color = ColorSequence.new(ap("#ffffff")) },
	background = { color = ColorSequence.new(ap("#000000")) },
	accent = { color = j0 },
}
local ay = "navbar"
local az = {}
for J, K in pairs(eh.navbar) do
	az[J] = K
end
az.acrylic = true
az.outlined = false
az.foreground = ap("#ffffff")
az.background = ap("#000000")
az.dropshadow = ap("#000000")
az.transparency = 0.7
az.accentGradient = { color = j0, transparency = NumberSequence.new(0.5) }
ax[ay] = az
local j2 = "clock"
local aB = {}
for J, K in pairs(eh.clock) do
	aB[J] = K
end
aB.acrylic = true
aB.outlined = false
aB.foreground = ap("#ffffff")
aB.background = ap("#000000")
aB.dropshadow = ap("#000000")
aB.transparency = 0.7
ax[j2] = aB
local j3 = "home"
local aD = {}
local j4 = "title"
local aF = {}
for J, K in pairs(eh.home.title) do
	aF[J] = K
end
aF.acrylic = true
aF.outlined = false
aF.foreground = ap("#ffffff")
aF.background = ap("#000000")
aF.dropshadow = ap("#000000")
aF.transparency = 0.7
aF.dropshadowTransparency = 0.65
aD[j4] = aF
local j5 = "profile"
local aH = {}
for J, K in pairs(eh.home.profile) do
	aH[J] = K
end
aH.acrylic = true
aH.outlined = false
aH.foreground = ap("#ffffff")
aH.background = ap("#000000")
aH.dropshadow = ap("#000000")
aH.transparency = 0.7
aH.dropshadowTransparency = 0.65
local j6 = "avatar"
local aJ = {}
for J, K in pairs(eh.home.profile.avatar) do
	aJ[J] = K
end
aJ.background = ap("#000000")
aJ.transparency = 0.7
aJ.gradient = { color = j0 }
aH[j6] = aJ
aH.highlight = { flight = b2, walkSpeed = b2, jumpHeight = b2, refresh = b2, ghost = b2, godmode = b2, freecam = b2 }
local j7 = "slider"
local j8 = {}
for J, K in pairs(eh.home.profile.slider) do
	j8[J] = K
end
j8.outlined = false
j8.foreground = ap("#ffffff")
j8.background = ap("#000000")
j8.backgroundTransparency = 0.5
j8.indicatorTransparency = 0.5
aH[j7] = j8
local j9 = "button"
local ja = {}
for J, K in pairs(eh.home.profile.button) do
	ja[J] = K
end
ja.outlined = false
ja.foreground = ap("#ffffff")
ja.background = ap("#000000")
ja.backgroundTransparency = 0.5
aH[j9] = ja
aD[j5] = aH
local jb = "server"
local jc = {}
for J, K in pairs(eh.home.server) do
	jc[J] = K
end
jc.acrylic = true
jc.outlined = false
jc.foreground = ap("#ffffff")
jc.background = ap("#000000")
jc.dropshadow = ap("#000000")
jc.transparency = 0.7
jc.dropshadowTransparency = 0.65
local jd = "rejoinButton"
local je = {}
for J, K in pairs(eh.home.server.rejoinButton) do
	je[J] = K
end
je.outlined = false
je.foreground = ap("#ffffff")
je.background = ap("#000000")
je.backgroundTransparency = 0.5
je.foregroundTransparency = 0.5
je.accent = b2
jc[jd] = je
local jf = "switchButton"
local jg = {}
for J, K in pairs(eh.home.server.switchButton) do
	jg[J] = K
end
jg.outlined = false
jg.foreground = ap("#ffffff")
jg.background = ap("#000000")
jg.backgroundTransparency = 0.5
jg.foregroundTransparency = 0.5
jg.accent = b2
jc[jf] = jg
aD[jb] = jc
local jh = "friendActivity"
local ji = {}
for J, K in pairs(eh.home.friendActivity) do
	ji[J] = K
end
ji.acrylic = true
ji.outlined = false
ji.foreground = ap("#ffffff")
ji.background = ap("#000000")
ji.dropshadow = ap("#000000")
ji.transparency = 0.7
ji.dropshadowTransparency = 0.65
local jj = "friendButton"
local jk = {}
for J, K in pairs(eh.home.friendActivity.friendButton) do
	jk[J] = K
end
jk.outlined = false
jk.foreground = ap("#ffffff")
jk.background = ap("#000000")
jk.dropshadow = ap("#000000")
jk.backgroundTransparency = 0.7
ji[jj] = jk
aD[jh] = ji
ax[j3] = aD
local jl = "apps"
local jm = {}
local jn = "players"
local jo = {}
for J, K in pairs(eh.apps.players) do
	jo[J] = K
end
jo.acrylic = true
jo.outlined = false
jo.foreground = ap("#ffffff")
jo.background = ap("#000000")
jo.dropshadow = ap("#000000")
jo.transparency = 0.7
jo.dropshadowTransparency = 0.65
jo.highlight = { teleport = b2, hide = b2, kill = b2, spectate = b2 }
local jp = "avatar"
local jq = {}
for J, K in pairs(eh.apps.players.avatar) do
	jq[J] = K
end
jq.background = ap("#000000")
jq.transparency = 0.7
jq.gradient = { color = j0 }
jo[jp] = jq
local jr = "button"
local js = {}
for J, K in pairs(eh.apps.players.button) do
	js[J] = K
end
js.outlined = false
js.foreground = ap("#ffffff")
js.background = ap("#000000")
js.backgroundTransparency = 0.5
jo[jr] = js
local jt = "playerButton"
local ju = {}
for J, K in pairs(eh.apps.players.playerButton) do
	ju[J] = K
end
ju.outlined = false
ju.foreground = ap("#ffffff")
ju.background = ap("#000000")
ju.accent = b2
ju.backgroundTransparency = 0.5
ju.dropshadowTransparency = 0.7
jo[jt] = ju
jm[jn] = jo
ax[jl] = jm
local jv = "options"
local jw = {}
local jx = "config"
local jy = {}
for J, K in pairs(eh.options.config) do
	jy[J] = K
end
jy.acrylic = true
jy.outlined = false
jy.foreground = ap("#ffffff")
jy.background = ap("#000000")
jy.dropshadow = ap("#000000")
jy.transparency = 0.7
jy.dropshadowTransparency = 0.65
local jz = "configButton"
local jA = {}
for J, K in pairs(eh.options.config.configButton) do
	jA[J] = K
end
jA.outlined = false
jA.foreground = ap("#ffffff")
jA.background = ap("#000000")
jA.accent = b2
jA.backgroundTransparency = 0.5
jA.dropshadowTransparency = 0.7
jy[jz] = jA
jw[jx] = jy
local jB = "shortcuts"
local jC = {}
for J, K in pairs(eh.options.shortcuts) do
	jC[J] = K
end
jC.acrylic = true
jC.outlined = false
jC.foreground = ap("#ffffff")
jC.background = ap("#000000")
jC.dropshadow = ap("#000000")
jC.transparency = 0.7
jC.dropshadowTransparency = 0.65
local jD = "shortcutButton"
local jE = {}
for J, K in pairs(eh.options.shortcuts.shortcutButton) do
	jE[J] = K
end
jE.outlined = false
jE.foreground = ap("#ffffff")
jE.background = ap("#000000")
jE.accent = b2
jE.backgroundTransparency = 0.5
jE.dropshadowTransparency = 0.7
jC[jD] = jE
jw[jB] = jC
local jF = "themes"
local jG = {}
for J, K in pairs(eh.options.themes) do
	jG[J] = K
end
jG.acrylic = true
jG.outlined = false
jG.foreground = ap("#ffffff")
jG.background = ap("#000000")
jG.dropshadow = ap("#000000")
jG.transparency = 0.7
jG.dropshadowTransparency = 0.65
local jH = "themeButton"
local jI = {}
for J, K in pairs(eh.options.themes.themeButton) do
	jI[J] = K
end
jI.outlined = false
jI.foreground = ap("#ffffff")
jI.background = ap("#000000")
jI.accent = b2
jI.backgroundTransparency = 0.5
jI.dropshadowTransparency = 0.7
jG[jH] = jI
jw[jF] = jG
ax[jv] = jw
local iY = ax
return { obsidian = iY }
