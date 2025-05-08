fx_version 'cerulean'
game 'gta5'
lua54 'yes'

use_experimental_fxv2_oal 'yes'

author 'Hyper'
description 'Seasons Oxy Delivery Job'
version '0.9-sorta'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua' 
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua' 
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'oxmysql'
}
