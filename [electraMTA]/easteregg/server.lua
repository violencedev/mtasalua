-- Sistem violence tarafından yapılmış olup, içerisinde hiçbir açık bulunmamaktadır. Sistem geliştirilmeye açık olduğundan ve sistemin asıl yapıldığı sunucu sahibi gereğinden az miktarda para ödemesinden dolayı içerisine kodu kolaylaştıracak ifadelerden çok bazı yerlerde kodun uzamasına dahi sebep olacak şeyler kullanılmıştır. Bilgili bir geliştirici gayet kolay bir şekilde düzenleyip kullanabilir. Bu dosyayı açan herkes istediği yerde paylaşıp kullanabilir.

local mysql = exports["mysql"]

izinli_kisiler = { -- kullanıcı adı
    ["violence"] = true
}

special_rewards={ -- İsimler değiştirilecekse,  71. satırdan başlayan kodun içerisindeki isimler de ona uyarlanmalıdır. Table'dan çekilirse sorun olabileceği için bu şekilde yaptım. mix ve max olayını değiştirmek için ise, (max - min) + 1 = şans yüzdesi şeklinde. En üstten en alta doğru artmakta.
    {name="VIP-1", min=1, max=10},
    {name="VIP-2", min=11, max=17},
    {name="VIP-3", min=18, max=20},
    {name="10-TL-BAKIYE", min=21, max=30},
    {name="15-TL-BAKIYE", min=31, max=37},
    {name="25-TL-BAKIYE", min=38, max=40},
    {name="5-HEDIYE-KUTUSU", min=41, max=50},
    {name="PARA", min=51, max=100}
}

eastereggs={}

function getID() -- Sıradaki son numarasını çekiyor.
    local sira 
    for k,v in ipairs(eastereggs) do 
        sira = sira + 1
    end 
    return sira
end 

function getStampDate() -- Şu anki tarihi çekiyor.
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

function isTranspire(id) -- Listede olup olmadığını kontrol ediyor.
    for k, v in ipairs(eastereggs) do 
        if v then 
            if getElementData(v, 'settings').id == id then 
                return true
            end
        end 
    end 
end 

function getObjectFromID(id) -- easterEgg ID'sinden easterEgg'i çekiyor
    for k, v in ipairs(eastereggs) do 
        if v then 
            local v_id = getElementData(v, 'settings').id 
            if v_id == id then 
                return v
            end 
        end 
    end 
end 

function getPositionFromID(id) -- easterEgg ID'sinden easterEgg table konumunu çekiyor.
    for k, v in ipairs(eastereggs) do 
        if v then
            if (getElementData(v, 'settings').id)~=id then 
                return k
            end 
        end
    end 
end



