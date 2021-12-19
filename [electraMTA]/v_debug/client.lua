local sS = {guiGetScreenSize()}

local defLines = 20

local pos = {sS[1]/2, sS[2] - 30}

local font = dxCreateFont("roboto.ttf", 9) -- Height : 15

debugTable = {}

debug = false

local states = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
}

local levels = {
    [0] = "[Custom]",
    [1] = "#ad1503[Error]#ffffff",
    [2] = "#ffa500[Warning]#ffffff",
    [3] = "#009B3A[Info]#ffffff",
}

local latestRow = 1
local currentRow = 1
local maxRow = 10

function renderDebug()
    if not debug then return end
    -- dxDrawRectangle(pos[1] - 425, pos[2] - 15 * maxRow - 5, 850, 15 * maxRow + 15, tocolor(0, 0, 0, 150), false)
    latestRow = currentRow+maxRow-1
    for k, v in ipairs(debugTable) do
        if k >= currentRow and k <= latestRow then
            k = k - currentRow + 1
            if v[3] > 1 and v[4] then
             --   dxDrawText(v[1] .. " [Dup #ad1503x" .. v[3] .. "#ffffff - Kliens Oldal]", pos[1], pos[2] - 16 * (k - 1), pos[1], pos[2] - 16 * (k - 1), tocolor(255, 255, 255, 255), 1, font, "center", "center", _, _, true, true)
                dxDrawText(v[1] .. " [Kopya #FFA4E3" .. v[3] .. "#ffffff - Hata]", pos[1], pos[2] - 16 * (k - 1), pos[1], pos[2] - 16 * (k - 1), tocolor(255, 255, 255, 255), 1, font, "center", "center", _, _, true, true)
                --shadowedText(v[1] .. " [Dup x" .. v[3] .. " - Kliens Oldal]", pos[1], pos[2] - 16 * (k - 1), pos[1], pos[2] - 16 * (k - 1), tocolor(0, 0, 0, 255), 1, font, "center", "center"))
            elseif v[4] then
                dxDrawText(v[1] .. " [Hata kapandı.]", pos[1], pos[2] - 16 * (k - 1), pos[1], pos[2] - 16 * (k - 1), tocolor(255, 255, 255, 255), 1, font, "center", "center", _, _, true, true)
               --shadowedText(v[1] .. " [Kliens Oldal]", pos[1], pos[2] - 16 * (k - 1), pos[1], pos[2] - 16 * (k - 1), tocolor(0, 0, 0, 0), 1, font, "center", "center",false,false,false,false,false))
            elseif v[3] > 1 then
                dxDrawText(v[1] .. " [Kopya #FFA4E3" .. v[3] .. "#ffffff]", pos[1], pos[2] - 16 * (k - 1), pos[1], pos[2] - 16 * (k - 1), tocolor(255, 255, 255, 255), 1, font, "center", "center", _, _, true, true)
               -- shadowedText(v[1] .. " [Dup #ad1503x" .. v[3] .. "#ffffff]", pos[1], pos[2] - 16 * (k - 1), pos[1], pos[2] - 16 * (k - 1), tocolor(0, 0, 0, 255), 1, font, "center", "center",false,false,false,false,false))
            else
                dxDrawText(v[1], pos[1], pos[2] - 16 * (k - 1), pos[1], pos[2] - 16 * (k - 1), tocolor(255, 255, 255, 255), 1, font, "center", "center", _, _, true, true)
              --  shadowedText(v[1], pos[1], pos[2] - 16 * (k - 1), pos[1], pos[2] - 16 * (k - 1), tocolor(0, 0, 0, 255), 1, font, "center", "center",false,false,false,false,false))
            end
        end
    end
end
addEventHandler("onClientRender", getRootElement(), renderDebug)

function moveDebugRender()
    if not cdm then return end
    local cpx, cpy = getCursorPosition()
    local posx, posy = cpx * sS[1] - doffsetx, cpy * sS[2] - doffsety
    pos[1] = posx
    pos[2] = posy
end
addEventHandler("onClientRender", getRootElement(), moveDebugRender)

function moveDebug(k, s)
    if k == "mouse1" and s then
        if isCursorInPos(pos[1] - 425, pos[2] - 15 * maxRow - 5, 850, 15 * maxRow + 15) and not cdm then
            local cpx, cpy = getCursorPosition()
            doffsetx, doffsety = cpx * sS[1] - pos[1], cpy * sS[2] - pos[2]
            cdm = true
        end
    elseif k == "mouse1" and not s then
        cdm = false
    end
end
addEventHandler("onClientKey", getRootElement(), moveDebug)


function addDebug(msg, level, file, line, client)
    -- if getElementData(localPlayer, "acc:admin") >= 8 then
        if states[level] == false then
            return
        end
        if client == nil then
            client = false
        end
        if line == nil then
            line = 0
        end
        if file == nil then
            file = "Script"
        end

        local debugString = levels[level] .. ": " .. msg .. " [ " .. file .. " : " .. line .. " ]"
        if table.find(debugTable, debugString, 1) then
            local k = table.findIndex(debugTable, debugString, 1)
            debugTable[k][3] = debugTable[k][3] + 1
            table.sort(debugTable, function(a, b) return a[2] > b[2] end)
        else
            table.insert(debugTable, {debugString, #debugTable + 1, 1, client})
            table.sort(debugTable, function(a, b) return a[2] > b[2] end)
        end
    -- end
end
addEvent("addDebug", true)
addEventHandler("addDebug", getRootElement(), addDebug)

addEventHandler("onClientDebugMessage", root, 
    function(message, level, file, line)
        addDebug(message, level, file, line, true)
    end
)

function showDebug()
        if debug then
            debug = false
            outputChatBox("Kapadın.")
        else
            debug = true
            outputChatBox("Açtın.")
        end
    end
addCommandHandler("debug", showDebug)
addCommandHandler("debugscript 3", showDebug)
addCommandHandler("debugscript 2", showDebug)
addCommandHandler("debugscript", showDebug)

function cDebug()
    debugTable = {}
end
addCommandHandler("cdebug", cDebug)
addCommandHandler("cleardebug", cDebug)


bindKey("pgup", "down",
    function()
        if currentRow > 1 then
            currentRow = currentRow - 1
        end
    end
)

bindKey("pgdown", "down",
    function()
        if currentRow < #debugTable - (maxRow - 1) then
            currentRow = currentRow + 1
        end 
    end
)

function table.find(t, v, n)
	for k, a in ipairs(t) do
		if a[n] == v then
			return true
		end
	end
	return false
end

function table.findIndex(t, v, n)
	for k, a in ipairs(t) do
		if a[n] == v then
			return k
		end
	end
	return false
end

function isCursorInPos(posX, posY, width, height)
	if isCursorShowing() then
		local mouseX, mouseY = getCursorPosition();
		local clientW, clientH = guiGetScreenSize();
		local mouseX, mouseY = mouseX * clientW, mouseY * clientH;
		if (mouseX > posX and mouseX < (posX+width) and mouseY > posY and mouseY < (posY+height)) then
			return true;
		end
	end
	return false;
end

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text,x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) -- Fent
    dxDrawText(text,x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) -- Lent
    dxDrawText(text,x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) -- Bal
    dxDrawText(text,x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) -- Jobb
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end