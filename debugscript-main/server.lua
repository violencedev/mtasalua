function debugScript(element,command,state)
    state = tonumber(state)
    if not state then
        outputChatBox('Kullanım: /'..command..' 1-2-3',element)
    return end
    setPlayerScriptDebugLevel(element,state)
    outputChatBox('Debugscript değeriniz '..state..' olarak değiştirildi!',element)
end
addCommandHandler('debug',debugScript)