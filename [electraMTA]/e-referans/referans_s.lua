local mysql = exports["mysql"] 
miktar = 100 -- bi kişi başına verilcek para
maxkod = 3 -- bi herif kaç tane açabilir kod

referanslar = {
    -- örnek : {isim="deneme", olusturankullanici='violence', olusturankarakter = "Beta_Player", kullanimsayisi = 0, kullanankullanicilar="", olusturulmatarihi="4/12/2021-18:00", bekleyenpara=0}
}

-- builtin functions

function getStampDate()
    local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second

    local monthday = time.monthday
	local month = time.month
	local year = time.year

    local formattedTime = string.format("%02d/%02d/%04d-%02d:%02d", monthday, month + 1, year + 1900, hours, minutes)
    return formattedTime
end 

function isTranspire(kod)
    for k, v in pairs(referanslar) do 
        if v.isim == kod then 
            return true
        end 
    end 
end 

function kodOlustur()
    local res = ""
    length = math.random(5, 8)
    for i = 1, length do
        res = res .. string.upper(string.char(math.random(97, 122)))
    end
    
    if not isTranspire(res) == true then
        return res
    else 
        kodOlustur() 
    end 
end

function getIndexFromCode(code)
    for k, v in ipairs(referanslar) do 
        if v.isim == code then 
            return k
        end 
    end 
end 

function isInRange(player) 
    local index = 0
    for k, v in pairs(referanslar) do 
        if v.olusturankullanici == getElementData(player, 'account:username') then 
            index = index+1
        end 
    end 
    if index==maxkod then 
        return false 
    else 
        return true
    end 
end 

function hasPlayerReference(player, code)
    for k, v in pairs(referanslar) do  
        if v.isim == code then 
            if v.olusturankullanici == getElementData(player, 'account:username') then 
                return true
            end 
        end 
    end 
end 

function hasMoneyInCase(code)
    for k, v in pairs(referanslar) do 
        if v.bekleyenpara > 0 then 
            return true
        end 
    end 
end 

function hasAtLeastOneReference(player)
    for k, v in pairs(referanslar) do 
        if v then 
            return true
        end 
    end 
end 


function allIncomes(player) 
    local para = 0
    for k, v in pairs(referanslar) do 
        if v.olusturankullanici == getElementData(player, 'account:username') then
            para = para + v.bekleyenpara
        end
    end 
    return para
end 

function getIncome(kode)
    for k, v in pairs(referanslar) do 
        if v.isim == kode then 
            return v.bekleyenpara
        end 
    end 
end 

function referansKoduGuncelle(player, kod, tarih)
    for k, v in pairs(referanslar) do 
        if v.isim == kod then 
            v.kullanimsayisi = v.kullanimsayisi + 1
            v.kullanankullanicilar = v.kullanankullanicilar .. "," .. getPlayerName(player) .. "|" .. tarih
            v.bekleyenpara = v.bekleyenpara + 100
            dbExec(mysql:getConnection(), 'UPDATE referanslar SET kullanimsayisi = ?, kullanankullanicilar = ?, bekleyenpara = ? WHERE isim = ?', v.kullanimsayisi, v.kullanankullanicilar, v.bekleyenpara, v.isim)
        end 
    end 
end 

function setIncome(player, hangisi)

    if hangisi == 'hepsi' then 
        dbExec(mysql:getConnection(), 'UPDATE referanslar SET bekleyenpara = ? WHERE olusturankullanici = ?', 0, getElementData(player, 'account:username'))
        for k, v in pairs(referanslar) do 
            if v.olusturankullanici == getElementData(player, 'account:username') then 
                v.bekleyenpara = 0
            end 
        end 
    else 
        for k, v in pairs(referanslar) do 
            if v.isim == hangisi then 
                v.bekleyenpara = 0
                dbExec(mysql:getConnection(), 'UPDATE referanslar SET bekleyenpara = ? WHERE isim = ?', v.bekleyenpara, v.isim)
            end 
        end 
    end 
    

end 

-- command prompt & execution

