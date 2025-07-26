local ESX = exports['es_extended']:getSharedObject()

local playerStats, playerXP = {}, {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        playerXP[xPlayer.identifier] = playerXP[xPlayer.identifier] or 0
        playerStats[xPlayer.identifier] = playerStats[xPlayer.identifier] or {
            totalDeliveries = 0,
            successfulDeliveries = 0,
            totalEarnings = 0,
            currentLevel = 1,
            xp = 0
        }
    end
end)

ESX.RegisterServerCallback('oxyrun:getPlayerStats', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        local stats = playerStats[xPlayer.identifier] or {
            totalDeliveries = 0,
            successfulDeliveries = 0,
            totalEarnings = 0
        }
        cb(stats)
    else
        cb({})
    end
end)

RegisterNetEvent('oxyrun:updateStats')
AddEventHandler('oxyrun:updateStats', function(success, reward)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local stats = playerStats[xPlayer.identifier]
    if not stats then return end

    stats.totalDeliveries = stats.totalDeliveries + 1
    if success then
        stats.successfulDeliveries = stats.successfulDeliveries + 1
        stats.totalEarnings = stats.totalEarnings + reward
        stats.xp = stats.xp + Config.Rewards.xp.min

        for level, data in pairs(Config.XPSystem.levels) do
            if stats.xp >= data.xp then
                stats.currentLevel = level
            end
        end
    end
end)

RegisterNetEvent('oxyrun:addMoney')
AddEventHandler('oxyrun:addMoney', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local amount = Config.Payment.amount or 2500
    exports.ox_inventory:AddItem(src, 'money', amount)
    TriggerClientEvent('esx:showNotification', src, 'You received $' .. amount .. ' for your delivery')
end)

RegisterNetEvent('oxyrun:givePackage')
AddEventHandler('oxyrun:givePackage', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.job.name == Config.JobName then
        exports.ox_inventory:AddItem(source, 'oxy', 1)
    end
end)

ESX.RegisterServerCallback('oxyrun:checkPackage', function(src, cb)
    local item = exports.ox_inventory:GetItem(src, 'oxy', nil, true)
    cb(item and item > 0)
end)

CreateThread(function()
    Wait(1000)
    if GetResourceState('ox_inventory') == 'started' then
        exports.ox_inventory:RegisterItem('oxy', {
            label = 'Oxycodone',
            weight = 100,
            stack = true,
            close = true,
            description = 'Prescription painkiller, totally legit.'
        })
    end
end)

function CalculateDeliveries(hours)
    local totalMinutes = hours * 60
    local timePerRun = Config.Cooldown + Config.DeliveryTimeLimit
    return math.floor(totalMinutes / timePerRun)
end

print("Max deliveries in 8 hrs:", CalculateDeliveries(8))
