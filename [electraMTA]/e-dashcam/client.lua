local sWidth,sHeight = guiGetScreenSize()

font = guiCreateFont('font/BankGthd.ttf', 15)
img = guiCreateStaticImage(0.516 * sWidth, sHeight * (-41 / 1080), sWidth * (468 / 1920), sHeight * (236 / 1080), "img/dashcam.png", false) 
                        
markaa = guiCreateLabel(sWidth * (49 / 1920), sHeight * (118 / 1080), sWidth * (370 / 1920), sHeight * (25 / 1080), "", false, img)
guiLabelSetHorizontalAlign(markaa, "center", false)
plaka = guiCreateLabel(sWidth * (49 / 1920), sHeight * (143 / 1080), sWidth * (370 / 1920), sHeight * (25 / 1080), "", false, img)
guiLabelSetHorizontalAlign(plaka, "center", false)
velocity = guiCreateLabel(sWidth * (49 / 1920), sHeight * (168 / 1080) , sWidth * (370 / 1920), sHeight * (25 / 1080), "", false, img)
guiLabelSetHorizontalAlign(velocity, "center", false)  
guiSetFont(markaa, font)
guiSetFont(plaka, font)
guiSetFont(velocity, font)
guiLabelSetColor(markaa, 81, 98, 138)
guiLabelSetColor(plaka, 81, 98, 138)
guiLabelSetColor(velocity, 81, 98, 138)
guiSetVisible(img, false)



function handle(marka, plate, hiz, d)
            if not marka or not plate or not hiz then 
                marka, plate, hiz = "", "", ""
            end
            if d == "a" or marka == "a" then
                guiSetText(markaa, marka)
                guiSetText(plaka, plate)
                guiSetText(velocity, hiz)
                guiSetVisible(img, true)                
            else 
                guiSetVisible(img, false)
            end 
end
addEvent('handle', true)
addEventHandler('handle', root, handle)


