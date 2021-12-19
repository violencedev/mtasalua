maxRecordsWillBeShown = 5

avaliableQuestions = {} -- retrieved database algorithm by violence

addEvent('update:Client', true)
addEventHandler('update:Client', root, function(hasComeTable)
    avaliableQuestions = hasComeTable
    updateUI()
end)

function getRange()
    s = 0
    s2 = 0
    for _,v in pairs(avaliableQuestions) do 
        s2 = s2 + 1
        if v.seenable == 1 then 
            s = s + 1
        end 
    end 
    if s == 0 then 
        returned = 0
    else 
        returned = ((s * 100) / s2)
    end 
    return returned
end 

function round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function getAllQuestions()
    s = 0
    for _,v in pairs(avaliableQuestions) do 
        s = s + 1
    end 
    return s
end 

function strFind(sub, fix)
    for _,v in pairs(split(sub, ' ')) do 
        if string.find(sub, fix) then 
            return true
        end 
    end 
end 

panel = guiCreateWindow(718, 330, 476, 253, "Soru Sorma Sistemi - © violence", false)
guiWindowSetSizable(panel, false)
guiSetVisible(panel, false)
tabpanel = guiCreateTabPanel(9, 28, 458, 215, false, panel)

ui = guiCreateTab("Kullanıcı Arayüzü", tabpanel)

editBox = guiCreateEdit(21, 35, 192, 30, "Sorunuzu lütfen buraya yazınız.", false, ui)
checkBox = guiCreateCheckBox(214, 36, 91, 29, "Herkese açık?", true, false, ui)    
sendQuestion = guiCreateButton(310, 41, 131, 20, "Soruyu Gönder", false, ui)
recentQuestions = guiCreateGridList(21, 70, 420, 115, false, ui)
guiGridListAddColumn(recentQuestions, "ID", 0.3)
guiGridListAddColumn(recentQuestions, "Durum", 0.3)
guiGridListAddColumn(recentQuestions, "Tarih", 0.3)
infoText = guiCreateLabel(23, 7, 418, 24, "Lütfen sorunuzu aşağıya yazıp soruyu gönderme butonuna tıklayınız.", false, ui)
guiLabelSetColor(infoText, 255, 254, 254)
guiLabelSetHorizontalAlign(infoText, "center", true)

panel2 = guiCreateWindow(718, 330, 476, 220, "Soru Sorma Sistemi - © violence", false)
guiWindowSetSizable(panel2, false)
guiSetVisible(panel2, false)

avaliableQuestionsL = guiCreateGridList(15, 25, 443, 136, false, panel2)
guiGridListAddColumn(avaliableQuestionsL, "ID", 0.3)
guiGridListAddColumn(avaliableQuestionsL, "Oyuncu", 0.3)
guiGridListAddColumn(avaliableQuestionsL, "Tarih", 0.3)
acceptQuestion = guiCreateButton(1, 176, 112, 40, "Soruyu Cevapla", false, panel2)
quit = guiCreateButton(332, 176, 112, 40, "Arayüzü Kapat", false, panel2)
statsAdmin = guiCreateLabel(120, 176, 211, 42, "Aktif Yetkili Sayısı : \nBekleyen Soru Sayısı :", false, panel2)
guiLabelSetHorizontalAlign(statsAdmin, "center", true)    

-- bütün sorular 

allquest = guiCreateTab("Tüm Sorular", tabpanel)

allquestions = guiCreateGridList(4, 4, 443, 140, false, allquest)
guiGridListAddColumn(allquestions, "ID", 0.3)
guiGridListAddColumn(allquestions, "Oyuncu", 0.3)
guiGridListAddColumn(allquestions, "Tarih", 0.3)
queryBox = guiCreateEdit(4, 144, 220, 30, 'Arama yapınız...', false, allquest)
stats = guiCreateLabel(200, 144, 250, 42, "", false, allquest)
guiLabelSetHorizontalAlign(stats, "center", true)  


