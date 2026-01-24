local a = require(script.Parent.Parent.include.RuntimeLib)
local eh = a.import(script, script.Parent, "dark-theme").darkTheme
local ap = a.import(script, script.Parent.Parent, "utils", "color3").hex
local ax = {}
for J, K in pairs(eh) do
	ax[J] = K
end
ax.name = "High contrast"
ax.preview = {
	foreground = { color = ColorSequence.new(ap("#ffffff")) },
	background = { color = ColorSequence.new(ap("#000000")) },
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
az.foreground = ap("#ffffff")
az.background = ap("#000000")
az.dropshadow = ap("#000000")
ax[ay] = az
local j2 = "clock"
local aB = {}
for J, K in pairs(eh.clock) do
	aB[J] = K
end
aB.foreground = ap("#ffffff")
aB.background = ap("#000000")
aB.dropshadow = ap("#000000")
ax[j2] = aB
local j3 = "home"
local aD = {}
local j4 = "title"
local aF = {}
for J, K in pairs(eh.home.title) do
	aF[J] = K
end
aF.foreground = ap("#ffffff")
aF.background = ap("#000000")
aF.dropshadow = ap("#000000")
aD[j4] = aF
local j5 = "profile"
local aH = {}
for J, K in pairs(eh.home.profile) do
	aH[J] = K
end
aH.foreground = ap("#ffffff")
aH.background = ap("#000000")
aH.dropshadow = ap("#000000")
local j6 = "avatar"
local aJ = {}
for J, K in pairs(eh.home.profile.avatar) do
	aJ[J] = K
end
aJ.background = ap("#ffffff")
aJ.transparency = 0.9
aJ.gradient = {
	color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, ap("#F6BD29")),
		ColorSequenceKeypoint.new(0.5, ap("#F64229")),
		ColorSequenceKeypoint.new(1, ap("#9029F6")),
	}),
}
aH[j6] = aJ
local j7 = "slider"
local j8 = {}
for J, K in pairs(eh.home.profile.slider) do
	j8[J] = K
end
j8.foreground = ap("#ffffff")
j8.background = ap("#000000")
aH[j7] = j8
local j9 = "button"
local ja = {}
for J, K in pairs(eh.home.profile.button) do
	ja[J] = K
end
ja.foreground = ap("#ffffff")
ja.background = ap("#000000")
aH[j9] = ja
aD[j5] = aH
local jb = "server"
local jc = {}
for J, K in pairs(eh.home.server) do
	jc[J] = K
end
jc.foreground = ap("#ffffff")
jc.background = ap("#000000")
jc.dropshadow = ap("#000000")
local jd = "rejoinButton"
local je = {}
for J, K in pairs(eh.home.server.rejoinButton) do
	je[J] = K
end
je.foreground = ap("#ffffff")
je.background = ap("#000000")
je.foregroundTransparency = 0.5
je.accent = ap("#ff3f6c")
jc[jd] = je
local jf = "switchButton"
local jg = {}
for J, K in pairs(eh.home.server.switchButton) do
	jg[J] = K
end
jg.foreground = ap("#ffffff")
jg.background = ap("#000000")
jg.foregroundTransparency = 0.5
jg.accent = ap("#ff3f6c")
jc[jf] = jg
aD[jb] = jc
local jh = "friendActivity"
local ji = {}
for J, K in pairs(eh.home.friendActivity) do
	ji[J] = K
end
ji.foreground = ap("#ffffff")
ji.background = ap("#000000")
ji.dropshadow = ap("#000000")
local jj = "friendButton"
local jk = {}
for J, K in pairs(eh.home.friendActivity.friendButton) do
	jk[J] = K
end
jk.foreground = ap("#ffffff")
jk.background = ap("#000000")
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
jo.foreground = ap("#ffffff")
jo.background = ap("#000000")
jo.dropshadow = ap("#000000")
local jp = "avatar"
local jq = {}
for J, K in pairs(eh.apps.players.avatar) do
	jq[J] = K
end
jq.background = ap("#ffffff")
jq.transparency = 0.9
jq.gradient = {
	color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, ap("#F6BD29")),
		ColorSequenceKeypoint.new(0.5, ap("#F64229")),
		ColorSequenceKeypoint.new(1, ap("#9029F6")),
	}),
}
jo[jp] = jq
local jr = "button"
local js = {}
for J, K in pairs(eh.apps.players.button) do
	js[J] = K
end
js.foreground = ap("#ffffff")
js.background = ap("#000000")
jo[jr] = js
local jt = "playerButton"
local ju = {}
for J, K in pairs(eh.apps.players.playerButton) do
	ju[J] = K
end
ju.foreground = ap("#ffffff")
ju.background = ap("#000000")
ju.accent = ap("#ff3f6c")
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
jy.foreground = ap("#ffffff")
jy.background = ap("#000000")
jy.dropshadow = ap("#000000")
local jz = "configButton"
local jA = {}
for J, K in pairs(eh.options.config.configButton) do
	jA[J] = K
end
jA.foreground = ap("#ffffff")
jA.background = ap("#000000")
jA.accent = ap("#ff3f6c")
jA.dropshadowTransparency = 0.7
jy[jz] = jA
jw[jx] = jy
local jB = "shortcuts"
local jC = {}
for J, K in pairs(eh.options.shortcuts) do
	jC[J] = K
end
jC.foreground = ap("#ffffff")
jC.background = ap("#000000")
jC.dropshadow = ap("#000000")
local jD = "shortcutButton"
local jE = {}
for J, K in pairs(eh.options.shortcuts.shortcutButton) do
	jE[J] = K
end
jE.foreground = ap("#ffffff")
jE.background = ap("#000000")
jE.accent = ap("#ff3f6c")
jE.dropshadowTransparency = 0.7
jC[jD] = jE
jw[jB] = jC
local jF = "themes"
local jG = {}
for J, K in pairs(eh.options.themes) do
	jG[J] = K
end
jG.foreground = ap("#ffffff")
jG.background = ap("#000000")
jG.dropshadow = ap("#000000")
local jH = "themeButton"
local jI = {}
for J, K in pairs(eh.options.themes.themeButton) do
	jI[J] = K
end
jI.foreground = ap("#ffffff")
jI.background = ap("#000000")
jI.accent = ap("#ff3f6c")
jI.dropshadowTransparency = 0.7
jG[jH] = jI
jw[jF] = jG
ax[jv] = jw
local iW = ax
return { highContrast = iW }
