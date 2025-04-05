fx_version 'cerulean'
game 'gta5'

name 'BlackCrafting'
author 'Black Cris'
version '1.0.2'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

lua54 'yes'
