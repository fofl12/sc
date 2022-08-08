local dictionary = {}

print('Dictionary -------------------------')
	if not _G.dictionary then
	for _, p in next, game:service'Players':GetPlayers() do
		local con
		con = p.Chatted:Connect(function(m)
			if #dictionary > 1000 then
				con:Disconnect()
				return
			end
			local words = m:split' '
			for _, word in next, words do
				if not (table.find(dictionary, word) or word:match("[\(\)/\%\\\[\]\!\?\.\,\'\"\;\:\<\>\{\}]")) then
					table.insert(dictionary, word)
				end
			end
			if #dictionary % 32 < 3 then
				print('dictionary', #dictionary / 10, '% complete')
			end
		end)
	end

	repeat task.wait(1) until #dictionary > 1000
	_G.dictionary = dictionary
else
	print'Found cache'
	dictionary = _G.dictionary
end

table.foreach(dictionary, print)

print('Sorting ----------------------------')
local http = game:service'HttpService'
local noun = {}
local verb = {}
local adjective = {}
local adverb = {}

local i = 0
for _, word in next, dictionary do
	task.wait(0.1)
	i += 1
	if i % 2 == 0 then
		print(i / 2, '% complete')
	end
	local raw = http:GetAsync('https://api.dictionaryapi.dev/api/v2/entries/en/' .. word)
	--print(raw)
	if not raw then
		continue
	end
	
	local definition = http:JSONDecode(raw)
	if pcall(function() definition[1].word:split('test') end) then
		for _, definition in next, definition do
			for _, meaning in next, definition.meanings do
				local part = meaning.partOfSpeech
				if part == 'noun' then
					table.insert(noun, word)
				elseif part == 'verb' then
					table.insert(verb, word)
				elseif part == 'adjective' then
					table.insert(adjective, word)
				elseif part == 'adverb' then
					table.insert(adverb, word)
				end
			end
		end
	else
		continue
	end
end

print('Assembling -------------------------')
for i = 1, 10 do
	local out = ''
	local state = 'adjective'
	while not (state == 'noun' and math.random() < 0.2) do
		task.wait()
		local random = math.random()
		if state == 'adjective' then
			out ..= adjective[math.random(1, #adjective)] .. ' '
			if random < 0.2 then
				state = 'adjective'
			else
				state = 'noun'
			end
		elseif state == 'noun' then
			out ..= noun[math.random(1, #noun)] .. ' '
			if random < 0 then
				state = 'adverb'
			else
				state = 'verb'
			end
		elseif state == 'verb' then
			out ..= verb[math.random(1, #verb)] .. ' '
			if random < 0 then
				state = 'adjective'
			else
				state = 'noun'
			end
		elseif state == 'adverb' then
			out ..= adverb[math.random(1, #adverb)] .. ' '
			if random < 0 then
				state = 'adverb'
			else
				state = 'verb'
			end
		end
	end
	print(out)
end
