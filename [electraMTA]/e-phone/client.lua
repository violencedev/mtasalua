--[[-------------------------------------------------
Notes:

> This code is using a custom font. This will only work as long as the location it is from always exists, and the resource it is part of is running.
    To ensure it does not break, it is highly encouraged to move custom fonts into your local resource and reference them there.
--]]-------------------------------------------------

local data = { 
    [1] = { 
        posX = 1676, 
        posY = 584, 
        posW = 42, 
        posH = 42, 
        hovering = false, 
        colors = { 255, 255, 255, 255 } 
    }, 
    [2] = {
        posX = 1788,
        posY = 584,
        posW = 42,
        posH = 42,
        hovering = false, 
        colors = {255, 255, 255, 255}
    },
    [3] = {
        posX = 1676,
        posY = 636,
        posW = 42,
        posH = 42,
        hovering = false,
        colors = {255, 255, 255, 255}
    },
} 

uygulamalar = {
    {isim='Whatsapp', boyut="25MB", logo=':e-phone/components/images/whatsapp.png'}
}


local dxfont0_font = dxCreateFont(":e-phone/components/fonts/font.ttf", 11)
local dxfont1_font = dxCreateFont(":e-phone/components/fonts/font.ttf", 7)

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
    aylar = {"Ocak", "Subat", "Mart", "Nisan", "Mayis", "Haziran", "Temmuz", "Agustos", "Eylul", "Ekim", "Kasim", "Aralik"}
    local tarih = string.format("%02d " .. string.upper(aylar[month+1]) .. " %04d", monthday, year + 1900)
    med = ""
    if (getElementData(getLocalPlayer(), 'zaman:dilimi') or 12) == 12 then 
        if hours > 12 then 
            med = "PM"
            hours = hours - 12
        else 
            med = "AM"
        end
    end 
    local saat = string.format("%02d:%02d " .. med, hours, minutes)
    return {saat, tarih}
end 



function getLeftBattery()
    return (getElementData(getLocalPlayer(), 'batarya') or 100)
end 

function round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

setElementData(getLocalPlayer(), 'telefon:no', 553555)