function chooseReward(pl) -- Kullanıcı için table'la yarı entegreli bir ödül belirliyor. İçerisindeki fonksiyonlarla elleşilebilir, hepsinde return olmak zorundadır. Daha basit bir yol olarak table'lara fonksiyonları ve mysql kodlarını değişken olarak atayabilirsiniz.
    local sans = math.random(1, 100)
    for _, v in pairs(special_rewards) do 
        if sans>=v.min and sans<=v.max then 
            if v.name == "VIP-1" then 
                exports["vip"]:vipver(pl, 1, 30)
                return "VIP I"
            elseif v.name == "VIP-2" then 
                exports["vip"]:vipver(pl, 2, 30)
                return "VIP II"
            elseif v.name == "VIP-3" then
                exports["vip"]:vipver(pl, 3, 30)
                return "VIP III"
            elseif v.name == "10-TL-BAKIYE" then 
                local dbid = getElementData(pl, "account:id")
				local escapedID = (dbid)
				setElementData(pl, "bakiyeMiktar", tonumber(getElementData(pl, "bakiyeMiktar") + 10))
				dbExec(mysql:getConnection(), "UPDATE accounts SET bakiyeMiktari = bakiyeMiktari + 10 WHERE id = '" .. escapedID .. "'")
                return "10 TL OOC Bakiye"
            elseif v.name == "15-TL-BAKIYE" then 
                local dbid = getElementData(pl, "account:id")
				local escapedID = (dbid)
				setElementData(pl, "bakiyeMiktar", tonumber(getElementData(pl, "bakiyeMiktar") + 15))
				dbExec(mysql:getConnection(), "UPDATE accounts SET bakiyeMiktari = bakiyeMiktari + 15 WHERE id = '" .. escapedID .. "'")
                return "15 TL OOC Bakiye"
            elseif v.name == "25-TL-BAKIYE" then 
                local dbid = getElementData(pl, "account:id")
				local escapedID = (dbid)
				setElementData(pl, "bakiyeMiktar", tonumber(getElementData(pl, "bakiyeMiktar") + 25))
				dbExec(mysql:getConnection(), "UPDATE accounts SET bakiyeMiktari = bakiyeMiktari + 25 WHERE id = '" .. escapedID .. "'")
                return "25 TL OOC Bakiye"
            elseif v.name == "5-HEDIYE-KUTUSU" then 
                dbExec(mysql:getConnection(), 'UPDATE characters SET hediyekutusu = ? WHERE id = ?', getElementData(pl, 'hediye:toplam') + 5, getElementData(pl, 'dbid'))
                return "5 Hediye Kutusu"
            else 
                local amount = math.random(100, 10000)
                exports["global"]:giveMoney(pl, amount)
                return ""..amount.." $"
            end 
        end 
    end 
end

