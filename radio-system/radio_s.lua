addCommandHandler('frekansbaglan', function(pl, cmd, kod)
    if not exports["global"]:hasItem(pl, 241, 1) then return outputChatBox('#0000FF[!] #FFFFFFBu işlem için bir adet telsiziniz olmalıdır.', pl, 0, 255, 0, true), setElementData(pl, 'radio:code', nil), removePlayerFromSpecificRadio(pl) end
    if not kod then return outputChatBox('#0000FF[!] #FFFFFFLütfen bir frekans kodu giriniz!', pl, 0, 255, 0, true) end 
    local factid = getElementData(pl, 'faction') or 0
    if not isFactionContainsCode(kod, factid) == true then return outputChatBox('#0000FF[!] #FFFFFF Bu radyoya katılamazsınız!', pl, 0, 255, 0, true) end
    if isRadiosSame(pl, kod) == true then return outputChatBox('#0000FF[!] #FFFFFF Zaten bu radyodasınız!', pl, 0, 255, 0, true) end
    outputChatBox('#FF0000[!] #FFFFFFBaşarıyla [' .. kod .. '] frekans kodlu radyoya bağlandınız.', pl, 0, 255, 0, true)
    exports.global:sendLocalMeAction(pl, "radyosunun frekans ayarlarını yapar.")
    setElementData(pl, 'radio:code', kod)
    updateTable(pl, kod, factid)
    sendToRadioUsers(pl, 'joined')
end)

function sendToRadioUsers(pl, status)
    if status == 'joined' then 
        msg = "** [CH:" .. getElementData(pl, 'radio:code') .. "] " .. getPlayerName(pl):gsub("_", " ") .. ": ^^Radyoya Katılma Sesleri^^ **"
    end 
    for _,v in ipairs(returnUsersFromPlayer(pl)) do 
        outputChatBox(msg, getPlayerFromName(v), 237, 216, 97, false)
    end 
end 


function updateTable(pl, code, faction)
    for _,v in pairs(frekanslar) do 
        if v.frekanskodu == tostring(code) then 
            table.insert(v.users, getPlayerName(pl))
        end 
    end 
end 

function isFactionContainsCode(code, faction)
    for _,v in pairs(frekanslar) do 
        if v.frekanskodu == tostring(code) then 
            if tonumber(faction) == v.faction_id then 
                return true
            else 
                if not type(v.faction_id) == "table" then return end 
                for _,j in pairs(v.faction_id) do 
                    if tonumber(j) == tonumber(faction) then 
                        return true
                    end 
                end 
            end 

        end 
    end 
end 

function removePlayerFromSpecificRadio(player)
    for _,v in pairs(frekanslar) do 
        for _,j in pairs(v.users) do 
            if j == getPlayerName(player) then 
                table.remove(v.users, j)
            end 
        end 
    end 
end 

function isRadiosSame(pl, code)
    for _,v in pairs(frekanslar) do 
        if v.frekanskodu == code then 
            for _,j in pairs(v.users) do 
                if j == getPlayerName(pl) then 
                    return true
                end 
            end 
        end 
    end 
end 

function round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function returnUsersFromPlayer(pl) 
    statistic = {}
    for _,v in pairs(frekanslar) do 
        if v.frekanskodu == getElementData(pl, 'radio:code') then 
            for _,j in pairs(v.users) do 
                if getPlayerFromName(j) then 
                    table.insert(statistic, j)
                end 
            end 
        end 
    end 
    return statistic
end 

function hashMessage(tablo)
    yeni = {}
    for _,v in pairs(tablo) do 
        local cansik = math.random(1, 2)
        if cansik == 1 then 
            -- şifrele
            table.insert(yeni, stringBul(v))
        else 
            -- şifreleme
            table.insert(yeni, v)
        end 
    end 
    return yeni
end 

function stringBul(str)
    tablo = {}
    str:gsub(".",function(c) table.insert(tablo,c) end)
    for k,v in ipairs(tablo) do 
        tablo[k] = '^'
    end 
    return table.concat(tablo, '')
end 

addEvent('retrieve:Data', true)
addEventHandler('retrieve:Data', root, function()
    if returnUsersFromPlayer(client) then 
        tablo = {}
        local factionRanks = getElementData(getPlayerTeam(client), "ranks")
        for _,v in pairs(returnUsersFromPlayer(client)) do 
            local factionRank = tonumber(getElementData(getPlayerFromName(v),"factionrank"))
            local factionRankTitle = factionRanks[factionRank]
            table.insert(tablo, v .. ' | ' .. factionRankTitle)
        end 
        setElementData(client, 'beynimisikeyimbunuyapan', table.concat(tablo, '\n'))
    end
end)


addCommandHandler('radyo', function(pl, cmd, ...)
    if not exports["global"]:hasItem(pl, 241, 1) then return outputChatBox('#0000FF[!] #FFFFFFBu işlem için bir adet telsiziniz olmalıdır.', pl, 0, 255, 0, true), setElementData(pl, 'radio:code', nil), removePlayerFromSpecificRadio(pl) end
    local msg = {...}
    if not getElementData(pl, 'radio:code') then return outputChatBox('#0000FF[!] #FFFFFFHerhangi bir radyoda değilsiniz.', pl, 0, 255, 0, true) end
    if not msg then return outputChatBox('#0000FF[!] #FFFFFFMesaj girmediniz.', pl, 0, 255, 0, true) end
    if string.len(table.concat(msg, ' ')) == "" then return outputChatBox('#0000FF[!] #FFFFFFMesaj girmediniz.', pl, 0, 255, 0, true) end
    local factionRank = tonumber(getElementData(pl,"factionrank"))
    local factionRanks = getElementData(getPlayerTeam(pl), "ranks")
    local factionRankTitle = factionRanks[factionRank]
    exports.global:sendLocalMeAction(pl, "radyonun mandalına basarak konuşmaya başlar.")
    for _,k in ipairs(returnUsersFromPlayer(pl)) do 
        outputChatBox("** [CH:" .. getElementData(pl, 'radio:code') .. '] ' .. factionRankTitle  .. " " .. getPlayerName(pl):gsub("_", " ") .. ': ' .. table.concat(msg, " ") .. ' **', getPlayerFromName(k), 237, 216, 97, false)
        exports.global:sendLocalText(getPlayerFromName(k), "** ((" .. k .. '\'in radyosu)) ' .. table.concat(hashMessage(msg), " ") .. ' **', 255, 155, 0, 30, {}, true, false, true)    
    end 
end)

addEventHandler('onResourceStart', resourceRoot, function(pl, cmd)
    for _,v in ipairs(getElementsByType('player')) do 
        setElementData(v, 'radio:code', nil)
    end 
end)