RegisterServerEvent('ilegal:AddItem')
AddEventHandler('ilegal:AddItem', function(itemName, quantity)
    local src = source
    exports.ox_inventory:AddItem(src, itemName, quantity)
end)
RegisterServerEvent('ilegal:RemoveItem')
AddEventHandler('ilegal:RemoveItem', function(itemName, quantity)
    local src = source
    exports.ox_inventory:RemoveItem(src, itemName, quantity)
end)

RegisterServerEvent('ilegal:GetItemCount')
AddEventHandler('ilegal:GetItemCount', function(count)
    local count = exports.ox_inventory:Search(count, 'lsd')
    exports.ox_inventory:Search(count, 'lsd')
    print(count)
end)