addEventHandler('onClientGUIChanged', queryBox, function() 
    local new = guiGetText(queryBox)
    guiGridListClear(allquestions)
    for _,v in pairs(avaliableQuestions) do 
        if strFind(string.lower(v.context), string.lower(new)) == true then 
            if v.seenable == 1 then
                if v.staffHandled == "Yok" then 
                    durum = "Bakılmamış"
                else 
                    durum = "Bakılmış(" .. v.staffHandled .. ')' 
                end 
                guiGridListAddRow(allquestions, v.id, durum, v.timestamp)
            end
        end 
    end 
end)


addEventHandler('onClientGUIDoubleClick', allquestions, function()
    local row, column = guiGridListGetSelectedItem(allquestions) 
    if (string.len(guiGridListGetItemText(allquestions, row, 3))) < 2 then return end
    guiSetVisible(panel, false)
    guiSetVisible(ekpanel, true)
    addEventHandler('onClientGUIClick', root, function()
        if source == cancel then return guiSetVisible(ekpanel, false), guiSetVisible(panel, true) end 
        if source == send then return guiSetVisible(ekpanel, false), guiSetVisible(panel, true) end 
    end)
    --local item = 'Soru : ' .. getContextFromID(tonumber(split(guiGridListGetItemText(recentQuestions, row, 1), '#')[1])) .. '\n Cevap : ' .. getAnswerFromID(tonumber(split(guiGridListGetItemText(recentQuestions, row, 1), '#')[1]))
    guiSetText(content, 'Soru : ' .. getContextFromID(tonumber(split(guiGridListGetItemText(allquestions, row, 1), '#')[1])) .. '\nCevap : ' .. getAnswerFromID(tonumber(split(guiGridListGetItemText(allquestions, row, 1), '#')[1])))
    guiMemoSetReadOnly(content, true)
end)

    -- adm cevap girme 

ekpanel = guiCreateWindow(821, 395, 235, 172, "Soru Sorma Sistemi - © violence", false)
guiWindowSetSizable(ekpanel, false)

content = guiCreateMemo(9, 32, 216, 91, "Cevabınızı buraya girin.", false, ekpanel)
send = guiCreateButton(9, 130, 102, 32, "Onayla", false, ekpanel)
cancel = guiCreateButton(123, 131, 102, 31, "İptal", false, ekpanel)    
guiMemoSetReadOnly(content, false)

addEventHandler('onClientGUIDoubleClick', recentQuestions, function()
    local row, column = guiGridListGetSelectedItem(recentQuestions) 
    if (string.len(guiGridListGetItemText(recentQuestions, row, 3))) < 2 then return end
    guiSetVisible(panel, false)
    guiSetVisible(ekpanel, true)
    addEventHandler('onClientGUIClick', root, function()
        if source == cancel then return guiSetVisible(ekpanel, false), guiSetVisible(panel, true) end 
        if source == send then return guiSetVisible(ekpanel, false), guiSetVisible(panel, true) end 
    end)
    --local item = 'Soru : ' .. getContextFromID(tonumber(split(guiGridListGetItemText(recentQuestions, row, 1), '#')[1])) .. '\n Cevap : ' .. getAnswerFromID(tonumber(split(guiGridListGetItemText(recentQuestions, row, 1), '#')[1]))
    guiSetText(content, 'Soru : ' .. getContextFromID(tonumber(split(guiGridListGetItemText(recentQuestions, row, 1), '#')[1])) .. '\nCevap : ' .. getAnswerFromID(tonumber(split(guiGridListGetItemText(recentQuestions, row, 1), '#')[1])) .. '\n\nİlgilenen Yetkili : ' .. getStaffFromID(tonumber(split(guiGridListGetItemText(recentQuestions, row, 1), '#')[1])))
    guiMemoSetReadOnly(content, true)
end)

