mysql = exports["mysql"]
kuponlar = {}

function loadAll(queryHandle)
    local results = dbPoll(queryHandle, 0)
    kuponlar = {}
    for key, value in pairs(results) do 
        table.insert(kuponlar, {sahip=value.sahip, kullanimsayisi=value.kullanimsayisi, kod=value.kod, reward=value.odul, maxkullanim=value.maxkullanim, kullananlar=value.kullananlar})
    end 
end 

function requestToLoad()
    dbQuery(loadAll, mysql:getConnection(), 'SELECT * FROM kuponkodlari')
end 
addEventHandler('onResourceStart', resourceRoot, requestToLoad)

function findItem(kod)
    for k, v in pairs(kuponlar) do 
        if v.kod == kod then 
            return true
        end 
    end 
end 
 
function findIndex(kod)
    for k, v in pairs(kuponlar) do 
        if v.kod == kod then 
            return k
        end 
    end 
end 

function tableLenght()
    len = 0
    for k, v in pairs(kuponlar) do 
        len = len + 1
    end 
    return len
end 

function maxDedector(kod)
    for k, v in pairs(kuponlar) do 
        if v.kod == kod then 
            if (v.maxkullanim - v.kullanimsayisi) >= 1 then 
                return true
            else 
                if v.maxkullanim == -1 then 
                    return true 
                else 
                    return false
                end 
            end 
        end 
    end 
end 

function veriCek(neyden, neyi)
    for k, v in pairs(kuponlar) do 
        if v.kod == neyden then 
            if neyi == "odul" then 
                return v.reward 
            end
            if neyi == "sahip" then 
                return v.sahip
            end
            if neyi == "kullanimsayisi" then 
                return v.kullanimsayisi 
            end
            if neyi == "maxkullanim" then 
                return v.maxkullanim
            end
            if neyi == 'kullananlar' then 
                return v.kullananlar
            end
        end 
    end 
end 



function lookItUp(table, item)
    for k, v in pairs(table) do 
        if v == item then 
            return true
        end 
    end
end

function kodOlustur()
    local res = ""
    length = math.random(5, 8)
    for i = 1, length do
        res = res .. string.char(math.random(97, 122))
    end
    return res
end

