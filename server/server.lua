local Framework = nil
local activeRuns = {}
local cooldowns = {}

if Config.Framework == 'qbcore' then
    Framework = exports['qb-core']:GetCoreObject()
else
    Framework = exports['es_extended']:getSharedObject()
end

local function debugLog(message)
    if Config.Debug then
        print(('[oxyrun] %s'):format(message))
    end
end

local function notify(src, description, ntype)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Delivery',
        description = description,
        type = ntype or 'info'
    })
end

local function getRemainingCooldown(src)
    local endsAt = cooldowns[src]
    if not endsAt then return 0 end

    local now = os.time()
    if endsAt <= now then
        cooldowns[src] = nil
        return 0
    end

    return endsAt - now
end

local function getRandomDeliveryIndex()
    local deliveries = Config.Locations.delivery
    return math.random(#deliveries)
end

local function getDeliveryPayload(index)
    local delivery = Config.Locations.delivery[index]
    return {
        label = delivery.label,
        coords = {
            x = delivery.coords.x,
            y = delivery.coords.y,
            z = delivery.coords.z
        },
        timeLimit = Config.DeliveryTimeLimit
    }
end

local function rewardPlayer(src)
    local amount = Config.Rewards.money or 2500

    if Config.Framework == 'qbcore' then
        local player = Framework.Functions.GetPlayer(src)
        if not player then return false end
        player.Functions.AddMoney('cash', amount, 'oxy-delivery')
    else
        local xPlayer = Framework.GetPlayerFromId(src)
        if not xPlayer then return false end
        xPlayer.addMoney(amount)
    end

    notify(src, ('You received $%s'):format(amount), 'success')
    return true
end

RegisterNetEvent('oxyrun:requestStart', function()
    local src = source

    if activeRuns[src] then
        notify(src, 'You already have an active delivery.', 'error')
        return
    end

    local cooldownSeconds = getRemainingCooldown(src)
    if cooldownSeconds > 0 then
        local minutes = math.ceil(cooldownSeconds / 60)
        notify(src, ('%s (%s min left)'):format(Config.Notifications.cooldown, minutes), 'error')
        return
    end

    local now = os.time()
    local deliveryIndex = getRandomDeliveryIndex()

    activeRuns[src] = {
        deliveryIndex = deliveryIndex,
        startedAt = now,
        expiresAt = now + (Config.DeliveryTimeLimit * 60)
    }

    debugLog(('Start approved for %s at index %s'):format(src, deliveryIndex))
    TriggerClientEvent('oxyrun:startDelivery', src, getDeliveryPayload(deliveryIndex))
end)

RegisterNetEvent('oxyrun:completeDelivery', function()
    local src = source
    local now = os.time()
    local run = activeRuns[src]

    if not run then
        debugLog(('Blocked completion for %s (no active run)'):format(src))
        return
    end

    if now > run.expiresAt then
        activeRuns[src] = nil
        notify(src, Config.Notifications.timeExpired, 'error')
        debugLog(('Blocked completion for %s (expired run)'):format(src))
        return
    end

    local ped = GetPlayerPed(src)
    if ped == 0 then return end

    local playerCoords = GetEntityCoords(ped)
    local delivery = Config.Locations.delivery[run.deliveryIndex]
    local distance = #(playerCoords - delivery.coords)

    if distance > 20.0 then
        debugLog(('Blocked completion for %s (distance %.2f from drop)'):format(src, distance))
        notify(src, 'You are too far from the drop-off point.', 'error')
        return
    end

    if not rewardPlayer(src) then
        debugLog(('Reward failed for %s (missing framework player)'):format(src))
        return
    end

    activeRuns[src] = nil
    cooldowns[src] = now + (Config.Cooldown * 60)
end)

RegisterNetEvent('oxyrun:cancelDelivery', function()
    local src = source
    if activeRuns[src] then
        activeRuns[src] = nil
        debugLog(('Cancelled active run for %s'):format(src))
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    activeRuns[src] = nil
    cooldowns[src] = nil
end)
