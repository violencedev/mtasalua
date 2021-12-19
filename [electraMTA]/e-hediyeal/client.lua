

addEventHandler('onClientRender', function()

    if getElementData(source, 'loggedin') == 1 then 
        if (getElementData(source, 'cagrildi') or false) == false then 
            setElementData(source, 'cagrildi', true)
        end 

    end 
end)