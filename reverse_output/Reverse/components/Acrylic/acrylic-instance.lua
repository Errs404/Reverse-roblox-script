local a = require(script.Parent.Parent.Parent.include.RuntimeLib)
local au = a.import(script, a.getModule(script, "@rbxts", "make"))
local av = {
	Color = Color3.new(0, 0, 0),
	Material = Enum.Material.Glass,
	Size = Vector3.new(1, 1, 0),
	Anchored = true,
	CanCollide = false,
	Locked = true,
	CastShadow = false,
	Transparency = 0.999,
}
local aw = {
	Color = Color3.new(0, 0, 0),
	Material = Enum.Material.Glass,
	Size = Vector3.new(0, 1, 1),
	Anchored = true,
	CanCollide = false,
	Locked = true,
	CastShadow = false,
	Transparency = 0.999,
}
local ax = {}
local ay = "Children"
local az = {
	Name = "Horizontal",
	Children = { au("SpecialMesh", { MeshType = Enum.MeshType.Brick, Offset = Vector3.new(0, 0, -0.000001) }) },
}
for J, K in pairs(av) do
	az[J] = K
end
local aA = au("Part", az)
local aB = {
	Name = "Vertical",
	Children = { au("SpecialMesh", { MeshType = Enum.MeshType.Brick, Offset = Vector3.new(0, 0, 0.000001) }) },
}
for J, K in pairs(av) do
	aB[J] = K
end
local aC = au("Part", aB)
local aD = { Name = "TopRight", Children = { au("SpecialMesh", { MeshType = Enum.MeshType.Cylinder }) } }
for J, K in pairs(aw) do
	aD[J] = K
end
local aE = au("Part", aD)
local aF = { Name = "TopLeft", Children = { au("SpecialMesh", { MeshType = Enum.MeshType.Cylinder }) } }
for J, K in pairs(aw) do
	aF[J] = K
end
local aG = au("Part", aF)
local aH = { Name = "BottomRight", Children = { au("SpecialMesh", { MeshType = Enum.MeshType.Cylinder }) } }
for J, K in pairs(aw) do
	aH[J] = K
end
local aI = au("Part", aH)
local aJ = { Name = "BottomLeft", Children = { au("SpecialMesh", { MeshType = Enum.MeshType.Cylinder }) } }
for J, K in pairs(aw) do
	aJ[J] = K
end
ax[ay] = { aA, aC, aE, aG, aI, au("Part", aJ) }
local o = au("Model", ax)
return { acrylicInstance = o }
