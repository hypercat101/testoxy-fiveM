local Framework = nil

if Config.Framework == 'qbcore' then
    Framework = exports['qb-core']:GetCoreObject()
else
    Framework = exports['es_extended']:getSharedObject()
end

RegisterNetEvent('oxyrun:addMoney')
AddEventHandler('oxyrun:addMoney', function()
    local src = source

    if Config.Framework == 'qbcore' then
        local Player = Framework.Functions.GetPlayer(src)
        if not Player then return end
        local amount = Config.Rewards.money or 2500
        Player.Functions.AddMoney('cash', amount, 'oxy-delivery')
        TriggerClientEvent('ox_lib:notify', src, { title = 'Delivery', description = 'You received $' .. amount, type = 'success' })
    else
        local xPlayer = Framework.GetPlayerFromId(src)
        if not xPlayer then return end
        local amount = Config.Rewards.money or 2500
        xPlayer.addMoney(amount)
        TriggerClientEvent('ox_lib:notify', src, { title = 'Delivery', description = 'You received $' .. amount, type = 'success' })
    end
end)
