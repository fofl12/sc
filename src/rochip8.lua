-- Chip-8 emulator for ro blocks                          --
-- https://github.com/mattmikolay/chip-8/wiki/CHIP-8-Technical-Reference

local http = game:GetService("HttpService")
local ROM_URL = "https://github.com/badlogic/chip8/blob/master/roms/pong.rom?raw=true"
local ROM = http:GetAsync(ROM_URL)

-- No more bit 32 ,only byte()
print(#ROM)
for instruction = 0x0, 0x49E, 2 do
	local b1, b2 = ROM:sub(instruction+1, instruction+1):byte(),ROM:sub(instruction+2, instruction+2):byte()
	print(b1, b2, instruction/2)
	local code = b2 + (b1 * 2) -- im dumb
	local cat = bit32.extract(code, 0, 4)
	if code == 0x0 then
		-- either clear screen or return from subroutine, shut up superchip!
		if (bit32.extract(code, 12, 4) == 0x0) then
			print("Clear screen")
		else
			print("Return from subroutine")
		end
	elseif code == 0x1 then
		-- jump to address NNN
		local nnn = bit32.extract(code, 4, 12)
		print("Jump to address: " .. nnn)
	elseif code == 0x2 then
		-- jump to subroutine at address NNN
		local nnn = bit32.extract(code, 4, 12)
		print("Jump to subroutine at addres: " .. nnn)
	elseif code == 0x3 then
		-- skip next instruction if vX == NN
		local vx = bit32.extract(code, 4, 4)
		local nn = bit32.extract(code, 8, 8)
		print("Skip next instruction if v" .. vx .. " == " .. nn)
	elseif code == 0x4 then
		-- skip next instruction if vX != NN
		local vx = bit32.extract(code, 4, 4)
		local nn = bit32.extract(code, 8, 8)
		print("Skip next instruction if v" .. vx .. " != " .. nn)
	elseif code == 0x5 then
		-- skip next instruction if vX == vy
		local vx = bit32.extract(code, 4, 4)
		local vy = bit32.extract(code, 8, 4)
		print("Skip next instruction if v" .. vx .. " == v" .. vy)
	elseif code == 0x6 then
		-- set NN to vX
		local vx = bit32.extract(code, 4, 4)
		local nn = bit32.extract(code, 8, 8)
		print("Set v" .. vx .. " to " .. nn)
	elseif code == 0x7 then
		-- add NN to vX
		local vx = bit32.extract(code, 4, 4)
		local nn = bit32.extract(code, 8, 8)
		print("Add " .. nn .. " to v" .. vx)
	elseif code == 0x8 then
		local type = bit32.extract(code, 12, 4)
		if code == 0 then
			-- Set vX to vY
			local vx = bit32.extract(code, 4, 4)
			local vy = bit32.extract(code, 8, 4)
			print("Set v" .. vx .. " to v" .. vy)
		elseif code == 1 then
			-- Store the OR result of vX and vY to vX
			local vx = bit32.extract(code, 4, 4)
			local vy = bit32.extract(code, 8, 4)
			print("Set v" .. vx .. " to the OR of v" .. vx .. " and v" .. vy)
		elseif code == 2 then
			-- Store the AND result of vX and vY to vX
			local vx = bit32.extract(code, 4, 4)
			local vy = bit32.extract(code, 8, 4)
			print("Set v" .. vx .. " to the AND of v" .. vx .. " and v" .. vy)
		elseif code == 3 then
			-- Store the XOR result of vX and vY to vX
			local vx = bit32.extract(code, 4, 4) --
			local vy = bit32.extract(code, 8, 4)
			print("Set v" .. vx .. " to the XOR of v" .. vx .. " and v" .. vy)
		elseif code == 4 then -- FYI: vF (v15) is the carry register
			-- Set vX to the sum of vX and vY, vF is carry
			local vx = bit32.extract(code, 4, 4)
			local vy = bit32.extract(code, 8, 4)
			print("Set v" .. vx .. " to the sum of v" .. vx .. " and v" .. vy .. ", carry vF")
		elseif code == 5 then
			-- Set vX to vX - vY, vF is carry
			local vx = bit32.extract(code, 4, 4)
			local vy = bit32.extract(code, 8, 4)
			print("Set v" .. vx .. " to v" .. vx .. " - v" .. vy .. ", carry vF")
		elseif code == 6 then
			-- Shift vX right, bit 0 goes to vF
			local vx = bit32.extract(code, 4, 4)
			print("Shift v" .. vx .. " right, bit 0 vF")
		elseif code == 7 then
			-- Set vX to vY - vX, vF is carry
			local vx = bit32.extract(code, 4, 4)
			local vy = bit32.extract(code, 8, 4)
			print("Set v" .. vx .. " to v" .. vy .. " - v" .. vx .. ", carry vF")
		elseif code == 0xe then
			-- Shift vX left, bit 7 goes to vF
			local vx = bit32.extract(code, 4, 4)
			print("Shift v" .. vx .. " left, bit 0 vF")
		end
	elseif code == 0x9 then
		-- skip next instruction if vX != vY
		local vx = bit32.extract(code, 4, 4)
		local vy = bit32.extract(code, 8, 4)
		print("Skip next instruction if v" .. vx .. " != v" .. vy)
	elseif code == 0xa then
		-- set I to NNN
		local nnn = bit32.extract(code, 4, 12)
		print("Set I to " .. nnn)
	elseif code == 0xb then
		-- jump to address NNN .. v0
		local nnn = bit32.extract(code, 4, 12)
		print("Jump to " .. nnn .. " .. v0")
	elseif code == 0xc then
		-- set vX to the AND of a random number and NN
		local vx = bit32.extract(code, 4, 4)
		local nn = bit32.extract(code, 8, 8)
		local rand = math.random(0, 0xff)
		print("Set v" .. vx .. " to the AND of " .. nn .. " and " .. rand)
	elseif code == 0xd then
		-- draw sprite I to vX, vY with height N. all drawing is XOR drawing

	elseif code == 0xe then
		-- if key n is pressed/not pressed then skip next instruction
		local key = bit32.extract(code, 4, 4)
		if bit32.extract(code, 8, 4) == 9 then
			-- pressed
			print("Check if key " .. key .. " is pressed")
		else
			-- not pressed
			print("Check if key " .. key .. " is not pressed")
		end
	elseif code == 0xf then
		-- ;pointlaugh
	end
end