addEventHandler('onClientGUIDoubleClick', avaliableQuestionsL, function()
    local row, column = guiGridListGetSelectedItem(avaliableQuestionsL)
    if (string.len(guiGridListGetItemText(recentQuestions, row, 3))) < 2 then return end
    guiSetVisible(panel, false)
    guiSetVisible(ekpanel, true)
    addEventHandler('onClientGUIClick', root, function()
        if source == cancel then return guiSetVisible(ekpanel, false), guiSetVisible(panel, true) end 
        if source == send then return guiSetVisible(ekpanel, false), guiSetVisible(panel, true) end 
    end)
    guiSetText(content, 'Soru : ' .. getContextFromID(tonumber(split(guiGridListGetItemText(avaliableQuestionsL, row, 1), '#')[1])) .. '\nCevap : ' .. getAnswerFromID(tonumber(split(guiGridListGetItemText(avaliableQuestionsL, row, 1), '#')[1])))
    guiMemoSetReadOnly(content, true)
end)

guiSetVisible(panel, false)

function getContextFromID(id)
    id = tonumber(id)
    for _,v in pairs(avaliableQuestions) do 
        if v.id == id then 
            return v.context
        end  
    end 
end 



function getStaffFromID(id)
    id = tonumber(id)
    for _,v in pairs(avaliableQuestions) do 
        if v.id == id then 
            return v.staffHandled
        end  
    end 
end 

function getAnswerFromID(id)
    id = tonumber(id)
    for _,v in pairs(avaliableQuestions) do 
        if v.id == id then 
            return v.reply
        end  
    end 
end 

addEventHandler('onClientGUIClick', root, function()
    if source == sendQuestion then 
        local question_Entered = guiGetText(editBox) or ""
        if string.len(question_Entered) >= 2 then 
            local attempt = triggerServerEvent('retrieve:Data', getLocalPlayer(), question_Entered, false, guiCheckBoxGetSelected(checkBox))
            if not attempt == true then return outputChatBox('#0000FF[!] #FFFFFFİşlem gerçekleştirilirken sunucudan kaynaklanan bir hata meydana geldi!', 0, 255, 0, true) end 
        else 
            outputChatBox('#0000FF[!] #FFFFFFLütfen soruyu giriniz.', 0, 255, 0, true)
        end 
    end 
    if source == acceptQuestion then 
        local selected = guiGridListGetSelectedItem(avaliableQuestionsL) or nil 
        if selected then 
            guiSetVisible(ekpanel, true)
            guiSetVisible(panel, false)
            guiMemoSetReadOnly(content, false)
            guiSetText(content, 'Cevabınızı buraya giriniz.')
            addEventHandler('onClientGUIClick', root, function()
                if source == cancel then return guiSetVisible(ekpanel, false), guiSetVisible(panel, true) end 
                if source == send then 
                    local reply = guiGetText(content) or ""
                    if string.len(reply) >= 2 then
                        triggerServerEvent('fix:Resource', getLocalPlayer())
                        sendReply(selected, reply)
                        guiSetVisible(panel, true)
                        guiSetVisible(adm_interface, true)
                        guiSetVisible(ekpanel, false)
                    end 
                end 
            end)
        else 
            outputChatBox('#0000FF[!] #FFFFFFBu işlem için bir soru seçmelisin.', 0, 255, 0, true)
        end 
    end
    if source == quit then 
        guiSetVisible(panel, false)
        showCursor(false)
    end 
end)

guiSetVisible(panel, false)
guiSetVisible(ekpanel, false)
guiSetVisible(adm_interface, false)
guiSetInputMode('no_binds_when_editing')

function sendReply(selectedItem, replyed)
    local unpackx, unpacky = selectedItem
    local pl = split(split(split(guiGridListGetItemText(avaliableQuestionsL, unpackx, 2), '('))[2], ')')[1]
    for k, v in pairs(getElementsByType('player')) do 
        if getElementData(v, 'account:username') == pl then 
            triggerServerEvent('send:Output', getLocalPlayer(), v, replyed)
        end
    end 
    triggerServerEvent('sql:Update', getLocalPlayer(), split(guiGridListGetItemText(avaliableQuestionsL, unpackx, 1), '#')[1], replyed)
