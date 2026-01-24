local a = require(script.Parent.Parent.include.RuntimeLib)
local eh = a.import(script, script.Parent, "dark-theme").darkTheme
local ap = a.import(script, script.Parent.Parent, "utils", "color3").hex
local jJ = ap("#C6428E")
local jK = ap("#484fd7")
local jL = ap("#9a3fe5")
local j0 = ColorSequence.new({
	ColorSequenceKeypoint.new(0, jJ),
	ColorSequenceKeypoint.new(0.5, jL),
	ColorSequenceKeypoint.new(1, jK),
})
local b6 = ap("#181818")
local jM = ap("#242424")
local j1 = {
	acrylic = false,
	outlined = false,
	foreground = ap("#ffffff"),
	background = b6,
	backgroundGradient = nil,
	transparency = 0,
	dropshadow = b6,
	dropshadowTransparency = 0.3,
}
local ax = {}
for J, K in pairs(eh) do
	ax[J] = K
end
ax.name = "Sorbet"
ax.preview = {
	foreground = { color = ColorSequence.new(ap("#ffffff")) },
	background = { color = ColorSequence.new(b6) },
	accent = { color = j0 },
}
local ay = "navbar"
local az = {}
for J, K in pairs(eh.navbar) do
	az[J] = K
end
az.outlined = false
az.background = b6
az.dropshadow = b6
az.accentGradient = { color = j0 }
ax[ay] = az
local j2 = "clock"
local aB = {}
for J, K in pairs(eh.clock) do
	aB[J] = K
end
aB.outlined = false
aB.background = b6
aB.dropshadow = b6
ax[j2] = aB
local j3 = "home"
local aD = {}
local j4 = "title"
local aF = {}
for J, K in pairs(j1) do
	aF[J] = K
end
aF.background = ap("#ffffff")
aF.backgroundGradient = { color = j0, rotation = 30 }
aF.dropshadow = ap("#ffffff")
aF.dropshadowGradient = { color = j0, rotation = 30 }
aD[j4] = aF
local j5 = "profile"
local aH = {}
for J, K in pairs(j1) do
	aH[J] = K
end
local j6 = "avatar"
local aJ = {}
for J, K in pairs(eh.home.profile.avatar) do
	aJ[J] = K
end
aJ.background = jM
aJ.transparency = 0
aJ.gradient = { color = j0, rotation = 45 }
aH[j6] = aJ
aH.highlight = { flight = jJ, walkSpeed = jL, jumpHeight = jK, refresh = jJ, ghost = jK, godmode = jJ, freecam = jK }
local j7 = "slider"
local j8 = {}
for J, K in pairs(eh.home.profile.slider) do
	j8[J] = K
end
j8.outlined = false
j8.foreground = ap("#ffffff")
j8.background = jM
aH[j7] = j8
local j9 = "button"
local ja = {}
for J, K in pairs(eh.home.profile.button) do
	ja[J] = K
end
ja.outlined = false
ja.foreground = ap("#ffffff")
ja.background = jM
aH[j9] = ja
aD[j5] = aH
local jb = "server"
local jc = {}
for J, K in pairs(j1) do
	jc[J] = K
end
local jd = "rejoinButton"
local je = {}
for J, K in pairs(eh.home.server.rejoinButton) do
	je[J] = K
end
je.outlined = false
je.foreground = ap("#ffffff")
je.background = jM
je.foregroundTransparency = 0.5
je.accent = jJ
jc[jd] = je
local jf = "switchButton"
local jg = {}
for J, K in pairs(eh.home.server.switchButton) do
	jg[J] = K
end
jg.outlined = false
jg.foreground = ap("#ffffff")
jg.background = jM
jg.foregroundTransparency = 0.5
jg.accent = jK
jc[jf] = jg
aD[jb] = jc
local jh = "friendActivity"
local ji = {}
for J, K in pairs(j1) do
	ji[J] = K
end
local jj = "friendButton"
local jk = {}
for J, K in pairs(eh.home.friendActivity.friendButton) do
	jk[J] = K
end
jk.outlined = false
jk.foreground = ap("#ffffff")
jk.background = jM
ji[jj] = jk
aD[jh] = ji
ax[j3] = aD
local jl = "apps"
local jm = {}
local jn = "players"
local jo = {}
for J, K in pairs(j1) do
	jo[J] = K
end
jo.highlight = { teleport = jJ, hide = jK, kill = jJ, spectate = jK }
local jp = "avatar"
local jq = {}
for J, K in pairs(eh.apps.players.avatar) do
	jq[J] = K
end
jq.background = jM
jq.transparency = 0
jq.gradient = { color = j0, rotation = 45 }
jo[jp] = jq
local jr = "button"
local js = {}
for J, K in pairs(eh.apps.players.button) do
	js[J] = K
end
js.outlined = false
js.foreground = ap("#ffffff")
js.background = jM
jo[jr] = js
local jt = "playerButton"
local ju = {}
for J, K in pairs(eh.apps.players.playerButton) do
	ju[J] = K
end
ju.outlined = false
ju.foreground = ap("#ffffff")
ju.background = jM
ju.dropshadow = jM
ju.accent = jK
jo[jt] = ju
jm[jn] = jo
ax[jl] = jm
local jv = "options"
local jw = {}
local jx = "config"
local jy = {}
for J, K in pairs(j1) do
	jy[J] = K
end
local jz = "configButton"
local jA = {}
for J, K in pairs(eh.options.config.configButton) do
	jA[J] = K
end
jA.outlined = false
jA.foreground = ap("#ffffff")
jA.background = jM
jA.dropshadow = jM
jA.accent = jJ
jy[jz] = jA
jw[jx] = jy
local jB = "shortcuts"
local jC = {}
for J, K in pairs(j1) do
	jC[J] = K
end
local jD = "shortcutButton"
local jE = {}
for J, K in pairs(eh.options.shortcuts.shortcutButton) do
	jE[J] = K
end
jE.outlined = false
jE.foreground = ap("#ffffff")
jE.background = jM
jE.dropshadow = jM
jE.accent = jL
jC[jD] = jE
jw[jB] = jC
local jF = "themes"
local jG = {}
for J, K in pairs(j1) do
	jG[J] = K
end
local jH = "themeButton"
local jI = {}
for J, K in pairs(eh.options.themes.themeButton) do
	jI[J] = K
end
jI.outlined = false
jI.foreground = ap("#ffffff")
jI.background = jM
jI.dropshadow = jM
jI.accent = jK
jG[jH] = jI
jw[jF] = jG
ax[jv] = jw
local iZ = ax
return { sorbet = iZ }
