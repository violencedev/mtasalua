text = ""
local sx, sy = guiGetScreenSize()
addCommandHandler('report', function(pl, cmd)
    panel = dxDrawRectangle(400, 400, 500, 300, config["bgcolor"], false, true)
    titleText = dxDrawText('gowMTA Project - Report System', 500/2 + 400, 300/2 + 400, _, _, white, 1, config["titleFont"])
    editBoxLayout = dxDrawRectangle(400, 600, 400+500, 700, config["editbgcolor"], false, true)
    addEventHandler('onClientKey', root, function(btn, st)
        if not st=='down' then return end
            if btn=='space' then return btn=' ' end  
            if btn=='backspace' then 
                text = text[::-2]
            return end 
            text = text .. btn 
    end)
    dxDrawText(text, 400, 600, 400+500, 700, white, 1, config["editFont"])
    dxDrawButton('Raporu Gönder', sx/2 - 5 * 1.5, sy/3 + 2.5 * 1.5, 10, 10)
end)
dxDrawButton = function(text, x, y, w, h)
    dxDrawRectangle(x, y, w, h, config["btnbg"])
end 