Config = {}

Config.Framework = 'esx'
Config.Debug = false

Config.JobName = 'oxydealer'
Config.Cooldown = 5
Config.DeliveryTimeLimit = 5

Config.Menu = {
    title = "Seasons Delivery"
}

Config.Locations = {
    start = vector3(-103.5, 6330.5, 31.5),
    delivery = {
        
        {coords = vector3(-48.42, 6412.87, 31.48), label = "Paleto Gas"},
        {coords = vector3(1728.67, 6414.92, 35.04), label = "Sandy 24/7"},
        {coords = vector3(-442.94, 6012.74, 31.72), label = "Paleto 24/7"},
        {coords = vector3(-437.01, 6020.79, 31.49), label = "Paleto PD"},
        {coords = vector3(1960.13, 3741.49, 32.34), label = "Sandy Gas"},
        {coords = vector3(2677.91, 3281.67, 55.24), label = "Grapeseed"},
        {coords = vector3(25.7, -1347.3, 29.5), label = "LS Super"},
        {coords = vector3(1135.8, -982.28, 46.41), label = "Mirror Park"},
        {coords = vector3(-1222.91, -906.98, 12.33), label = "Vespucci Liquor"},
        {coords = vector3(1163.37, -323.8, 69.21), label = "Vinewood 24/7"}
    }
}

Config.Rewards = {
    money = 2500
}

Config.Notifications = {
    start = "Job started. Check map.",
    complete = "Package dropped. You got paid.",
    fail = "Delivery messed up.",
    cooldown = "Hold on, cooldown active.",
    timeLimit = "You got %s mins to finish.",
    timeExpired = "Too slow. Job failed."
}

Config.Blip = {
    sprite = 51,
    color = 1,
    scale = 0.9,
    label = "Seasons Delivery"
}
