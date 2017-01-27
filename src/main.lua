Decimals = 4

--------------------------------------------

Band1 = 3 -- {
Band2 = 4 -- 	these are all
Band3 = 1 --	from Colors table
Band4 = 1 -- }
Band5 = 0 -- 0=gold, 1=silver
Resistance = {}

Debounce = 0

Colors = {
	{0, 1, {0, 0, 0}}, -- black
	{1, 10, {129, 69, 19}}, -- brown
	{2, 100, {255, 0, 0}}, -- red
	{3, 1000, {255, 127, 0}}, -- orange
	{4, 10000, {255, 255, 0}}, -- yellow
	{5, 100000, {0, 255, 0}}, -- green
	{6, 1000000, {0, 0, 127}}, -- blue
	{7, 10000000, {186, 85, 211}}, -- violet
	{8, 100000000, {127, 127, 127}}, -- grey
	{9, 1000000000, {255, 255, 255}}, -- white
}

Standard = {
	{0.1, 0.05}, -- gold,   5%
	{0.01, 0.1} -- silver, 10%
}

function num_to_col(num)
	for color in pairs(Colors) do
		if color[1] == num then
			return color
		end
	end
	return nil
end

function col_to_num(col)
	col = tostring(col):lower()
	if col == "black" then return Colors[1]
	elseif col == "brown" then return Colors[2]
	elseif col == "red" then return Colors[3]
	elseif col == "orange" then return Colors[4]
	elseif col == "yellow" then return Colors[5]
	elseif col == "green" then return Colors[6]
	elseif col == "blue" then return Colors[7]
	elseif col == "violet" or col == "purple" then return Colors[8]
	elseif col == "grey" then return Colors[9]
	elseif col == "white" then return Colors[10]
	else
		error("Unknown color: " .. col)
		return -1
	end
end

function col_to_std(col)
	col = tostring(col):lower()
	if col == "gold" then return Standard[1]
	elseif col == "silver" then return Standard[2]
	else
		error("Unknown standard: " .. col)
		return -1
	end
end

function round(num, dec)
	num = num * math.pow(10, dec)
	num = math.floor(num)
	return num / math.pow(10, dec)
end

function get_variance(col1, col2, col3, col4, col5)
	if col5 == nil then
		-- 4 band
		col1 = type(col1) == "string" and col_to_num(col1)[1] or col1 -- digit
		col2 = type(col2) == "string" and col_to_num(col2)[1] or col2 -- digit
		col3 = type(col3) == "string" and col_to_num(col3)[2] or col3 -- mult
		col4 = type(col4) == "string" and col_to_std(col4)[2] or col4 -- tol
		
		local base = (col1 * 10) + col2
		local resistance = base * col3
		return round(resistance / (1 + col4), 2), round(resistance * (1 + col4), 2)
	else
		-- 5 band
		col1 = type(col1) == "string" and col_to_num(col1)[1] or col1 -- digit
		col2 = type(col2) == "string" and col_to_num(col2)[1] or col2 -- digit
		col3 = type(col3) == "string" and col_to_num(col3)[1] or col3 -- digit
		col4 = type(col4) == "string" and col_to_num(col4)[2] or col4 -- mult
		col5 = type(col5) == "string" and col_to_std(col5)[2] or col5 -- tol
		
		local base = (col1 * 100) + (col2 * 10) + col3
		local resistance = base * col3
		return round(resistance / (1 + col5), 2), round(resistance * (1 + col5), 2)
	end
	return -1
end

function love.load()
	BigFont = love.graphics.setNewFont("UbuntuMono-R.ttf", 36)
	SmallFont = love.graphics.newFont("UbuntuMono-R.ttf", 24)
	love.window.setTitle("Resistor Calculator")
end

