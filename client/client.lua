local running = false
local blip, npc, box, dropSpot, dropPed = nil, nil, nil, nil, nil
local deliveryTimeoutToken = 0

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

local function clearDropoffEntities()
    if blip then
        RemoveBlip(blip)
        blip = nil
    end

    if dropPed and DoesEntityExist(dropPed) then
        DeleteEntity(dropPed)
        dropPed = nil
    end
end

local function pickDelivery(deliveryData)
    if not deliveryData or not deliveryData.coords then return end

    dropSpot = {
        coords = vector3(deliveryData.coords.x, deliveryData.coords.y, deliveryData.coords.z),
        label = deliveryData.label
    }

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
    if not running then return end

    local success = lib.skillCheck({'easy', 'easy', 'medium'}, {'w', 'a', 's', 'd'})
    if success then
        TriggerServerEvent('oxyrun:completeDelivery')
        lib.notify({ title = 'Delivery', description = Config.Notifications.complete, type = 'success' })
    else
        TriggerServerEvent('oxyrun:cancelDelivery')
        lib.notify({ title = 'Delivery', description = Config.Notifications.fail, type = 'error' })
    end

    running = false
    clearDropoffEntities()
end

function startDelivery(deliveryData)
    running = true
    lib.notify({ title = 'Delivery', description = Config.Notifications.start, type = 'info' })
    lib.notify({ title = 'Delivery', description = Config.Notifications.timeLimit:format(Config.DeliveryTimeLimit), type = 'info' })

    if box and DoesEntityExist(box) then DeleteEntity(box) end
    pickDelivery(deliveryData)

    deliveryTimeoutToken = deliveryTimeoutToken + 1
    local currentToken = deliveryTimeoutToken

    SetTimeout(Config.DeliveryTimeLimit * 60000, function()
        if not running or currentToken ~= deliveryTimeoutToken then return end

        running = false
        clearDropoffEntities()
        TriggerServerEvent('oxyrun:cancelDelivery')
        lib.notify({ title = 'Delivery', description = Config.Notifications.timeExpired, type = 'error' })
    end)
end

CreateThread(function()
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
                if running then
                    lib.notify({ title = 'Delivery', description = 'You already have an active delivery.', type = 'error' })
                    return
                end

                TriggerServerEvent('oxyrun:requestStart')
            end
        }
    })
end)

RegisterNetEvent('oxyrun:startDelivery', function(deliveryData)
    if running then return end
    startDelivery(deliveryData)
end)
