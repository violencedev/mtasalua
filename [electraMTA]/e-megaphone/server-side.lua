local c = exports["chat-system"]
local factid = 192
maincolor = "3f763e"

O = outputChatBox
A = addCommandHandler
G = getElementData 
E = executeCommandHandler

list = {
    "Teslim ol, etrafın sarıldı!",
    "Hey sen, dur polis!",
    "Los Santos Polis Departmanı, olduğun yerde kal!",
    "Polis KIPIRDAMA!",
    "Ellerin başının üstünde kalacak şekilde araçtan in!",
    "LSPD, kenara çeki-.. sen deli misin?! Hepimizi öldürüyordun!"
}


function MegaphoneHelp(p, cmd)
    if G(p, "faction") == factid then
        for k, v in pairs(list) do
            O('#'..maincolor..'((#FFFFFF /mg '..(k)..': '..(v)..'#'..maincolor..'))', p,0,0,0,true)
        end 
    else
        O("[electraMTA]#FFFFFF Bu Komutu Kullanmak İçin LSPD Birliğinde Olman Lazım.", p,0,0,0,true)
    end
end
A("mhelp", MegaphoneHelp)


function megaphone(p, cmd, state)
    if G(p, "faction") == factid then
        state = tonumber(state)
        if state>0 and state<8 then 
            c:localShout(p, 's', list[state])
        else 
            E("mhelp", p)
        end
    else
        O("[electraMTA]#FFFFFF Bu Komutu Kullanmak İçin LSPD Birliğinde Olman Lazım.", p, 0, 0, 0, true)
    end
end
A("mg", megaphone)