addCommandHandler('kupon', function(pl, cmd, arg, scarg, targ, farg)

    if arg == "help" or arg == "yardim" or arg == "yard??m" then 
        outputChatBox('#FF0000[!] #FFFFFFB??yle bir komut bulunamad??. Kupon kullanmak i??in [/kupon kullan <kupon kodunuz>]', pl, 0, 255, 0, true)
    return end 
    if arg == "olustur" or arg == "create" or arg == "olu??tur" then 
        if (exports.integration:isPlayerHeadAdmin(pl)) then 
            if scarg then
                kod = scarg 
            else 
                kod = kodOlustur()
            end 
            if not findItem(scarg) == true then
                if not targ or not tonumber(targ) then 
                    targ = math.random(100, 1000)
                end 
                if not farg or farg == 0 or not tonumber(farg) then 
                    farg = -1 
                end 
                maxkullanim = farg
                odul = targ
                local insert = dbExec(mysql:getConnection(), "INSERT INTO kuponkodlari(sahip, kullanimsayisi, kod, odul, maxkullanim) VALUES(?, ?, ?, ?, ?)", getPlayerName(pl), 0, kod, tonumber(odul), tonumber(maxkullanim))
                if insert == true then 
                    outputChatBox('#FF0000[!] #FFFFFFBa??ar??yla kupon kodunuz olu??turulmu??tur.', pl, 0, 255, 0, true)
                    requestToLoad()
                else 
                    outputChatBox('#FF0000[!] #FFFFFFKod olu??turulurken sistemsel bir hata meydana geldi. L??tfen tekrar deneyiniz.', pl, 0, 255, 0, true)
                end 
            else 
                outputChatBox('#FF0000[!] #FFFFFFB??yle bir kupon kodu zaten mevcut.', pl, 0, 255 ,0, true)
            end 
        else 
            outputChatBox('#FF0000[!] #FFFFFFYetkiniz bu i??lem i??in yeterli de??il.', pl, 0, 255, 0, true)
        end 
    return end
    if arg == "listele" or arg == "list" then 
        if (exports.integration:isPlayerHeadAdmin(pl)) then 
            if tableLenght() >= 1 then
                for k, v in pairs(kuponlar) do 
                    outputChatBox('#0000FF[!] #FFFFFF'..(v.kod)..' | '..(v.sahip)..' | '..(v.kullanimsayisi)..' kullan??m | '..(v.reward)..' $', pl, 0, 255, 0, true)
                end
            else 
                outputChatBox('#FF0000[!] #FFFFFFHi??bir kupon kodu bulunamad??!', pl, 0, 255, 0, true)
            end 
        else 
            outputChatBox('#FF0000[!] #FFFFFFYetkiniz bu i??lem i??in yeterli de??il.', pl, 0, 255, 0, true)
        end 
    return end 
    if arg == "kald??r" or arg == "kaldir" or arg == "remove" then 
        if (exports.integration:isPlayerHeadAdmin(pl)) then 
            if scarg then 
                if findItem(scarg) == true then 
                    table.remove(kuponlar, findIndex(scarg))
                    local insert = dbExec(mysql:getConnection(), 'DELETE FROM kuponkodlari WHERE kod = "'..(scarg)..'"')
                    if insert == true then 
                        outputChatBox('#FF0000[!] #FFFFFFBa??ar??yla kupon kodu silindi.', pl, 0, 255, 0, true)
                        requestToLoad()
                    else 
                        outputChatBox('#FF0000[!] #FFFFFFKod silinirken sistemsel bir hata meydana geldi. L??tfen tekrar deneyiniz.', pl, 0, 255, 0, true)
                    end 
                else 
                    outputChatBox('#FF0000[!] #FFFFFFB??yle bir kod bulunamad??.', pl, 0, 255, 0, true)
                end 
            else 
                outputChatBox('#FF0000[!] #FFFFFFKodu girmediniz.', pl, 0, 255, 0, true)
            end 
        else 
            outputChatBox('#FF0000[!] #FFFFFFYetkiniz bu i??lem i??in yeterli de??il.', pl, 0, 255, 0, true)
        end 
    return end 
    if arg == "kullan" or arg == "use" then 
        if scarg then 
            if findItem(scarg) == true then 
                if maxDedector(scarg) == true then 
                    if not lookItUp(split(veriCek(scarg, 'kullananlar'), ','), getElementData(pl, 'account:username')) == true then
                        local islem = dbExec(mysql:getConnection(), "UPDATE kuponkodlari SET kullanimsayisi = ? WHERE kod = ?", veriCek(scarg, 'kullanimsayisi') + 1, scarg)
                        if string.len(veriCek(scarg, 'kullananlar')) < 2 then 
                            local islem2 = dbExec(mysql:getConnection(), "UPDATE kuponkodlari SET kullananlar = ? WHERE kod = ?", getElementData(pl, 'account:username'), scarg)
                        else 
                            local islem3 = dbExec(mysql:getConnection(), "UPDATE kuponkodlari SET kullananlar = ? WHERE kod = ?", ""..(veriCek(scarg, 'kullananlar'))..","..(getElementData(pl, 'account:username')).."", scarg)
                        end 
                        if islem == true then
                            exports.global:giveMoney(pl, veriCek(scarg, 'odul'))
                            outputChatBox('#FF0000[!] #FFFFFFBa??ar??yla kupon kodunu kulland??n??z ve hesab??n??za ['..(veriCek(scarg, 'odul'))..'] $ geldi.', pl, 0, 255, 0, true)
                        else 
                            outputChatBox('#FF0000[!] #FFFFFFSunucu kaynakl?? bir hatadan dolay?? kupon kodunu kullanam??yorsunuz. L??tfen tekrar deneyiniz.', pl, 0, 255, 0, true)
                        end
                        requestToLoad() 
                    else 
                        outputChatBox('#FF0000[!] #FFFFFFMaalasef bu kodu daha ??nce kulland??????n??z i??in bir daha kullanam??yorsunuz!', pl, 0, 255, 0, true)
                    end 
                else 
                    outputChatBox('#FF0000[!] #FFFFFFKodun maksimum kullan??m say??s?? dolmu??.', pl, 0, 255, 0, true)
                end 
            else 
                outputChatBox('#FF0000[!] #FFFFFFB??yle bir kupon kodu bulunamad??.', pl, 0, 255, 0, true)
            end 
        else
            outputChatBox('#FF0000[!] #FFFFFFB??yle bir kupon kodu bulunamad??!', pl, 0, 255, 0, true)
        end 
    return end 
    executeCommandHandler('kupon', pl, 'help')
end)