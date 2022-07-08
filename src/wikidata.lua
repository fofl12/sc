local players = game:GetService('Players')
local hptt = game:GetService('HttpService')

local function waitForMessage()
	local oint = Instance.new("BindableEvent")
	local garbich = {}
	for _, player in next, players:GetPlayers() do
		table.insert(garbich, player.Chatted:Connect(function(msg)
			oint:Fire(msg)
		end))
	end
	local msg = oint.Event:Wait()
	for _, garbich in next, garbich do
		garbich:Disconnect()
	end
	table.clear(garbich)
	return msg
end

while true do
	local msg = waitForMessage()
	local words = msg:split(" ")
	local word = words[math.random(#words)]
	local eid = hptt:JSONDecode(hptt:GetAsync("https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageprops&ppprop=wikibase_item&redirects=1&titles=" .. word))
	for _, ajsdsajd in next, eid.query.pages do
		eid = ajsdsajd.pageprops.wikibase_item
	end
	local props = hptt:JSONDecode()
	print("The", word:upper(), "of", word:upper(), "(".. eid ..") is:", word)
	task.wait(math.random(10, 40))
end


-- [==[
print(h:PostAsync(
	"https://query.wikidata.org/sparql", [===[
prefix wdt: <http://www.wikidata.org/prop/direct/>
prefix wd: <http://www.wikidata.org/entity/>
SELECT distinct ?prop WHERE {
  ?item ?prop wd:Q302 .
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
limit 100
]===]))
