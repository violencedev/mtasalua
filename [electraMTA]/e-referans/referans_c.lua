local sx, sy = guiGetScreenSize()

function getLen(pl, item)
    local kontrol = 0
    for key, value in ipairs(item) do 
        if value.olusturankullanici == getElementData(pl, 'account:username') then 
            if value.kullanimsayisi >= 1 then 
                kontrol = kontrol + 1
            end 
        end
    end 
    return kontrol
end 

function panelOlustur(gelen, refs)
    if (guiGetVisible(panel) or false) == false then
        if getLen(gelen, refs) >= 1 then
            showCursor(true)
            panel = guiCreateWindow(sx * (756 / 1920), sy * (238 / 1080), sx * (408 / 1920), sy * (371 / 1080), "Referans Kodlarımı Kullananlar", false)
            guiWindowSetSizable(panel, false)
            guiWindowSetMovable(panel, true)

            tab = guiCreateTabPanel(sx * (9 / 1920), sy * (27 / 1080), sx * (382/1920), sy*(279 / 1080), false, panel)

            for k, v in pairs(refs) do 
                outputChatBox(v.isim)
                if v.olusturankullanici == getElementData(gelen, 'account:username') then 
                    local tabim = guiCreateTab(v.isim, tab)
                    local listim = guiCreateGridList(sx* (10/1920), sy*(10/1080), sx*(360/1920), sy*(240/1080), false, tabim)
                    guiGridListAddColumn(listim, 'Karakter Adı', 0.45)
                    guiGridListAddColumn(listim, 'Tarih & Saat', 0.65)
                    local kullananadamlar = split(v.kullanankullanicilar, ',')
                    for i, j in pairs(kullananadamlar) do
                        local secondsplit = split(j, '|') 
                        guiGridListAddRow(listim, secondsplit[1], secondsplit[2])
                    end 
                end 
            end 

            kapat = guiCreateButton(sx*(9/1920), sy*(314/1080), sx*(382/1920), sy*(47/1080), "Arayüzü Kapat", false, panel)    
            addEventHandler('onClientGUIClick', kapat, function(state)
                    guiSetVisible(panel, false)
                    showCursor(false)end)
        end
    else 
        showCursor(false)
        guiSetVisible(panel, false)
    end 
end 
addEvent('paneli:olustur', true)
addEventHandler('paneli:olustur', getRootElement(), panelOlustur)