addCommandHandler('referans', function(player, cmd, secondarg, thirdarg, fourtharg)


    if secondarg == 'help' then 
        outputChatBox('#0000FF[!] #FFFFFF/'..cmd..' olustur - Referans kodu oluşturursunuz.', player, 0, 255, 0, true)
        outputChatBox('#0000FF[!] #FFFFFF/'..cmd..' sil - Referans kodu silersiniz.', player, 0, 255, 0, true)
        outputChatBox('#0000FF[!] #FFFFFF/'..cmd..' listele - Referans kodlarını listelersiniz.', player, 0, 255, 0, true)
        outputChatBox('#0000FF[!] #FFFFFF/'..cmd..' kullan - Referans kodu kullanırsınız.', player, 0, 255, 0, true)
        outputChatBox('#0000FF[!] #FFFFFF/'..cmd..' kasa - Referans kodlarınızdan gelen paraları toplarsınız.', player, 0, 255, 0, true)
        outputChatBox('#0000FF[!] #FFFFFF/'..cmd..' kullananlarım - Referans kodlarınızı kullananları görürsünüz.', player, 0, 255, 0, true)
        outputChatBox('')
        if tostring(getElementData(player, 'referans:kullandi')) == "0" then
            outputChatBox('#0000FF[!] #FFFFFFReferans kodu kullanmamışsın.', player, 0, 255, 0, true)
        else 
            local kod, tarih = split(getElementData(player, 'referans:kullandi'), '|')[1], split(getElementData(player, 'referans:kullandi'), '|')[2]
            outputChatBox('#0000FF[!] #FFFFFFKullandığın Kod : ' .. kod .. ' & Tarih : ' .. tarih, player, 0, 255, 0, true)
        end 
    elseif secondarg == 'olustur' then 
        if isInRange(player) == true then
            local kod = kodOlustur()
            if dbExec(mysql:getConnection(), 'INSERT INTO referanslar(isim, olusturankullanici, olusturankarakter, kullanimsayisi, kullanankullanicilar, olusturulmatarihi, bekleyenpara) VALUES(?, ?, ?,?, ?, ?, ?)', kod, getElementData(player, 'account:username'), getPlayerName(player), 0, "", getStampDate(), 0) == true then 
                table.insert(referanslar, {isim=kod, olusturankullanici=getElementData(player, 'account:username'), olusturankarakter=getPlayerName(player), kullanimsayisi=0, kullanankullanicilar="", olusturulmatarihi=getStampDate(), bekleyenpara=0})
                outputChatBox('#0000FF[!] #FFFFFFBaşarıyla referans kodunuz oluşturuldu! [' .. kod .. ']', player, 0, 255, 0, true)
                outputChatBox('#0000FF[!] #FFFFFFKodu her birisi [/'..cmd..' kullan '..kod..'] şeklinde kullandığında, '..miktar..' $ kazanacaksınız!', player, 0, 255, 0, true)
                outputChatBox('#0000FF[!] #FFFFFFParalar kasanızda birikecek, kasanızı görüntülemek için [/'..cmd..' kasa]', player, 0, 255, 0, true)
            else
                outputChatBox('#0000FF[!] #FFFFFFSunucudan kaynaklı bir hatadan dolayı işleminiz gerçekleştirilemedi.', player, 0, 255, 0, true)
            end 
        else 
            outputChatBox('#0000FF[!] #FFFFFFMaksimum referans kodu oluşturma sınırını aşamazsın.', player, 0, 255, 0, true)
        end 
    elseif secondarg == 'sil' then 
        if thirdarg then 
            if isTranspire(thirdarg) == true and hasPlayerReference(player, thirdarg) == true then 
                if not hasMoneyInCase(thirdarg) == true then 
                    if dbExec(mysql:getConnection(), 'DELETE FROM referanslar WHERE isim = ?', thirdarg) == true then 
                        table.remove(referanslar, getIndexFromCode(thirdarg))
                        outputChatBox('#0000FF[!] #FFFFFFBaşarıyla referans kodunuz ['..thirdarg..'] silindi!', player, 0, 255, 0, true)
                    else 
                        outputChatBox('#0000FF[!] #FFFFFFSunucudan kaynaklı bir hatadan dolayı işleminiz gerçekleştirilemedi.', player, 0, 255, 0, true)
                    end 
                else 
                    outputChatBox('#0000FF[!] #FFFFFFBu referans kodunun kasa paranızda katkısı varken bunu silemezsiniz, kasadaki paralarınızı ya da kod paranızı toplayın. [/'..cmd..' kasa]', player, 0, 255, 0, true)
                end 
            else 
                outputChatBox('#0000FF[!] #FFFFFFBöyle bir koda sahip değilsiniz.', player, 0, 255, 0, true)
            end 
        end
    elseif secondarg == 'listele' then 
        if hasAtLeastOneReference(player) == true then 
            for k, v in ipairs(referanslar) do 
                if v.olusturankullanici == getElementData(player, 'account:username') then 
                    outputChatBox('#0000FF[!] #FFFFFF#' .. k .. ' - ' .. (v.isim) .. ' - ' .. (v.olusturankarakter) .. ' - ' .. (v.kullanimsayisi) .. ' kişi kullandı - ' .. (v.bekleyenpara) ..'$ bekleyen para', player, 0, 255, 0, true)
                end 
            end 
        else 
            outputChatBox('#0000FF[!] #FFFFFFHiçbir referans kodunuz yok!', player, 0, 255, 0, true)
        end 
    elseif secondarg == 'kullan' then 
        if thirdarg then 
            if tostring(getElementData(player, 'referans:kullandi')) == "0" then 
                setElementData(player, 'referans:kullandi', thirdarg .. '|' .. getStampDate())
                referansKoduGuncelle(player, thirdarg, getStampDate())
                outputChatBox('#0000FF[!] #FFFFFFBaşarıyla referans kodunu kullandın ve ' .. miktar .. ' $ aldın!', player, 0, 255, 0, true)
                exports["global"]:giveMoney(player, miktar)
                dbExec(mysql:getConnection(), 'UPDATE accounts SET referanslandi = ? WHERE username = ?', thirdarg .. '|' .. getStampDate(), getElementData(player, 'account:username') )
            else 
                outputChatBox('#0000FF[!] #FFFFFFDaha önce başka bir kodla bu komudu kullanmışsın.', player, 0, 255, 0, true)
            end 
        else 
            outputChatBox('#0000FF[!] #FFFFFFKullanacağın referans kodunu girmedin!', player, 0, 255, 0,true)
        end 
    elseif secondarg == 'kasa' then 
        if not thirdarg then 
            executeCommandHandler('referans', player, 'listele')
            outputChatBox('#0000FF[!] #FFFFFFToplam alacağın : ' .. allIncomes(player) .. '$', player, 0, 255, 0, true)
        elseif thirdarg == 'hepsinitopla' then
            if allIncomes(player) > 0 then 
                outputChatBox('#0000FF[!] #FFFFFFBütün referans kodlarına ait paraları topladın.[+' .. allIncomes(player) .. '$]', player, 0, 255, 0, true)
                exports["global"]:giveMoney(player, allIncomes(player))
                setIncome(player, 'hepsi')
            else 
                outputChatBox('#0000FF[!] #FFFFFFToplayabileceğin hiçbir para yok.', player, 0, 255, 0, true)
            end 
        elseif thirdarg == 'topla' then
            if fourtharg then 
                if hasPlayerReference(player, fourtharg) == true then 
                    if getIncome(fourtharg) > 0 then 
                        outputChatBox('#0000FF[!] #FFFFFF '..fourtharg..' isimli referans koduna ait paraları topladın.[+' .. getIncome(fourtharg) .. '$]', player, 0, 255, 0, true)
                        exports["global"]:giveMoney(player, getIncome(fourtharg))
                        setIncome(player, fourtharg)
                    else 
                        outputChatBox('#0000FF[!] #FFFFFFToplayabileceğin hiçbir para yok.', player, 0, 255, 0, true)
                    end 
                else 
                    outputChatBox('#0000FF[!] #FFFFFFBöyle bir referans kodu bulunamadı.', player, 0, 255, 0, true)
                end 
            else 
                outputChatBox('#0000FF[!] #FFFFFFReferans kodunu girin.', player, 0, 255, 0, true)
            end 
        else 
            executeCommandHandler('referans', player, 'kasa')
        end
    elseif secondarg == 'kullananlarım' then 
        triggerClientEvent(player, 'paneli:olustur', player, player, referanslar)
    else
        executeCommandHandler('referans', player, 'help')
    end
end)

-- mysql integration

function sendLoadingRequest()
    dbQuery(function(qH)
        local results = dbPoll(qH, 0)
        for k, v in pairs(results) do 
            table.insert(referanslar, {isim=v.isim, olusturankullanici=v.olusturankullanici,olusturankarakter=v.olusturankarakter, kullanimsayisi=v.kullanimsayisi, kullanankullanicilar=v.kullanankullanicilar, olusturulmatarihi=v.olusturulmatarihi, bekleyenpara=v.bekleyenpara})
        end 
    end, mysql:getConnection(), 'SELECT * FROM referanslar')
end 
addEventHandler('onResourceStart', resourceRoot, sendLoadingRequest)
