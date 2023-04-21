fx_version "adamant"
game "gta5"

client_scripts {
    "client/*.lua"
}


server_scripts {
    'server/*.lua'
}

shared_scripts {
    'config.lua',
    '@es_extended/imports.lua'
}

file 'stream/gen_w_am_metaldetector.ytyp'