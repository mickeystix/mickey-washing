RepentzFW = nil
TriggerEvent('RepentzFW:GetObject', function(obj) RepentzFW = obj end)

local ItemList = Config.ItemList

local payoutItem = "casinochips" -- Make this what you want to receive

RegisterServerEvent("mickey-washing:server:sellPawnItems")
AddEventHandler("mickey-washing:server:sellPawnItems", function(sellPrice)
    local src = source
    local price = 0
    local Player = RepentzFW.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    local item = RepentzFW.Shared.Items[Player.PlayerData.items[k].name]
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', source, item, "remove")
                end
            end
        end
        Citizen.Wait(100)
        TriggerClientEvent('RepentzFW:Notify', src, "You have sold your items")
        Player.Functions.AddItem(payoutItem, price)
        TriggerClientEvent('inventory:client:ItemBox', source, payoutItem, "add")
    end
end)



RepentzFW.Functions.CreateCallback('mickey-washing:server:getSellPrice', function(source, cb)
    local retval = 0
    local Player = RepentzFW.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    retval = retval + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Citizen.Wait(10)
                end
            end
        end
    end
    cb(retval)
end)

--Change this over to check for weight
RepentzFW.Functions.CreateCallback('mickey-washing:server:checkWeight', function(source, cb)
    local retval = 0
    local Player = RepentzFW.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    retval = retval + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Citizen.Wait(10)
                end
            end
        end
    end
    cb(retval)
end)