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

local data = { 
    [1] = { 
        posX = 1657, 
        posY = -3, 
        posW = 74, 
        posH = 74, 
        hovering = false, 
        colors = { 21, 124, 212, 255 } 
    }, 
} 



local dxfont0_font = dxCreateFont("font.ttf", 10)
addEventHandler("onClientRender", root,
    function()
        local tick = getTickCount() 
        local isim = getPlayerName(getLocalPlayer())
        local id = getElementData(getLocalPlayer(), 'playerid')
        local hunger = getElementData(getLocalPlayer(), 'hunger')
        local thirst = getElementData(getLocalPlayer(), 'drink')
        local t = 164
        local hunger_rate = (hunger * t) / 100
        local thirst_rate = (thirst * t) / 100
        dxDrawRoundedRectangle(1716, 14, 194, 40, 10, tocolor(1, 0, 0, 156), false, false)
        dxDrawText(isim, 1726 + 1, 23 + 1, 1840 + 1, 44 + 1, tocolor(0, 0, 0, 255), 1.00, dxfont0_font, "left", "center", false, false, false, false, false)
        dxDrawText(isim, 1726, 23, 1840, 44, tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "left", "center", false, false, false, false, false)
        dxDrawRectangle(1849, 23, 1, 25, tocolor(254, 254, 254, 149), false)
        dxDrawText("ID : "..id.."", 1860 + 1, 23 + 1, 1896 + 1, 44 + 1, tocolor(0, 0, 0, 255), 1.00, dxfont0_font, "left", "center", false, false, false, false, false)
        dxDrawText("ID : "..id.."", 1860, 23, 1896, 44, tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "left", "center", false, false, false, false, false)
        logo = dxDrawImage(1657, -3, 74, 74, "images/logo.png", 0, 0, 0, tocolor(21, 124, 212, data[1].hovering), false)
        dxDrawImage(1713, 95, 29, 29, ":e-hud/images/food.png", 0, 0, 0, tocolor(229, 155, 25, 255), false)
        dxDrawImage(1713, 58, 29, 29, ":e-hud/images/drink.png", 0, 0, 0, tocolor(38, 130, 215, 255), false)
        dxDrawRoundedRectangle(1745, 68, t, 15, 5,tocolor(38, 130, 215, 255), false, false)
        dxDrawRoundedRectangle(1745, 102, t, 15, 5, tocolor(229, 169, 24, 255), false, false)
        dxDrawRoundedRectangle(1745, 68, thirst_rate, 15, 5,tocolor(36, 83, 216, 255), false, false)
        dxDrawRoundedRectangle(1745, 102, hunger_rate, 15, 5,tocolor(240, 120, 13, 255), false, false)
        local saglik = getElementHealth(getLocalPlayer())
        if getElementData(getLocalPlayer(), 'dead') == 1 then 
            destroyElement(logo)
            dxDrawImage(1657, -3, 74, 74, "images/logo.png", 0, 0, 0, tocolor(91, 91, 91, data[1].hovering), false)
        end 
        if saglik >= 80 then 
            return 
        end 
        if saglik < 80 and saglik >= 60 then 
            destroyElement(logo)
            dxDrawImage(1657, -3, 74, 74, "images/logo.png", 0, 0, 0, tocolor(255, 165, 0, data[1].hovering), false)
        return end 
        if saglik < 60 and saglik >= 50 then 
            destroyElement(logo)
            dxDrawImage(1657, -3, 74, 74, "images/logo.png", 0, 0, 0, tocolor(241, 194, 50, data[1].hovering), false)
        return end 
        if saglik < 50 and saglik >= 20 then 
            destroyElement(logo)
            dxDrawImage(1657, -3, 74, 74, "images/logo.png", 0, 0, 0, tocolor(255, 0, 0, data[1].hovering), false)
        return end 
        if saglik < 20 then 
            destroyElement(logo)
            dxDrawImage(1657, -3, 74, 74, "images/logo.png", 0, 0, 0, tocolor(153, 153,153, data[1].hovering), false)
        return end
    end
)

addEventHandler ( "onClientCursorMove", root, function ( _, _, cx, cy ) 
    for i, v in pairs ( data ) do 
        local x, y, w, h = v.posX, v.posY, v.posW, v.posH; 
        if ( cx >= x and cx <= x+w and cy >= y and cy <= y+h ) then 
            data[i].hovering = 150 
        else 
            data[i].hovering = 255 
        end 
    end 
end ) 