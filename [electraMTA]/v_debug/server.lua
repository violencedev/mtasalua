function addMsgToTable(message, level, file, line)
    triggerClientEvent(getRootElement(), "addDebug", getRootElement(), message, level, file, line)
end
addEventHandler("onDebugMessage", getRootElement(), addMsgToTable)