function love.draw()
	-- Clear window & get scale for squares
	local scale = love.graphics.getWidth() / #Colors
	local half = love.graphics.getWidth() / 2
	love.graphics.clear(84, 176, 225)
	love.graphics.setFont(BigFont)
	
	-- Draw color codes for band 1
	for i = 1, #Colors do
		local rgb = Colors[i][3]
		love.graphics.setColor(rgb[1], rgb[2], rgb[3])
		love.graphics.rectangle("fill", (i - 1) * scale, 0, scale, 80)
	end
	
	-- Draw selection area for band 1
	love.graphics.setColor(0, 255, 255)
	for i = 1, 4 do
		love.graphics.rectangle("line", (Band1 * scale) - i, 0, (scale - 1) + (i * 2) - 1, 79 + i)
	end
	
	-- Drawing the phrase "Band 1:"
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Band 1: ", 30, 40 - (BigFont:getHeight() / 2))
	
	-- Same shit for Band 2
	for i = 1, #Colors do
		local rgb = Colors[i][3]
		love.graphics.setColor(rgb[1], rgb[2], rgb[3])
		love.graphics.rectangle("fill", (i - 1) * scale, 100, scale, 80)
	end
	
	love.graphics.setColor(0, 255, 255)
	for i = 1, 4 do
		love.graphics.rectangle("line", (Band2 * scale) - i, 100 - i, scale + (i * 2) - 1, 79 + (i * 2))
	end
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Band 2: ", 30, 140 - (BigFont:getHeight() / 2))
	
	-- Same shit for Band 3
	for i = 1, #Colors do
		local rgb = Colors[i][3]
		love.graphics.setColor(rgb[1], rgb[2], rgb[3])
		love.graphics.rectangle("fill", (i - 1) * scale, 200, scale, 80)
	end
	
	love.graphics.setColor(0, 255, 255)
	for i = 1, 4 do
		love.graphics.rectangle("line", (Band3 * scale) - i, 200 - i, scale + (i * 2) - 1, 79 + (i * 2))
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Band 3: ", 30, 240 - (BigFont:getHeight() / 2))
	
	-- Band 4 - The one you can disable
	for i = 1, #Colors do
		local rgb = Colors[i][3]
		love.graphics.setColor(rgb[1], rgb[2], rgb[3])
		love.graphics.rectangle("fill", (i - 1) * scale, 300, scale, 80)
	end
	
	if (Band4 >= 0) then
		for i = 1, 4 do
			love.graphics.setColor(0, 255, 255)
			love.graphics.rectangle("line", (Band4 * scale) - i, 300 - i, scale + (i * 2) - 1, 79 + (i * 2))
		end
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.print(Band4 >= 0 and "Band 4: " or "", 30, 340 - (BigFont:getHeight() / 2))
	
	-- Enable/disable band 4 (for 5 banded resistors)
	if Band4 < 0 then
		love.graphics.setColor(0, 0, 0, 196)
		love.graphics.rectangle("fill", 0, 300, 800, 80)
	end

	-- Checkbox
	love.graphics.setColor(64, 64, 64)
	love.graphics.rectangle("fill", 6, 330, 22, 22, 2, 2)
		
	love.graphics.setColor(234, 234, 234)
	love.graphics.rectangle("fill", 8, 332, 18, 18, 2, 2)
	
	-- Red X
	if Band4 < 0 then
		love.graphics.setColor(255, 0, 0)
		love.graphics.line(10, 334, 24, 348)
		love.graphics.line(10, 348, 24, 334)
	end
	
	-- Tolerance bands
	love.graphics.setColor(255, 215, 0)
	love.graphics.rectangle("fill", 0, 400, half, 80)
	love.graphics.setColor(196, 196, 196)
	love.graphics.rectangle("fill", half, 400, half, 80)
	
	love.graphics.setColor(0, 255, 255)
	for i = 1, 4 do
		love.graphics.rectangle("line", (Band5 * half) - i, 400 - i, half + (i * 2), 79 + (i * 2))
	end
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(Band4 >= 0 and "Band 5: " or "Band 4: ", 30, 440 - (BigFont:getHeight() / 2))
	
	-- Display resistance
	local text = (Resistance[1] or "0") .. "Ω"
	if Resistance[1] then
		if Resistance[1] / 1000000 >= 1 then
			text = round(Resistance[1] / 1000000, Decimals) .. "M Ω"
		elseif Resistance[1] / 1000 >= 1 then
			text = round(Resistance[1] / 1000, Decimals) .. "K Ω"
		end
	end
	love.graphics.print(text, half - (BigFont:getWidth(text) / 2), 500)
	
	-- Display tolerance
	local lower = (Resistance[2] or "0") .. "Ω"
	local upper = (Resistance[3] or "0") .. "Ω"
	if Resistance[2] then
		if Resistance[2] / 1000000 >= 1 then
			lower = round(Resistance[2] / 1000000, Decimals) .. "M Ω"
		elseif Resistance[2] / 1000 >= 1 then
			lower = round(Resistance[2] / 1000, Decimals) .. "K Ω"
		end
	end
	if Resistance[3] then
		if Resistance[3] / 1000000 >= 1 then
			upper = round(Resistance[3] / 1000000, Decimals) .. "M Ω"
		elseif Resistance[3] / 1000 >= 1 then
			upper = round(Resistance[3] / 1000, Decimals) .. "K Ω"
		end
	end
	
	local tolerance = "(" .. lower .. " - " .. upper .. ")"
	love.graphics.setColor(196, 196, 196)
	love.graphics.setFont(SmallFont)
	love.graphics.print(tolerance, half - (SmallFont:getWidth(tolerance) / 2), 510 + SmallFont:getHeight())
end

function love.update(dt)
	local scale = love.graphics.getWidth() / #Colors -- size of each color box
	if love.mouse.isDown(1) then
		local x = love.mouse.getX()
		local y = love.mouse.getY()
		
		-- Check which band user is changing
		if y <= 80 then -- 1
			Band1 = math.floor(x / scale)
		elseif y >= 100 and y <= 180 then -- 2
			Band2 = math.floor(x / scale)
		elseif y >= 200 and y <= 280 then -- 3
			Band3 = math.floor(x / scale)
		elseif y >= 300 and y <= 380 then -- 4
			if Band4 >= 0 then
				Band4 = math.floor(x / scale)
			end
			if x >= 6 and x <= 28 and y >= 330 and y <= 352 then -- checkbox to enable/disable band 4
				local time = love.timer.getTime()
				if time - Debounce > 0.1 then
					if Band4 < 0 then
						Band4 = 0
					else
						Band4 = -1
					end
					Debounce = time
				end
			end
		elseif y >= 400 and y <= 480 then -- 5
			if x < love.graphics.getWidth() / 2 then
				Band5 = 0
			else
				Band5 = 1
			end
		end
	end
	
	if Band4 < 0 then -- 4 banded
		Resistance[1] = ((Band1 * 10) + Band2) * Colors[Band3 + 1][2]
	else
		Resistance[1] = ((Band1 * 100) + (Band2 * 10) + Band3) * Colors[Band4 + 1][2]
	end

	Resistance[2] = round(Resistance[1] / (1 + Standard[Band5 + 1][2]), Decimals)
	Resistance[3] = round(Resistance[1] * (1 + Standard[Band5 + 1][2]), Decimals)
end