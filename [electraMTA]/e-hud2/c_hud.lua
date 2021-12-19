local font = dxCreateFont('fonts/font.ttf', 10)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end
function getStampDate()
    local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second

    local monthday = time.monthday
	local month = time.month
	local year = time.year

    local tarih = string.format("%02d/%02d/%04d", monthday, month + 1, year + 1900)
    local saat = string.format("%02d:%02d", hours, minutes)
    return {tarih, saat}
end 
addEventHandler("onClientRender", root,
    function()
        -- Genel Hud
        local tarih, saat = getStampDate()[1], getStampDate()[2]
        local playerid = getElementData(getLocalPlayer(), 'playerid')
        local hoursplayed = getElementData(getLocalPlayer(), 'hoursplayed')
        local hoursaim = getElementData(getLocalPlayer(), 'hoursaim')
        dxDrawRoundedRectangle(1597, 10, 313, 35, 13, tocolor(1, 0, 0, 162), false, false)
        dxDrawImage(1607, 17, 22, 22, ":e-hud2/images/hour.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(saat .. " #87888d " .. tarih, 1639, 17, 1752, 39, tocolor(255, 255, 255, 255), 1.00, font, "left", "center", false, false, false, true, false)
        dxDrawText("#87888dID #ffffff"..playerid.."", 1772, 17, 1792, 39, tocolor(255, 255, 255, 255), 1.00, font, "left", "center", false, false, false, true, false)
        dxDrawText("#ffffff" .. tonumber(#getElementsByType('player')) .. "#87888d/100", 1844, 17, 1864, 39, tocolor(255, 255, 255, 255), 1.00, font, "left", "center", false, false, false, true, false)
        dxDrawImage(1818, 17, 22, 22, ":e-hud2/images/users.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        -- Logo
        dxDrawImage(1620, 53, 43, 43, ":e-hud2/images/violence.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(hoursplayed .. "/" .. hoursaim, 1616 + 1, 99 + 1, 1667 + 1, 117 + 1, tocolor(0, 0, 0, 255), 1.00, font, "center", "top", false, false, false, false, false)
        dxDrawText(hoursplayed .. "/" .. hoursaim, 1616, 99, 1667, 117, tocolor(255, 255, 255, 255), 1.00, font, "center", "top", false, false, false, false, false)
        -- Stamina
        local current_stamina = getElementData(getLocalPlayer(), 'stamina') or 100
        local angle_end = (current_stamina * 360) / 100
        dxDrawCircle(1711, 75, 22.5, 0, 360, tocolor(0, 0, 0, 255), tocolor(0, 0, 0, 255))
        dxDrawCircle(1711, 75, 21.5, 0, angle_end, tocolor(180, 180, 185, 255), tocolor(180, 180, 185, 2555))
        dxDrawCircle(1711, 75, 21.5, 0, 360, tocolor(147, 147, 153, 255), tocolor(147, 147, 153, 255))
        dxDrawText(""..current_stamina.."%", 1686 + 1, 99 + 1, 1738 + 1, 117 + 1, tocolor(0, 0, 0, 255), 1.00, font, "center", "top", false, false, false, false, false)
        dxDrawText(""..current_stamina.."%", 1686, 99, 1738, 117, tocolor(255, 255, 255, 255), 1.00, font, "center", "top", false, false, false, false, false)
        dxDrawImage(1699, 61, 25, 25, ":e-hud2/images/energy.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)   
        -- Açlık
        local current_hunger = getElementData(getLocalPlayer(), 'hunger') or 100
        local angle_end2 = (current_hunger * 360) / 100
        dxDrawCircle(1781, 75, 22.5, 0, 360, tocolor(0, 0, 0, 255), tocolor(0, 0, 0, 255))
        dxDrawCircle(1781, 75, 21.5, angle_end2, 360, tocolor(183, 113, 67, 255), tocolor(183, 113, 67, 255))
        dxDrawCircle(1781, 75, 21.5, 0, angle_end2, tocolor(126, 86, 67, 255), tocolor(126, 86, 67, 255))
        dxDrawText(""..current_hunger.."%", 1756 + 1, 99 + 1, 1809 + 1, 117 + 1, tocolor(0, 0, 0, 255), 1.00, font, "center", "top", false, false, false, false, false)
        dxDrawText(""..current_hunger.."%", 1756, 99, 1809, 117, tocolor(255, 255, 255, 255), 1.00, font, "center", "top", false, false, false, false, false)
        --dxDrawRoundedRectangle(1760, 53, 43, 43, 20,tocolor(211, 84, 0, 255), false, false)
        dxDrawImage(1769, 61, 25, 25, ":e-hud2/images/hunger.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)   
        -- Susuzluk
        local current_thirst = getElementData(getLocalPlayer(), 'drink') or 100 
        local angle_end3 = (current_thirst * 360) / 100
        dxDrawCircle(1851, 75, 22.5, 0, 360, tocolor(0, 0, 0, 255), tocolor(0, 0, 0, 255))
        dxDrawCircle(1851, 75, 21.5, angle_end3, 360, tocolor(67, 124, 188, 255), tocolor(67, 124, 188, 255))
        dxDrawCircle(1851, 75, 21.5, 0, angle_end3, tocolor(64, 96, 120, 255), tocolor(64, 96, 120, 255))
        --dxDrawRoundedRectangle(1830, 53, 43, 43, 20, tocolor(52, 152, 219, 255), false, false)
        dxDrawText(""..current_thirst.."%", 1826 + 1, 99 + 1, 1880 + 1, 117 + 1, tocolor(0, 0, 0, 255), 1.00, font, "center", "top", false, false, false, false, false)
        dxDrawText(""..current_thirst.."%", 1826, 99, 1880, 117, tocolor(255, 255, 255, 255), 1.00, font, "center", "top", false, false, false, false, false)
        --dxDrawRoundedRectangle(1830, 53, 43, 43, 20,tocolor(21, 67, 96, 255), false, false)
        dxDrawImage(1839, 61, 25, 25, ":e-hud2/images/drink.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)   
    end
)