end 

addCommandHandler('soruyolla', function()
    guiSetVisible(panel, not guiGetVisible(panel))
    showCursor(guiGetVisible(panel))
    if guiGetVisible(panel) == true then 
        triggerServerEvent('staff:rank', getLocalPlayer())
        guiGridListClear(recentQuestions)
        guiGridListClear(avaliableQuestionsL)
        updateUI()
    end 
end)

function updateUI()
        --triggerServerEvent('fix:Resource', getLocalPlayer())
        guiSetVisible(panel, true)
        sayac = 0
        guiGridListClear(recentQuestions)
        guiGridListClear(allquestions)
        for k,v in ipairs(avaliableQuestions) do 
            if guiGridListGetRowCount(recentQuestions) < maxRecordsWillBeShown then 
                if getElementData(getLocalPlayer(), 'account:username') == split(v.sender_Name, '-')[2] then 
                    sayac = sayac + 1
                    if v.staffHandled == "Yok" then 
                        durum = "Bakılmamış"
                    else 
                        durum = "Bakılmış(" .. v.staffHandled .. ')' 
                    end 
                    guiGridListAddRow(recentQuestions, "#".. tostring(v.id), durum, v.timestamp)
                end 
            end 
            if v.seenable == 1 then 
                if v.staffHandled == "Yok" then 
                    durum = "Bakılmamış"
                else 
                    durum = "Bakılmış(" .. v.staffHandled .. ')' 
                end 
                guiGridListAddRow(allquestions, v.id, durum, v.timestamp)
            end 
        end 
        guiSetText(stats, "Şu ana kadar " .. tostring(getAllQuestions()) ..  ' soru soruldu. \nBu soruların ise %' .. tostring(round(getRange())) .. '\'i herkese açık.')
end 

function updateADMUI()
        sayac = 0
        guiGridListClear(avaliableQuestionsL)
        for k,v in ipairs(avaliableQuestions) do 
            if v.reply == 'Yok' and v.staffHandled == 'Yok' then
                sayac = sayac + 1
                guiGridListAddRow(avaliableQuestionsL, "#".. tostring(v.id), split(v.sender_Name, '-')[1].."(" .. split(v.sender_Name, '-')[2] .. ')', v.timestamp)
            end
        end 
end 

addEvent('update:admui', true)
addEventHandler('update:admui', root, function(adm_count)
    guiGridListClear(avaliableQuestionL)
    updateADMUI()
    guiSetText(statsAdmin, 'Aktif Yetkili Sayısı : ' .. tostring(adm_count) .. '\nBekleyen Soru Sayısı : ' .. tostring(guiGridListGetRowCount(avaliableQuestionsL)))
end)

addEvent('show:admui', true)
addEventHandler('show:admui', root, function()
    guiSetVisible(panel2, true)
    showCursor(true)
end)

addEvent('show:isSame', true)
addEventHandler('show:isSame', root, function(cvp, msg)
    guiSetVisible(ekpanel, true)
    guiSetVisible(panel, false)
    guiSetText(content, 'Sorunuza sık sorulan sorularda rastlandı! \n \n Cevap : ' .. cvp .. '\n\nYine de sormak istiyorsanız onayla tuşuna tıklayın, eğer vazgeçtiyseniz iptale tıklayabilirsiniz.')
    guiMemoSetReadOnly(content, true)
    addEventHandler('onClientGUIClick', root, function()
        if source == send then return guiSetVisible(ekpanel, false), guiSetVisible(panel, true), triggerServerEvent('retrieve:Data', getLocalPlayer(), msg, true, guiCheckBoxGetSelected(checkBox)) end
        if source == cancel then return guiSetVisible(ekpanel, false), guiSetVisible(panel, true) end
    end)
end)

