local mysql = exports["mysql"]:getConnection()

sikSorulanlar = {
    {keyword="meslek", exp='Meslek yapmak için /meslekbilgi yazabilirsiniz.'},
    {keyword='alım', exp='Admin ve legal birlik alımları DC üzerinden yapılacaktır.'},
    {keyword='mal varlık', exp='Mal varlık verilme olayları DC üzerinden yapılmaktadır.'},
    {keyword='konsept', exp='Sunucu konsepti hard, medium, yabancı.'}
}
isGoOffDuty = false
avaliableQuestions = {}

function getStampDate()
    local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second

    local monthday = time.monthday
	local month = time.month
	local year = time.year

    local formattedTime = string.format("%02d/%02d/%04d %02d:%02d:%02d", monthday, month + 1, year + 1900, hours, minutes, seconds)
    return formattedTime
end 


function getStaffCount()
    sayac = 0
    for _,v in ipairs(getElementsByType('player')) do 
        if exports["integration"]:isPlayerStaff(v) == true then 
            sayac = sayac + 1
        end 
    end 
    return sayac
end 

function getID(whom)
    for _,v in pairs(avaliableQuestions) do 
        if v.sender_Name == whom then 
            return v.id 
        end 
    end 
end 

function strFind(sub, fix)
    for _,v in pairs(split(sub, ' ')) do 
        if string.lower(v) == string.lower(fix) then 
            return true
        end 
    end 
end 

function isBelongToSikSorulanlar(msg)
    for _,v in pairs(sikSorulanlar) do 
        if strFind(msg, v.keyword) == true then 
            return true
        end 
    end 
end 

function getCVP(msg)
    for _,v in pairs(sikSorulanlar) do  
        if strFind(msg, v.keyword) == true then 
            return v.exp
        end 
    end 
end 

addEvent('retrieve:Data', true)
addEventHandler('retrieve:Data', root, function(message, sperm, checked)
    if (isBelongToSikSorulanlar(message) == true) and (not sperm == true) then return triggerClientEvent('show:isSame', client, getCVP(message), message) end
    if checked == true then 
        checked = 1 
    else 
        checked = 0
    end 
    local date = getStampDate()
    local senderName = (getPlayerName(client) .. '-' .. getElementData(client, 'account:username'))
    exports["global"]:sendMessageToStaff("#0000FF[!] #FFFFFF" .. getPlayerName(client) .. "(" .. getElementData(client, 'account:username') .. ")isimli oyuncu bir soru gönderdi, lütfen bakınız!", isGoOffDuty)
    --table.insert(avaliableQuestion, {sender_Name = (getPlayerName(client) .. '-' .. getElementData(client, 'account:username')), context = message, timestamp = date, staffHandled = nil})
    local insert_into_database = dbExec(mysql, 'INSERT INTO sorusor(sender_Name, context, timestamp, staffHandled, reply, seenable) VALUES(?, ?, ?, ?, ?, ?)', senderName, message, date, 'Yok', 'Yok', checked)
    if insert_into_databae == false then return outputDebugString('[sorusor] sql\'e veri kaydedilemedi.', 2) end 
    avaliableQuestions = {}
    dbQuery(function(qH)
        local results = dbPoll(qH, 0)
        for _,v in pairs(results) do 
            table.insert(avaliableQuestions, {id = v.id, sender_Name = v.sender_Name, context = v.context, timestamp = v.timestamp, staffHandled = v.staffHandled, reply = v.reply, seenable = v.seenable})
            triggerClientEvent('update:Client', root, avaliableQuestions)
            triggerClientEvent('update:admui', root, getStaffCount())
        end 
    end, mysql, 'SELECT * FROM sorusor')

end)

addEvent('sql:Update', true)
addEventHandler('sql:Update', root, function(whom, updated)
    local edited = whom
    local execute = dbExec(mysql, 'UPDATE sorusor SET staffHandled = ?, reply = ? WHERE id = ?', getElementData(client, 'account:username'), updated, tonumber(edited))
    if execute == false then return outputDebugString('[sorusor] mysql hatasi.', 2) end 
    avaliableQuestions = {}
    dbQuery(function(qH)
        local results = dbPoll(qH, 0)
        for _,v in pairs(results) do 
            table.insert(avaliableQuestions, {id = v.id, sender_Name = v.sender_Name, context = v.context, timestamp = v.timestamp, staffHandled = v.staffHandled, reply = v.reply, seenable = v.seenable})
        end 
        triggerClientEvent('update:Client', root, avaliableQuestions)
        triggerClientEvent('update:admui', root, getStaffCount())
    end, mysql, 'SELECT * FROM sorusor')
end)

addEvent('send:Output', true)
addEventHandler('send:Output', root, function(toWho, msg)
    outputChatBox('#0000FF[!] #FFFFFFBir sorunuza cevap geldi!', toWho, 0, 255, 0, true)
end)

addEvent('staff:rank', true)
addEventHandler('staff:rank', root, function(pl)
    local durum = exports["integration"]:isPlayerStaff(pl)
    if durum == true then 
        triggerClientEvent('update:admui', pl, getStaffCount())
        triggerClientEvent('show:admui', pl)
    end 
end)

addEvent('fix:Resource', true)
addEventHandler('fix:Resource', root, function()
    restartResource(getThisResource())
end)
addEventHandler('onResourceStart', resourceRoot, function()
    dbQuery(function(qH)
        local results = dbPoll(qH, 0)
        avaliableQuestions = results
        triggerClientEvent('update:Client', root, avaliableQuestions)
    end, mysql, 'SELECT * FROM sorusor')
end)


addCommandHandler('sorularilistele', function(pl, cmd)
    triggerEvent('staff:rank', pl, pl)
end)