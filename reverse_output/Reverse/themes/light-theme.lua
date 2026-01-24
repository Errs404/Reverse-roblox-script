local a = require(script.Parent.Parent.include.RuntimeLib)
local eh = a.import(script, script.Parent, "dark-theme").darkTheme
local ap = a.import(script, script.Parent.Parent, "utils", "color3").hex
local ax = {}
for J, K in pairs(eh) do
	ax[J] = K
end
ax.name = "Light theme"
ax.preview = {
	foreground = { color = ColorSequence.new(ap("#000000")) },
	background = { color = ColorSequence.new(ap("#ffffff")) },
	accent = {
		color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, ap("#F6BD29")),
			ColorSequenceKeypoint.new(0.5, ap("#F64229")),
			ColorSequenceKeypoint.new(1, ap("#9029F6")),
		}),
		rotation = 25,
	},
}
local ay = "navbar"
local az = {}
for J, K in pairs(eh.navbar) do
	az[J] = K
end
az.foreground = ap("#000000")
az.background = ap("#ffffff")
ax[ay] = az
local j2 = "clock"
local aB = {}
for J, K in pairs(eh.clock) do
	aB[J] = K
end
aB.foreground = ap("#000000")
aB.background = ap("#ffffff")
ax[j2] = aB
local j3 = "home"
local aD = {}
local j4 = "title"
local aF = {}
for J, K in pairs(eh.home.title) do
	aF[J] = K
end
aF.foreground = ap("#000000")
aF.background = ap("#ffffff")
aD[j4] = aF
local j5 = "profile"
local aH = {}
for J, K in pairs(eh.home.profile) do
	aH[J] = K
end
aH.foreground = ap("#000000")
aH.background = ap("#ffffff")
local j6 = "avatar"
local aJ = {}
for J, K in pairs(eh.home.profile.avatar) do
	aJ[J] = K
end
aJ.background = ap("#000000")
aJ.transparency = 0.9
aJ.gradient = { color = ColorSequence.new(ap("#3ce09b")) }
aH[j6] = aJ
local j7 = "slider"
local j8 = {}
for J, K in pairs(eh.home.profile.slider) do
	j8[J] = K
end
j8.foreground = ap("#000000")
j8.background = ap("#ffffff")
aH[j7] = j8
local j9 = "button"
local ja = {}
for J, K in pairs(eh.home.profile.button) do
	ja[J] = K
end
ja.foreground = ap("#000000")
ja.background = ap("#ffffff")
aH[j9] = ja
aD[j5] = aH
local jb = "server"
local jc = {}
for J, K in pairs(eh.home.server) do
	jc[J] = K
end
jc.foreground = ap("#000000")
jc.background = ap("#ff3f6c")
jc.dropshadow = ap("#ff3f6c")
local jd = "rejoinButton"
local je = {}
for J, K in pairs(eh.home.server.rejoinButton) do
	je[J] = K
end
je.foreground = ap("#000000")
je.background = ap("#ff3f6c")
je.accent = ap("#ffffff")
jc[jd] = je
local jf = "switchButton"
local jg = {}
for J, K in pairs(eh.home.server.switchButton) do
	jg[J] = K
end
jg.foreground = ap("#000000")
jg.background = ap("#ff3f6c")
jg.accent = ap("#ffffff")
jc[jf] = jg
aD[jb] = jc
local jh = "friendActivity"
local ji = {}
for J, K in pairs(eh.home.friendActivity) do
	ji[J] = K
end
ji.foreground = ap("#000000")
ji.background = ap("#ffffff")
local jj = "friendButton"
local jk = {}
for J, K in pairs(eh.home.friendActivity.friendButton) do
	jk[J] = K
end
jk.foreground = ap("#ffffff")
jk.background = ap("#ffffff")
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
jo.foreground = ap("#000000")
jo.background = ap("#ffffff")
local jp = "avatar"
local jq = {}
for J, K in pairs(eh.apps.players.avatar) do
	jq[J] = K
end
jq.background = ap("#000000")
jq.transparency = 0.9
jq.gradient = { color = ColorSequence.new(ap("#3ce09b")) }
jo[jp] = jq
local jr = "button"
local js = {}
for J, K in pairs(eh.apps.players.button) do
	js[J] = K
end
js.foreground = ap("#000000")
js.background = ap("#ffffff")
jo[jr] = js
local jt = "playerButton"
local ju = {}
for J, K in pairs(eh.apps.players.playerButton) do
	ju[J] = K
end
ju.foreground = ap("#000000")
ju.background = ap("#ffffff")
ju.backgroundHovered = ap("#eeeeee")
ju.accent = ap("#3ce09b")
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
jy.foreground = ap("#000000")
jy.background = ap("#ffffff")
local jz = "configButton"
local jA = {}
for J, K in pairs(eh.options.config.configButton) do
	jA[J] = K
end
jA.foreground = ap("#000000")
jA.background = ap("#ffffff")
jA.backgroundHovered = ap("#eeeeee")
jA.accent = ap("#3ce09b")
jA.dropshadowTransparency = 0.7
jy[jz] = jA
jw[jx] = jy
local jB = "shortcuts"
local jC = {}
for J, K in pairs(eh.options.shortcuts) do
	jC[J] = K
end
jC.foreground = ap("#000000")
jC.background = ap("#ffffff")
local jD = "shortcutButton"
local jE = {}
for J, K in pairs(eh.options.shortcuts.shortcutButton) do
	jE[J] = K
end
jE.foreground = ap("#000000")
jE.background = ap("#ffffff")
jE.backgroundHovered = ap("#eeeeee")
jE.accent = ap("#3ce09b")
jE.dropshadowTransparency = 0.7
jC[jD] = jE
jw[jB] = jC
local jF = "themes"
local jG = {}
for J, K in pairs(eh.options.themes) do
	jG[J] = K
end
jG.foreground = ap("#000000")
jG.background = ap("#ffffff")
local jH = "themeButton"
local jI = {}
for J, K in pairs(eh.options.themes.themeButton) do
	jI[J] = K
end
jI.foreground = ap("#000000")
jI.background = ap("#ffffff")
jI.backgroundHovered = ap("#eeeeee")
jI.accent = ap("#3ce09b")
jI.dropshadowTransparency = 0.7
jG[jH] = jI
jw[jF] = jG
ax[jv] = jw
local iX = ax
return { lightTheme = iX }
