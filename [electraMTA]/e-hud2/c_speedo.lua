local dxfont0_font = dxCreateFont(":e-hud2/fonts/font.ttf", 20)
local dxfont1_font = dxCreateFont(":e-hud2/fonts/font.ttf", 10)
local dxfont2_font = dxCreateFont(":e-hud2/fonts/font.ttf", 13)

function dxDrawRing (posX, posY, radius, width, startAngle, amount, color, postGUI, absoluteAmount, anglesPerLine)
	if (type (posX) ~= "number") or (type (posY) ~= "number") or (type (startAngle) ~= "number") or (type (amount) ~= "number") then
		return false
	end
	
	if absoluteAmount then
		stopAngle = amount + startAngle
	else
		stopAngle = (amount * 360) + startAngle
	end
	
	anglesPerLine = type (anglesPerLine) == "number" and anglesPerLine or 1
	radius = type (radius) == "number" and radius or 50
	width = type (width) == "number" and width or 5
	color = color or tocolor (255, 255, 255, 255)
	postGUI = type (postGUI) == "boolean" and postGUI or false
	absoluteAmount = type (absoluteAmount) == "boolean" and absoluteAmount or false
	
	for i = startAngle, stopAngle, anglesPerLine do
		local startX = math.cos (math.rad (i)) * (radius - width)
		local startY = math.sin (math.rad (i)) * (radius - width)
		local endX = math.cos (math.rad (i)) * (radius + width)
		local endY = math.sin (math.rad (i)) * (radius + width)
		dxDrawLine (startX + posX, startY + posY, endX + posX, endY + posY, color, width, postGUI)
		dxDrawLine (endX + posX, endY + posY, endX + posX + 2, endY + posY + 2, color, width, postGUI)
	end
	return math.floor ((stopAngle - startAngle)/anglesPerLine)


end

function round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function getVehicleSpeed()
    if isPedInVehicle(getLocalPlayer()) then
	    local theVehicle = getPedOccupiedVehicle (getLocalPlayer())
        local vx, vy, vz = getElementVelocity (theVehicle)
        return math.sqrt(vx^2 + vy^2 + vz^2) * 180
    end
    return 0
end


addEventHandler('onClientRender', root, function()
    if getPedOccupiedVehicle(getLocalPlayer()) then
		local speed = round(getVehicleSpeed())
		local radius = 50
		local arc_len = 90 * (3.1415/180) * radius
		local ring_w, line_w = arc_len, 100
		local top = ring_w + line_w 
		local maxspeed = getVehicleHandling(getPedOccupiedVehicle(getLocalPlayer()))['maxVelocity']
		local ringspeed = (ring_w * maxspeed) / top
		local linespeed = maxspeed - ringspeed
		-- Fuel System
		local i1, i2, rad = 50, 50, 3
		local fuel = round(getElementData(getPedOccupiedVehicle(getLocalPlayer()), 'fuel'))
		i2 = i2 - (((i1+rad) * fuel) / 100)
		if speed>ringspeed then 

			ringo = 90 
			kalanhiz = speed - ringspeed 
			lingo = (kalanhiz * top) / maxspeed
		else 
			if speed==0 then 
				lingo, ringo = 0, 0
			else 
				lingo = 0 
				ringo = (speed * 90) / ringspeed
			end
		end 
        dxDrawRing (1750, 1050, radius, 1, 180, 90, tocolor (157, 155, 155), false, true, 0.05)
		dxDrawLine (1750, 1000.2519, 1850, 1000.2519, tocolor(157, 155, 155),2.5, false)
        dxDrawLine (1750, 1000.2519, 1750 + round(lingo), 1000.2519, tocolor(255, 255, 255), 2.5, false)
	    dxDrawRing (1750, 1050, radius, 1, 180, round(ringo), tocolor (255, 255, 255), false, true, 0.05)
		dxDrawText(speed, 1741, 1012, 1782, 1050, tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "center", "center", false, false, false, false, false)
        dxDrawText("km/h", 1782, 1026, 1823, 1044, tocolor(255, 254, 254, 215), 1.00, dxfont1_font, "center", "center", false, false, false, false, false)
		dxDrawImage(1870, 1055, 15, 15, ":e-hud2/images/speedo/fuel.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawRectangle(1873, 995, 6, i1, tocolor(127, 127, 127, 255), false)
		dxDrawRectangle(1873, 995, 6, i2, tocolor(98, 158, 95, 255), false)
		dxDrawCircle(1876, 995 + i1, rad, 0, 180, tocolor(127, 127, 127, 255))

    end 
	dxDrawImage(370, 973, 48, 48, ":e-hud2/images/speedo/purse.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)   
	dxDrawImage(370, 1025, 48, 48, ":e-hud2/images/speedo/location.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawText(exports.global:formatMoney(tonumber(math.floor(getElementData(getLocalPlayer(), 'money')))) .. "$", 426, 973, 587, 1021, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, false, false)
	dxDrawText(getZoneName(getElementPosition(getLocalPlayer())), 426, 1025, 647, 1055, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "top", false, false, false, false, false)
	dxDrawText("Los Santos", 426, 1043, 647, 1073, tocolor(255, 255, 255, 255), 1.00, dxfont2_font, "left", "top", false, false, false, false, false)
end)