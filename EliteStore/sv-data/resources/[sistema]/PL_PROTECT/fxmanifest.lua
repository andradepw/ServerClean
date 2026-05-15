fx_version "adamant"
game "gta5"
lua54 "yes"
node_version '22'
server_scripts {
    "@vrp/lib/utils.lua",
    "@vrp/cfg/webhook.lua",
    "PL_Server.js",
    "PL_Server.lua"
}

client_scripts {
    "config/weapon.lua",
    "PL_Client.lua"
}