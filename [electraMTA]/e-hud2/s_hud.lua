function returnMaxPlayers()
    return tonumber(getServerConfigSetting("maxplayers"))
end 
addEvent('max:players', true)
addEventHandler('max:players', root, returnMaxPlayers)