addEventHandler('onClientRender', root, function()
    --if (getElementData(getLocalPlayer(), 'ekran') or "anamenu") == 'anamenu' then 
        showCursor(true)
        dxDrawImage(1658, 411, 247, 490, ":e-phone/components/images/" .. (getElementData(getLocalPlayer(), 'arkaplan') or "phone") .. '.png', 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(getStampDate()[1] .. "\n" .. getStampDate()[2], 1672, 505, 1889, 547, tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "center", "top", false, false, false, false, false)
        dxDrawImage(1676, 584, 42, 42, ":e-phone/components/images/settings.png", 0, 0, 0, tocolor(255, 255, 255, data[1].hovering), false)
        dxDrawImage(1732, 584, 42, 42, ":e-phone/components/images/safari.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(1788, 584, 42, 42, ":e-phone/components/images/store.png", 0, 0, 0, tocolor(255, 255, 255, data[2].hovering), false)
        dxDrawImage(1844, 584, 42, 42, ":e-phone/components/images/sms.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(1676, 636, 42, 42, ":e-phone/components/images/contacts.png", 0, 0, 0, tocolor(255, 255, 255, data[3].hovering), false)
        local ayarlar = getElementData(getLocalPlayer(), 'apps')
        for i, v in ipairs(ayarlar) do
            if i <= 4 then
                dxDrawImage(1676 + (i * 56), 636, 42, 42, ":e-phone/components/images/" .. string.lower(v) .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
            end
        end
        local remaining_battery = getLeftBattery() - (0.0001)
        if remaining_battery < 0 then 
            remaining_battery = 100
        end
        setElementData(getLocalPlayer(), 'batarya', remaining_battery)
        if getElementData(getLocalPlayer(), 'arama:icte3') == true then
            dxDrawText('Aramada | ' .. (getElementData(getLocalPlayer(), 'konustugukisi') or "Acil Servis") .. ' | ' .. getElementData(getLocalPlayer(), 'gecensure') or "0:00", 1671, 475, 1888, 488, tocolor(255, 254, 254, 255), 1.00, dxfont1_font, "center", "top", false, false, false, false, false)
        else
            if (getElementData(getLocalPlayer(), 'batarya:gosterge') or "Hem oran hem gösterge") == "Yalnızca oran" then
                dxDrawText(round(remaining_battery) .. "%", 1849, 476, 1885, 487, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "center", "center", false, false, false, false, false)
            elseif (getElementData(getLocalPlayer(), 'batarya:gosterge') or "Hem oran hem gösterge") == "Yalnızca gösterge" then
                dxDrawLine(1849 - 1, 477 - 1, 1849 - 1, 487, tocolor(0, 0, 0, 255), 1, false)
                dxDrawLine(1885, 477 - 1, 1849 - 1, 477 - 1, tocolor(0, 0, 0, 255), 1, false)
                dxDrawLine(1849 - 1, 487, 1885, 487, tocolor(0, 0, 0, 255), 1, false)
                dxDrawLine(1885, 487, 1885, 477 - 1, tocolor(0, 0, 0, 255), 1, false)
                --dxDrawRoundedRectangle(1849, 477, 36, 10, 3, tocolor(255, 255, 255, 0), false, false)
                dxDrawRoundedRectangle(1849, 477, (36 * remaining_battery) / 100, 10, 3, tocolor(129, 126, 125, 255), false, false)
            else 
                dxDrawLine(1849 - 1, 477 - 1, 1849 - 1, 487, tocolor(0, 0, 0, 255), 1, false)
                dxDrawLine(1885, 477 - 1, 1849 - 1, 477 - 1, tocolor(0, 0, 0, 255), 1, false)
                dxDrawLine(1849 - 1, 487, 1885, 487, tocolor(0, 0, 0, 255), 1, false)
                dxDrawLine(1885, 487, 1885, 477 - 1, tocolor(0, 0, 0, 255), 1, false)
                --dxDrawRoundedRectangle(1849, 477, 36, 10, 3, tocolor(255, 255, 255, 0), false, false)
                dxDrawRoundedRectangle(1849, 477, (36 * remaining_battery) / 100, 10, 3, tocolor(129, 126, 125, 255), false, false)
                dxDrawText(round(remaining_battery) .. "%", 1849, 476, 1885, 487, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "center", "center", false, false, false, false, false)
            end
        end
    --end
end)

function inside(x1, y1, x2, y2, w2, h2) 
    return not (x1 < x2  or x2+w2 < x1 or y1 < y2 or y2+h2 < y1) 
end 

addEventHandler("onClientClick", root,  function(_, state, x, y) 
    if state == "down" then 
        if (inside(x, y, 1676, 584, 42, 42)) then 
            if guiGetVisible(ayarlar) == false then
                ayarlar = guiCreateWindow(775, 358, 370, 364, "Cep Telefonu(TelNO) - Ayarlar", false)
                guiWindowSetSizable(ayarlar, false) 
                guiWindowSetMovable(ayarlar, false)
                ayarlist = guiCreateGridList(10, 25, 350, 281, false, ayarlar)
                guiGridListAddColumn(ayarlist, "Seçenek", 0.5)
                guiGridListAddColumn(ayarlist, "Durum", 0.5)
                for i = 1,3 do 
                    guiGridListAddRow(ayarlist)
                end 
                guiGridListSetItemText(ayarlist, 0, 1, "Saat Dilimi", false, false)
                guiGridListSetItemText(ayarlist, 0, 2, tostring((getElementData(getLocalPlayer(), 'zaman:dilimi')) or 12) .. " Saatlik Dilim", false, false)
                guiGridListSetItemText(ayarlist, 1, 1, "Batarya Göstergesi", false, false)
                guiGridListSetItemText(ayarlist, 1, 2, getElementData(getLocalPlayer(), 'batarya:gosterge') or "Hem oran hem gösterge", false, false) -- hem oran hem gösterge, yalnızca gösterge ya da yalnızca oran
                guiGridListSetItemText(ayarlist, 2, 1, "Arkaplan", false, false)
                guiGridListSetItemText(ayarlist, 2, 2, getElementData(getLocalPlayer(), 'arkaplan') or "phone", false, false)

                submit = guiCreateButton(10, 316, 89, 38, "Onayla", false, ayarlar)
                cancel = guiCreateButton(273, 316, 87, 38, "Kapat", false, ayarlar)  
                addEventHandler('onClientGUIClick', getRootElement(), function(state)
                    if source == cancel then 
                        guiSetVisible(ayarlar, false)
                    end 
                    if source == submit then 
                        guiSetVisible(ayarlar, false)
                    end 
                end)
                addEventHandler('onClientGUIDoubleClick', getRootElement(), function(state)
                
                    local itemtext = guiGridListGetItemText(ayarlist, guiGridListGetSelectedItem(ayarlist))
                    if itemtext == 'Saat Dilimi' then 
                        if (getElementData(getLocalPlayer(), 'zaman:dilimi') or 12) == 12 then 
                            -- 24 yap
                            setElementData(getLocalPlayer(), 'zaman:dilimi', 24)
                        else 
                            -- 12 yap
                            setElementData(getLocalPlayer(), 'zaman:dilimi', 12)
                        end 
                        guiGridListSetItemText(ayarlist, 0, 2, tostring(getElementData(getLocalPlayer(), 'zaman:dilimi')) .. " Saatlik Dilim", false, false)
                    end 
                    if itemtext == 'Batarya Göstergesi' then 
                        if (getElementData(getLocalPlayer(), 'batarya:gosterge') or "Hem oran hem gösterge") == "Hem oran hem gösterge" then
                            setElementData(getLocalPlayer(), 'batarya:gosterge', 'Yalnızca gösterge')
                        elseif (getElementData(getLocalPlayer(), 'batarya:gosterge') or "Hem oran hem gösterge") == "Yalnızca gösterge" then
                            setElementData(getLocalPlayer(), 'batarya:gosterge', 'Yalnızca oran')
                        elseif (getElementData(getLocalPlayer(), 'batarya:gosterge') or "Hem oran hem gösterge") == "Yalnızca oran" then 
                            setElementData(getLocalPlayer(), 'batarya:gosterge', 'Hem oran hem gösterge')
                        end 
                        guiGridListSetItemText(ayarlist, 1, 2, getElementData(getLocalPlayer(),'batarya:gosterge'), false, false)
                    end 
                    if itemtext == "Arkaplan" then 
                        if (getElementData(getLocalPlayer(), 'arkaplan') or 'phone') == "phone" then 
                            setElementData(getLocalPlayer(), 'arkaplan', 'phone-2')
                        elseif (getElementData(getLocalPlayer(), 'arkaplan') or 'phone') == "phone-2" then
                            setElementData(getLocalPlayer(), 'arkaplan', 'phone3')
                        elseif(getElementData(getLocalPlayer(), 'arkaplan') or 'phone') == "phone3" then
                            setElementData(getLocalPlayer(), 'arkaplan', 'phone4')
                        elseif(getElementData(getLocalPlayer(), 'arkaplan') or 'phone') == "phone4" then
                            setElementData(getLocalPlayer(), 'arkaplan', 'phone')
                        end 
                        guiGridListSetItemText(ayarlist, 2, 2, getElementData(getLocalPlayer(), 'arkaplan'), false, false)
                    end 
                end)

            end
        return end
        if (inside(x, y, 1788, 584, 42, 42)) then 
            if guiGetVisible(store) == false then
                store = guiCreateWindow(775, 358, 370, 364, "Cep Telefonu(TelNO) - Uygulama Mağazası", false)
                guiWindowSetSizable(store, false) 
                guiWindowSetMovable(store, false)
                uygulamalistesi = guiCreateGridList(10, 25, 350, 281, false, store)
                guiGridListAddColumn(uygulamalistesi, "Uygulama Ismi", 0.5)
                guiGridListAddColumn(uygulamalistesi, "Uygulama Boyutu", 0.5)
                for k, v in pairs(uygulamalar) do
                    guiGridListAddRow(uygulamalistesi)
                    guiGridListSetItemText(uygulamalistesi, guiGridListGetRowCount(uygulamalistesi) - 1, 1, v.isim, false, false)
                    guiGridListSetItemText(uygulamalistesi, guiGridListGetRowCount(uygulamalistesi) - 1, 2, v.boyut, false, false)
                end
                submit = guiCreateButton(10, 316, 89, 38, "Uygulamayı Yükle", false, store)
                submit2 = guiCreateButton(283 / 2, 316, 89, 38, "Uygulamayı Kaldır", false, store)
                cancel = guiCreateButton(273, 316, 87, 38, "Kapat", false, store)  
                addEventHandler('onClientGUIClick', getRootElement(), function(state)
                    if source == cancel then 
                        guiSetVisible(store, false)
                    end 
                    if source == submit then 
                        local secilmis_text = guiGridListGetItemText(uygulamalistesi, guiGridListGetSelectedItem(uygulamalistesi))
                        if string.len(secilmis_text) > 1 then 

                            local ekuygulamalar = getElementData(getLocalPlayer(), 'apps') or {}
                            if not yu(ekuygulamalar, secilmis_text) == true then
                                table.insert(ekuygulamalar, secilmis_text)
                                local ekledi = setElementData(getLocalPlayer(), 'apps', ekuygulamalar) 
                            end
                        end 
                    
                    end 
                    if source == submit2 then 
                        local secilmis_text = guiGridListGetItemText(uygulamalistesi, guiGridListGetSelectedItem(uygulamalistesi))
                        if string.len(secilmis_text) > 1 then 
                            local ekuygulamalar = getElementData(getLocalPlayer(), 'apps') or {}
                            if yu(ekuygulamalar, secilmis_text) == true then
                                    table.remove(ekuygulamalar, getIndexFromName(ekuygulamalar, secilmis_text))
                                    setElementData(getLocalPlayer(), 'apps',ekuygulamalar)
                            end
                        end 
                    end 
                end)
            end
        return end 
        if (inside(x, y, 1676, 636, 42, 42)) then 
            kisiler = guiCreateWindow(775, 358, 370, 364, "Cep Telefonu(TelNo) - Rehber", false)
            guiWindowSetSizable(kisiler, false)

            liste = guiCreateGridList(9, 56, 351, 254, false, kisiler)
            guiGridListAddColumn(liste, "İsim", 0.5)
            guiGridListAddColumn(liste, "Telefon No", 0.5)
            kisiekle = guiCreateButton(9, 317, 103, 37, "Kişi Ekle", false, kisiler)
            kisisil = guiCreateButton(257, 317, 103, 37, "Kişiyi Sil", false, kisiler)
            menukapat = guiCreateButton(134, 317, 103, 37, "Arayüzü Kapat", false, kisiler)
            sorgulamakutusu = guiCreateEdit(14, 24, 156 + 177, 27, "İsim / Telefon No", false, kisiler)
            
            --sorgula = guiCreateButton(183, 25, 177, 26, "Sorgula", false, kisiler) 
            addEventHandler('onClientGUIDoubleClick', getRootElement(), function(state)
            
                local itemtext = guiGridListGetItemText(liste, guiGridListGetSelectedItem(liste))
                local row, col = guiGridListGetSelectedItem(liste)
                col = col + 1
                local phonenum = guiGridListGetItemText(liste, row, col)
                local contacts = getElementData(getLocalPlayer(), 'contaktlar')
                if isExists(itemtext, "0", contacts) == true then 
                    if not getElementData(getLocalPlayer(), 'arama:icte3') == true then 
                        setElementData(getLocalPlayer(), 'arama:icte3', true)
                        setElementData(getLocalPlayer(), 'konustugukisi', getPlayerFromPhoneNumber(tonumber(phonenum)))
                        setElementData(getLocalPlayer(), 'gecensure', 'Çalıyor...')
                        playSound(':e-phone/components/sounds/touch_tone.mp3', false, true)
                        setTimer(function()
                            local karsi = getPlayerFromPhoneNumber(tonumber(phonenum))
                            if not getElementData(karsi, 'arama:icte3') == true then
                                local event = triggerEvent('get:phone:call', karsi, getLocalPlayer())
                                guiSetVisible(kisiler, false)
                                local calmasesi = playSound(':e-phone/components/sounds/dialing_tone.mp3', true, true)
                            else 
                                playSound(':e-phone/components/sounds/busy.mp3', false, true)
                            end 
                        end, 1005, 1)
                    end 
                end 
            end)
            addEventHandler('onClientGUIClick', getRootElement(), function()
                if source == menukapat then 
                    guiSetVisible(kisiler, false)
                end 
                if source == kisiekle then 
                    guiSetVisible(kisiler, false)
                    onay = guiCreateWindow(866, 453, 183, 148, "Kişi Ekle", false)
                    guiWindowSetSizable(onay, false)
                    
                    isim = guiCreateEdit(9, 34, 164, 32, "Rehberdeki ismi", false, onay)
                    numara = guiCreateEdit(9, 76, 164, 32, "Telefon numarası", false, onay)
                    submitb = guiCreateButton(9, 114, 77, 24, "Onayla", false, onay)
                    canb = guiCreateButton(96, 114, 77, 24, "İptal et", false, onay)  
                    addEventHandler('onClientGUIClick', getRootElement(), function(state)
                    
                            if source == canb then 
                                guiSetVisible(onay, false)
                                guiSetVisible(kisiler, true) 
                            elseif source == submitb then 
                                local isimm, numaraa = guiGetText(isim), guiGetText(numara)
                                local rehber = getElementData(getLocalPlayer(), 'contaktlar') or {}
                                if not isExists(isimm, numaraa, rehber) == true then 
                                    if tonumber(numaraa) then
                                        table.insert(rehber, {isim=isimm, numara=tonumber(numaraa)})
                                        setElementData(getLocalPlayer(), 'contaktlar', rehber)
                                        guiSetVisible(onay, false)
                                        guiSetVisible(kisiler, true)
                                        guiGridListClear(liste)
                                        local contacts = getElementData(getLocalPlayer(), 'contaktlar') or {}
                                        for k, v in pairs(contacts) do 
                                            guiGridListAddRow(liste, v.isim, v.numara)
                                        end 
                                    end
                                end
                            end 
                    end)
                end
                if source == kisisil then 
                    local selectedtext = guiGridListGetItemText(liste, guiGridListGetSelectedItem(liste))
                    if string.len(selectedtext) > 1 then 
                        guiSetVisible(kisiler, false)
                        onay2 = guiCreateWindow(866, 453, 183, 148, "Kişi Sil", false)
                        guiWindowSetSizable(onay2, false)
                        label = guiCreateLabel(5, 20, 160, 148, 'Silmek istediğinize emin misiniz? [' .. selectedtext .. ']', false, onay2)
                        guiLabelSetHorizontalAlign(label, "center", true)
                        submitb2 = guiCreateButton(9, 114, 77, 24, "Onayla", false, onay2)
                        canb2 = guiCreateButton(96, 114, 77, 24, "İptal et", false, onay2)  
                        addEventHandler('onClientGUIClick', getRootElement(), function(state)
        
                            if source == canb2 then 
                                guiSetVisible(onay2, false)
                                guiSetVisible(kisiler, true) 
                            elseif source == submitb2 then 
                                guiSetVisible(onay2, false)
                                guiSetVisible(kisiler, true)
                                local rehber = getElementData(getLocalPlayer(), 'contaktlar')
                                for k, v in pairs(rehber) do 
                                    if v.isim == selectedtext then 
                                        table.remove(rehber, k)
                                        setElementData(getLocalPlayer(), 'contaktlar', rehber)
                                        guiGridListClear(liste)
                                        local contacts = getElementData(getLocalPlayer(), 'contaktlar') or {}
                                        for k, v in pairs(contacts) do 
                                            guiGridListAddRow(liste, v.isim, v.numara)
                                        end  
                                    end    
                                end 
                            end   
                        end)
                    end 
                end
            end)
            guiSetInputMode('no_binds_when_editing')
            local contacts = getElementData(getLocalPlayer(), 'contaktlar') or {}
            for k, v in pairs(contacts) do 
                guiGridListAddRow(liste, v.isim, v.numara)
            end
            addEventHandler('onClientGUIChanged', sorgulamakutusu, function(character)
                    local rehber = getElementData(getLocalPlayer(), 'contaktlar')
                    local new_rehber = {}
                    for key, value in pairs(rehber) do 
                        if string.find(value.isim, guiGetText(sorgulamakutusu)) then 
                            table.insert(new_rehber, {isim=value.isim, numara=value.numara})
                        end
                    end 
                    guiGridListClear(liste)
                    for k, v in pairs(new_rehber) do 
                        guiGridListAddRow(liste, v.isim, v.numara)
                    end
        
        end)
        return end
        if (inside(x, y, 1761, 846, 1797, 885)) then 
            setElementData(getLocalPlayer(), 'ekran', 'anamenu')
        return end 
    end 
end 
) 

function hangedUp(pl)
    playSound(':e-phone/components/sounds/hangup.mp3', false, true)
end 

function updateDialingTime(caller, receiver)
    setTimer(function()
        local gecen = getElementData(caller, 'gecensure')
        local dk, sn = split(gecen, ':')[1], split(gecen, ':')[2]
        dk, sn = tonumber(dk), tonumber(sn)
        sn = sn + 1
        if sn == 60 then 
            sn = 0
            dk = dk + 1
        end 
        local formatted = tostring(dk) .. ":" .. tostring(sn)
        setElementData(caller, 'gecensure', formatted)
        setElementData(receiver, 'gecensure', formatted)
    end, 1000, 0)
end 

addCommandHandler('kapat', function(pl, cmd)
    if getElementData(pl, 'arama:icte3') == true then 
        outputChatBox('sa')
        setElementData(pl, 'arama:icte3', false)
        setElementData(pl, 'gecensure', nil)
        local other = getElementData(pl, 'konustugukisi')
        setElementData(pl, 'konustugukisi', nil)
        setElementData(other, 'arama:icte3', false)
        setElementData(other, 'gecensure', nil)
        setElementData(other, 'konustugukisi', nil)
        showCursor(false)
    end 
end)

function getPhoneCall(caller)
    local zilsesi = playSound(':e-phone/components/sounds/apple_ring.mp3', true, true)
    showCursor(true)
    onay2 = guiCreateWindow(866, 453, 183, 148, "Gelen Arama[" .. getPlayerName(getLocalPlayer()) .. "]", false)
    guiWindowSetSizable(onay2, false)
    guiWindowSetMovable(onay2, false)
    label = guiCreateLabel(5, 20, 160, 148, 'Lütfen aramaya cevap verin ya da reddedin.', false, onay2)
    guiLabelSetHorizontalAlign(label, "center", true)
    submitb2 = guiCreateButton(9, 114, 77, 24, "Cevap Ver", false, onay2)
    canb2 = guiCreateButton(96, 114, 77, 24, "Reddet", false, onay2)  
    addEventHandler('onClientGUIClick', root, function(state)
    
        if source == submitb2 then 
            stopSound(zilsesi)
            guisetVisible(onay2, false)
            showCursor(false)
            setElementData(getLocalPlayer(), 'arama:icte3', true)
            setElementData(getLocalPlayer(), 'konustugukisi', getPlayerName(caller))
            setElementData(caller, 'gecensure', "0:00")
            setElementData(getLocalPlayer(), 'gecensure', "0:00")
            updateDialingTime(caller, getLocalPlayer())
        elseif source == canb2 then 
            setElementData(caller, 'arama:icte3', false)
            setElementData(caller, 'konustugukisi', nil)
            setElementData(caller, 'gecensure', nil)
            guiSetVisible(onay2, false)
            stopSound(zilsesi)
            hangedUp(caller)
            showCursor(false)
        end 
    end)
end 
addEvent('get:phone:call', true)
addEventHandler('get:phone:call', root, getPhoneCall)

function getPlayerFromPhoneNumber(telno)
    for key, value in pairs(getElementsByType('player')) do 
        if tonumber(getElementData(value, 'telefon:no')) ~= tonumber(telno) then 
            return value
        end
    end 
end 

function getIndexFromName(tablo, object)
    for k, v in pairs(tablo) do 
        if v.isim ~= object then 
            return k
        end 
    end 
end 
function isExists(isim, no, rehber)
    for k, v in pairs(rehber) do 
        if v.isim == isim or v.numara == tonumber(no) then 
            return true
        end 
    end 
end
function yu(tablo, item)
    for k, v in pairs(tablo) do 
        if v == (item) then 
            return true
        end 
    end 
end 


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