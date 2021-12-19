local mysql = exports["mysql"]
min, max = 500, 5000
x, y, z = 1299.6640625, -2328.2294921875, 13.524089813232
place = createColSphere(x, y, z, 7)



addCommandHandler('hkutuac', function(player, cmd)
if isElementWithinColShape(player, place) then
    local hediyesayisi = getElementData(player, 'hediye:toplam') or 0 
    if hediyesayisi >= 1 then 
        setElementData(player, 'hediye:toplam', hediyesayisi - 1)
        local newsayi = getElementData(player, 'hediye:toplam')
        local mysqlexecution = dbExec(mysql:getConnection(), 'UPDATE characters SET hediyekutusu = ? WHERE id = ?', newsayi, getElementData(player, 'dbid'))
        if mysqlexecution == true then 
            local reward = math.random(min, max)
            local isGiven = exports["global"]:giveMoney(player, reward)
            if isGiven == true then 
                outputChatBox('#FF0000[!] #FFFFFFHediye kutusundan ['..reward..' TL] kazandınız, ödülünüz hesabınıza aktarıldı.', player, 0, 255, 0, true)
            else 
                setElementData(player, 'hediye:toplam', hediyesayisi)
                local mysqlexecution = dbExec(mysql:getConnection(), 'UPDATE characters SET hediyekutusu = ? WHERE id = ?', newsayi, getElementData(player, 'dbid'))
                outputChatBox('#FF0000[!] #FFFFFFTeknik bir hatadan dolayı kutunuz açılamadı.', player, 0, 255, 0, true)
            end 
        else 
            setElementData(player, 'hediye:toplam', hediyesayisi)
            outputChatBox('#FF0000[!] #FFFFFFTeknik bir hatadan dolayı kutunuz açılamadı.', player, 0, 255, 0, true)
        end 
    else 
        outputChatBox('#FF0000[!] #FFFFFFHiçbir hediye kutunuz bulunmamaktadır!', player, 0, 255, 0, true)
    end
else 
    outputChatBox('#FF0000[!] #FFFFFFBu işlemi yalnızca ['..getZoneName(x, y, z)..' bölgesindeki] belirlenmiş alanda yapabilirsiniz.', player, 0, 255, 0, true)
end 
end)



addCommandHandler('kutuver', function(player, cmd)
    if getElementData(player, 'account:username') == "violence" then
        local a = dbExec(mysql:getConnection(), 'UPDATE characters SET hediyekutusu = ? WHERE id = ?', tonumber(getElementData(player, 'hediye:toplam')) + 1, getElementData(player, 'dbid'))
        setElementData(player, 'hediye:toplam', getElementData(player, 'hediye:toplam') + 1)
        outputChatBox('Başarılıyla işlem yapıldı')
    end
end)

