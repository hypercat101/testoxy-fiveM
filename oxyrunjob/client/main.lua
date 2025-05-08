local ESX = exports['es_extended']:getSharedObject()
local running, cooldown = false, false
local blip, npc, box, dropSpot, dropPed = nil, nil, nil, nil, nil

local function loadModel(model)
    local hash = type(model) == 'string' and GetHashKey(model) or model
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(50) end
    return hash
end

local function placePed(model, coords, heading)
    local hash = loadModel(model)
    local ped = CreatePed(4, hash, coords.x, coords.y, coords.z, heading or 0.0, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    return ped
end

local function spawnBlip(coords, label)
    if blip then RemoveBlip(blip) end
    blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, Config.Blip.sprite)
    SetBlipScale(blip, Config.Blip.scale)
    SetBlipColour(blip, Config.Blip.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label or "Delivery")
    EndTextCommandSetBlipName(blip)
    SetBlipRoute(blip, true)
end

local function pickDelivery()
    local places = Config.Locations.delivery
    dropSpot = places[math.random(#places)]
    spawnBlip(dropSpot.coords, dropSpot.label)
    dropPed = placePed("a_m_y_business_01", dropSpot.coords)
    exports.ox_target:addLocalEntity(dropPed, {
        {
            name = "hand_over",
            label = "Drop Package",
            icon = "fa-box",
            distance = 2.0,
            onSelect = function()
                if running then finishDelivery() end
            end
        }
    })
end

function finishDelivery()
    exports['ps-ui']:Circle(function(success)
        if success then
            TriggerServerEvent('oxyrun:addMoney')
            lib.notify({ title = 'Delivery', description = Config.Notifications.complete, type = 'success' })
        else
            lib.notify({ title = 'Delivery', description = Config.Notifications.fail, type = 'error' })
        end
        running = false
        if blip then RemoveBlip(blip) end
        if dropPed and DoesEntityExist(dropPed) then DeleteEntity(dropPed) end
        cooldown = true
        SetTimeout(Config.Cooldown * 60000, function() cooldown = false end)
    end, 4, 10)
end

function startDelivery()
    running = true
    lib.notify({ title = 'Delivery', description = Config.Notifications.start, type = 'info' })
    if box and DoesEntityExist(box) then DeleteEntity(box) end
    pickDelivery()
end

CreateThread(function()
    while not ESX do Wait(100) end
    Wait(1500)
    local pos = Config.Locations.start
    npc = placePed("a_m_y_business_01", pos)
    local prop = loadModel("prop_drug_package")
    box = CreateObject(prop, pos.x, pos.y, pos.z, false, false, false)
    FreezeEntityPosition(box, true)
    exports.ox_target:addLocalEntity(box, {
        {
            name = "start_job",
            label = "Run a Delivery",
            icon = "fa-truck",
            distance = 2.0,
            onSelect = function()
                if not running and not cooldown then startDelivery() end
            end
        }
    })
end)

RegisterCommand("runoxy", function()
    if not running and not cooldown then startDelivery() end
end)
