
local dxfont0_font = dxCreateFont("font.ttf", 10)
local sx, sy = guiGetScreenSize()

--Settings--
grihex = "F5F5F5"
greenhex = "53a762"
--Settings--

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

addEventHandler("onClientRender", root,
    function()
        if getElementData(localPlayer, "loggedin") == 1 and not getElementData(localPlayer, "f10") then
        if exports.global:isStaffOnDuty(getLocalPlayer()) == true then 
            admin = " - #"..greenhex.."GÖREVDE"
            admin2 = " - GÖREVDE"
        else 
            admin = ""
        end 
        dxDrawText("ELECTRA Roleplay v0.0.1 - "..getPlayerName(getLocalPlayer()).."["..getElementData(getLocalPlayer(), 'playerid').."] - "..getStampDate().."" .. (admin2 or ""), (749 / 1920)*sx, (1057/1080)*sy, sx*(1173/1920), sy*(1077/1080), tocolor(0, 0, 0, 255), 1.00, dxfont0_font, "left", "bottom", false, false, false, false, false)
        dxDrawText("#"..grihex.."ELECTRA #"..greenhex.."Roleplay v0.0.1 #"..grihex.."- "..getPlayerName(getLocalPlayer()).."["..getElementData(getLocalPlayer(), 'playerid').."] - "..getStampDate().."" .. (admin or ""), sx*(748 / 1920), sy*(1056/1080), sx*(1172/1920), sy*(1076/1080), tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "left", "bottom", false, false, false, true, false)
        end
    end
)
