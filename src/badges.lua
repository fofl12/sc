-- Give everyone in the server badges in their nametag    //
local http = game:GetService("HttpService")
local badges = { {
	badge = "🍰",
	check = function(player)
		return player.AccountAge % 365 == 0
	end,
}, {
	badge = "🧱",
	check = function(player)
		return player.AccountAge >= 365
	end,
}, {
	badge = "✔",
	check = function(player)
		return player:GetRankInGroup(3256759) > 1
	end,
} }
local function addBadges(character, player)
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then
		return nil
	end
	local _arg0 = function(badge)
		humanoid.DisplayName = (if badge.check(player) then badge.badge else "") .. humanoid.DisplayName
	end
	-- ▼ ReadonlyArray.forEach ▼
	for _k, _v in ipairs(badges) do
		_arg0(_v, _k - 1, badges)
	end
	-- ▲ ReadonlyArray.forEach ▲
end
local function onCharacter(player)
	player.CharacterAdded:Connect(function(char)
		addBadges(char, player)
	end)
	local _ = if player.Character then addBadges(player.Character, player) else warn("no character")
end
local players = game:GetService("Players")
local _exp = players:GetPlayers()
-- ▼ ReadonlyArray.forEach ▼
for _k, _v in ipairs(_exp) do
	onCharacter(_v, _k - 1, _exp)
end
-- ▲ ReadonlyArray.forEach ▲
players.PlayerAdded:Connect(onCharacter)
return nil
