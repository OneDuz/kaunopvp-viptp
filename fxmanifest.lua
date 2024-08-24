fx_version 'cerulean'
game 'gta5'

lua54 "yes"

author "onecodes"
version "1.0.1"
description 'Simple vip tp and nice one ig made for kaunopvp.lt'


server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

client_scripts {
    'client.lua',
}

shared_script '@es_extended/imports.lua'
shared_script '@ox_lib/init.lua'
