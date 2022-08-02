local is = game:GetService('InsertService')
local decals = unpack(is:GetFreeDecals('meme', 0))
local images = {}
for _, res in next, decals.Results do
	local decal = is:LoadAsset(res.AssetId)
	table.insert(images, decal.Texture)
end