policeVehicles = {}

addEventHandler('onResourceStart', resourceRoot, function(source)
	policeVehicles = {}
	for k, v in ipairs(getElementsByType('vehicle')) do 
		if getElementData(v, 'faction') == 1 then
			table.insert(policeVehicles,getElementData(v, 'dbid'))
		end
	end
end)

function findIndex(i, table)
	for k, v in pairs(table) do 
		if v==i then 
			return k 
		end 
	end
end 

function getNearestVehicle(player,distance, uv)
	local lastMinDis = distance-0.0001
	local nearestVeh = false
	local px,py,pz = getElementPosition(player)
	local pint = getElementInterior(player)
	local pdim = getElementDimension(player)
	vehs = getElementsByType('vehicle')
	table.remove(vehs, findIndex(uv, vehs))
	for _,v in pairs(vehs) do
			local vint,vdim = getElementInterior(v),getElementDimension(v)
			if vint == pint and vdim == pdim then
				local vx,vy,vz = getElementPosition(v)
				local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
				if dis < distance then
					if dis < lastMinDis then 
							lastMinDis = dis
							nearestVeh = v
					end
				end
			end
	end
	return nearestVeh
end

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end




addEventHandler('onResourceStart', resourceRoot, function()

    for _,v in pairs(getElementsByType('player')) do 
		if v then
			if getPedOccupiedVehicle(v) then 
				if ( policeVehicles[getElementModel ( getPedOccupiedVehicle(v) )] ) then

					setElementData(v, 'dashcam', true)
					dashRe(v)
				end
			end 
		end
    end 

end)

function lookAround(player)
	for k, v in pairs(policeVehicles) do 
		if v == getElementData(getPedOccupiedVehicle(player), 'dbid') then 
			return true
		end 
	end 
end 

addCommandHandler('dashcam', function(pl, cmd)
	if getElementData(pl, 'dashcam') == true then 
		outputChatBox('#0000FF[!] #FFFFFFBaşarıyla aracın takip kamerası kapatıldı!', pl, 0, 255, 0, true)
		setElementData(pl, 'dashcam', false)
		triggerClientEvent(pl, 'handle', pl)
	else 
		outputChatBox('#0000FF[!] #FFFFFFBaşarıyla aracın takip kamerası açıldı!', pl, 0, 255, 0, true)
		setElementData(pl, 'dashcam', true) 
		triggerClientEvent(pl, 'handle', pl, "", "", "", "a")
		dashRe(pl)
	end 
end)



function round(x)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end



function isPlayerOnline(player)
	for _,v in pairs(getElementsByType('player')) do 
		if player == v then 
			return true 
		end 
	end 
end 

function dashRe(pl)
	setTimer(function()
	if isPlayerOnline(pl) == true then
		if getPedOccupiedVehicle(pl) then
			if getElementData(pl, 'dashcam') == true then 
				local veh = getNearestVehicle(pl, 10, getPedOccupiedVehicle(pl))
				if veh then 
							local vx, vy, vz = getElementPosition(veh)
							local px, py, pz = getElementPosition(getPedOccupiedVehicle(pl))
								marka = string.upper(getVehicleNameFromModel(getElementModel(veh)))
								plate = string.upper(getVehiclePlateText(veh))
								velocity = ''..tostring(round(getElementSpeed(veh, 1)))..' KM/H'
								triggerClientEvent(pl, 'handle', pl, marka, plate, velocity, "a")
				return end
				triggerClientEvent(pl, 'handle', pl, "", "", "", "a")
			end
		else  
			triggerClientEvent(pl, 'handle', pl)
		end 
	end
	end, 100, 0)
end