addCommandHandler('easteregg', function(pl, cmd, arg, id)  -- Ana komut dizimi
    if arg=="help" then 
        if not (izinli_kisiler[getElementData(pl, 'account:username')]) then 
            return outputChatBox('#FF0000[!] #FFFFFFeasterEgg açmak için [/'..cmd..' kullan]', pl, 0, 255, 0, true)
        end 
        outputChatBox('#FF0000[!] #FFFFFFeasterEgg oluşturmak için : [/'..cmd..' olustur]', pl, 0, 255, 0, true)
        outputChatBox('#FF0000[!] #FFFFFFeasterEgg silmek için : [/'..cmd..' sil <id>]', pl, 0, 255, 0, true)
        outputChatBox('#FF0000[!] #FFFFFFeasterEgg listelemek için : [/'..cmd..' listele]', pl, 0, 255, 0, true)
        outputChatBox('#FF0000[!] #FFFFFFeasterEgg kullanmak için : [/'..cmd..' kullan]', pl, 0, 255, 0, true)
    return end 
    if arg=="olustur" or arg=="create" or arg=="oluştur" then 
        if (izinli_kisiler[getElementData(pl, 'account:username')]) then
            local x, y, z = getElementPosition(pl)
            x = x + 1.75 
            z = z - 1
            local easterEgg = createObject(902, x, y, z)
            local int = getElementInterior(easterEgg)
            local dim = getElementDimension(easterEgg)
            local date = getStampDate()
            local execution = dbExec(mysql:getConnection(), 'INSERT INTO eastereggs(id, x, y, z, interior, dim, olusturan, state, date) VALUES(?,?, ?, ?, ?, ?, ?, ?, ?)', "NAN", x, y, z, int, dim, getPlayerName(pl), 'acilmadi', date)
            if execution == true then 
                table.insert(eastereggs, easterEgg)
                local id
                dbQuery(function(qH)
                    
                    local results = dbPoll(qH, 0)
                    local result = results[1]
                
                    id = result.id + 1
                    local update = dbExec(mysql:getConnection(), 'UPDATE eastereggs SET id = ? WHERE date = ?', id, date)
                    setElementData(easterEgg, 'settings', {state="acilmadi", olusturan=getPlayerName(pl), id=id})
                    outputChatBox('#FF0000[!] #FFFFFFBaşarıyla bir adet [EasterEgg / ID : '..(id)..'] oluşturuldu!', pl, 0, 255, 0, true)
                end, mysql:getConnection(), 'SELECT id FROM eastereggs ORDER BY id DESC LIMIT 1')
                
            else 
                destroyElement(easterEgg)
                outputChatBox('#FF0000[!] #FFFFFFSunucudan kaynaklı bir hatadan dolayı easteregg oluşturulamadı.', pl, 0, 255, 0, true)
            end 
        end 
    return end 
    if arg=="listele" or arg == "list" then 
        if (izinli_kisiler[getElementData(pl, 'account:username')]) then
            for k, v in ipairs(eastereggs) do 
                local x, y, z = getElementPosition(v)
                local id = getElementData(v, 'settings').id
                local olusturan = getElementData(v, 'settings').olusturan
                outputChatBox('#FF0000[!] #FFFFFF [#'..(id)..'] | '..x..', '..y..', '..z..' | ['..getZoneName(x, y, z)..'] | '..(olusturan)..'', pl, 0, 255, 0, true)
            end 
        end 
    return end
    if arg=="sil" or arg=="delete" then 
        if (izinli_kisiler[getElementData(pl, 'account:username')]) or (getElementData(pl, 'ufakizin') or false) == true then
            if id then 
                if isTranspire(tonumber(id)) == true then 
                    local delete2 = destroyElement(getObjectFromID(tonumber(id)))
                    local delete = dbExec(mysql:getConnection(), 'DELETE FROM eastereggs WHERE id = ?', id)
                    table.remove(eastereggs, getPositionFromID(tonumber(id)))
                    if delete == true then 
                        if not getElementData(pl,'ufakizin') == true then
                            outputChatBox('#FF0000[!] #FFFFFFBaşarıyla [EasterEgg / ID : '..(id)..'] silindi.', pl, 0, 255, 0, true)
                        end
                        setElementData(pl, 'ufakizin', false)
                    else 
                        outputChatBox('#FF0000[!] #FFFFFFSunucudan kaynaklı bir hatadan dolayı easteregg silinemedi.', pl, 0, 255, 0, true)
                    end 
                else 
                    outputChatBox('#FF0000[!] #FFFFFFBöyle bir ID bulunamadı.', pl, 0, 255, 0, true)
                end
            else 
                outputChatBox('#FF0000[!] #FFFFFFID girmediniz.', pl, 0, 255, 0, true)
            end 
        end 
    return end
    if arg=="kullan" or arg=="ac" or arg=="aç" then 
        for _,v in pairs(eastereggs) do 
                local x, y, z = getElementPosition(v)
                local shape = createColSphere(x, y, z, 3) 
                if isElementWithinColShape(pl, shape) == true then
                    local reward = chooseReward(pl)
                    if reward then 
                        outputChatBox('#FF0000[!] #FFFFFF Başarıyla ['..reward..'] ödülünüz verildi!', pl, 0, 255, 0, true)
                        local id = getElementData(v, 'settings').id
                        local delete = dbExec(mysql:getConnection(), 'DELETE FROM eastereggs WHERE id = ?', tonumber(id))
                        restartResource(getThisResource())
                        break
                    end 
                end 
        end  
    return end 
    executeCommandHandler('easteregg', pl, 'help')
end)

function loadAllEasterEggs(qH) -- easteregg render
    local results = dbPoll(qH, 0)
    for k, v in ipairs(results) do 
        local easterEgg = createObject(902, v.x, v.y, v.z)
        setElementData(easterEgg, 'settings', {state=v.state, olusturan=v.olusturan, id=v.id})
        table.insert(eastereggs, easterEgg)
    end 
end 

function loadRequest() -- render request
    dbQuery(loadAllEasterEggs, mysql:getConnection(), 'SELECT * FROM eastereggs')
end
addEventHandler('onResourceStart', resourceRoot, loadRequest)