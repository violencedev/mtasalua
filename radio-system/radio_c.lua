
titleFont = dxCreateFont('font.ttf', 12, false)
textFont = dxCreateFont('font.ttf', 10, false)

addEventHandler('onClientRender', root, function()
    if not getElementData(getLocalPlayer(), 'radio:code') then return end 
    if not getPedOccupiedVehicle(getLocalPlayer()) then return end 
    triggerServerEvent('retrieve:Data', getLocalPlayer())
    dxDrawRectangle(1640, 333, 260, 477, tocolor(1, 0, 0, 88), false)
    dxDrawText("Frekanstaki Aktif Dinleyiciler", 1650 + 1, 341 + 1, 1890 + 1, 360 + 1, tocolor(0, 0, 0, 255), 1.00, titleFont, "center", "top", false, false, false, false, false)
    dxDrawText("Frekanstaki Aktif Dinleyiciler", 1650, 341, 1890, 360, tocolor(255, 255, 255, 255), 1.00, titleFont, "center", "top", false, false, false, false, false)
    dxDrawRectangle(1640, 365, 260, 2, tocolor(255, 254, 254, 70), false)
    dxDrawText(getElementData(getLocalPlayer(), 'beynimisikeyimbunuyapan'), 1650 + 1, 370 + 1, 1890 + 1, 791 + 1, tocolor(0, 0, 0, 255), 1.00, textFont, "center", "top", false, false, false, false, false)
    dxDrawText(getElementData(getLocalPlayer(), 'beynimisikeyimbunuyapan'), 1650, 370, 1890, 791, tocolor(255, 255, 255, 255), 1.00, textFont, "center", "top", false, false, false, false, false)
end)
