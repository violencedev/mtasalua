local dxfont0_font = dxCreateFont("font.ttf", 10)

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function isVehicleReversing(theVehicle)
    local getMatrix = getElementMatrix (theVehicle)
    local getVelocity = Vector3 (getElementVelocity(theVehicle))
    local getVectorDirection = (getVelocity.x * getMatrix[2][1]) + (getVelocity.y * getMatrix[2][2]) + (getVelocity.z * getMatrix[2][3])
    if (getVehicleCurrentGear(theVehicle) == 0 and getVectorDirection < 0) then
        return true
    end
    return false
end

function round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end





function getVehicleRPM(vehicle)
    local vehicleRPM = 0
        if (vehicle) then  
            if (getVehicleEngineState(vehicle) == true) then
                if getVehicleCurrentGear(vehicle) > 0 then             
                    vehicleRPM = math.floor(((getElementSpeed(vehicle, "km/h")/getVehicleCurrentGear(vehicle))*180) + 0.5) 
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9800) then
                        vehicleRPM = math.random(9800, 9900)
                    end
                else
                    vehicleRPM = math.floor((getElementSpeed(vehicle, "km/h")*180) + 0.5)
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9800) then
                        vehicleRPM = math.random(9800, 9900)
                    end
                end
            else
                vehicleRPM = 0
            end
            return tonumber(vehicleRPM)
        else
            return 0
        end
    end

function isaretcek(veh)
        local gear = getVehicleCurrentGear(veh)
        local rpm = getVehicleRPM(veh)
        if rpm <= 750 then 
            return "."
        end
        if rpm>750 and rpm<=2500 then 
            return "#00ff00.:"
        end
        if rpm>2500 and rpm<=4000 then 
            return "#00ff00..:"
        end
        if rpm>4000 and rpm<=5000 then 
            return "#ffff00...:"
        end
        if rpm>5000 and rpm<=6000 then 
            return "#ffff00....:"
        end
        if rpm>6000 and rpm<=7000 then 
            return "#ffa500.....:"
        end
        if rpm>7000 and rpm<=8500 then 
            return "#ff8c00......:"
        end
        if rpm>8500 then 
            return "#ff4500.......:"
        end
end 

function kmIsle(pl, arac)
    local km = getElementData(arac, 'km') or 0
    local sira = getElementData(arac, 'sira') or 1 
    if sira==1 then
        setElementData(arac, 'sira', sira+1) 
        while getPedOccupiedVehicle(pl) == arac do 
            
        end 
    end
end    

addEventHandler("onClientRender", root,
    function()
        local veh = getPedOccupiedVehicle(getLocalPlayer())
        if veh then 
        kmIsle(getLocalPlayer(), veh)
        --bindKey(getLocalPlayer(), 'forwards', "down", isaretle, veh)
        dxDrawText("Hız: "..round(getElementSpeed(veh, 'km/h')).." km/h", 451, 812, 536, 827, tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "left", "top", false, false, false, false, false)
        dxDrawText("Vites: #adff2f"..getVehicleCurrentGear(veh).."#ffffff||"..isaretcek(veh).."", 451, 837, 536, 852, tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "left", "top", false, false, false, true, false)
        dxDrawText("Yakıt: "..round(getElementData(veh, "fuel")).."#adff2f/#ffffff100", 451, 862, 536, 877, tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "left", "top", false, false, false, true, false)
        dxDrawText("KM: 1565.23", 451, 887, 536, 902, tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "left", "top", false, false, false, false, false)
        --else 
            --unbindKey(getLocalPla(), 'forwards', 'down', "xaÜACVİa5?cxş5ÜadcawG:tü@rdwü:TAĞ'")
        end
    end
) 