
client_script "lib/lib.lua"

fx_version 'adamant'
game 'gta5'

ui_page 'gui/index.html'

lua54 'yes'

server_scripts {
	'lib/utils.lua',
	'cfg/groups.lua',
	'cfg/items.lua',
	'cfg/cars.lua',
	'cfg/blips.lua',
	'cfg/Native.lua',
	'base.lua',
	'queue.lua',
	'modules/gui.lua',
	'modules/player_state.lua',
	'modules/map.lua',
	'modules/money.lua',
	'modules/inventory.lua',
	'modules/itemcmd.lua',
	'modules/identity.lua',
	'modules/aptitude.lua',
	'modules/basic_items.lua',
	'modules/basic_skinshop.lua',
	'modules/group.lua',
	'modules/cooldown.lua',
	'modules/survival.lua',
	"@elitestore/webhooks.lua"
}

client_scripts {
	'lib/utils.lua',
	'cfg/items.lua',
	'cfg/cars.lua',
	'cfg/Native.lua',
	'client/spawn.lua',
	'client/base.lua',
	'client/objects.lua',
	'client/basic_garage.lua',
	'client/iplloader.lua',
	'client/gui.lua',
	'client/player_state.lua',
	'client/survival.lua',
	'client/map.lua',
	'client/identity.lua',
	'client/police.lua'
}

files {
	"loading/index.html",
	"loading/css/main.css",
	"loading/img/person-male.png",
	"loading/img/cursor.png",
	"loading/js/music-controls.js",
	"loading/js/music-handler.js",
	"loading/js/main.js",
	"loading/js/config.js",
	"loading/js/synn.js",
	"loading/js/progressbar-renderer.js",
	'lib/Tunnel.lua',
	'lib/Proxy.lua',
	'lib/Luaseq.lua',
	'lib/Tools.lua',
	'gui/index.html',
	'gui/design.css',
	'gui/main.js',
	'gui/Menu.js',
	'gui/WPrompt.js',
	'gui/RequestManager.js',
	'gui/Div.js',
	'gui/dynamic_classes.js',
	'gui/bebas.ttf'
}

loadscreen "loading/index.html"

server_export 'AddPriority'
server_export 'RemovePriority'

escrow_ignore {
	'base.lua',
	'queue.lua',

	'cfg/blips.lua',
	'cfg/base.lua',
	'cfg/groups.lua',
	'cfg/Native.lua',
	'cfg/aptitudes.lua',
	'cfg/sanitizes.lua',
	'cfg/player_state.lua',
	
	'lib/utils.lua',
	'lib/Proxy.lua',
	'lib/Tools.lua',
	'lib/utils.lua',
	'lib/Tunnel.lua',
	'lib/htmlEntities.lua',

	'client/gui.lua',
	'client/map.lua',
	'client/base.lua',
	'client/police.lua',
	'client/objects.lua',
	'client/identity.lua',
	'client/survival.lua',
	'client/iplloader.lua',
	'client/player_state.lua',
	'client/basic_garage.lua',

	'modules/gui.lua',
	'modules/map.lua',
	'modules/money.lua',
	'modules/survival.lua',
	'modules/identity.lua',
	'modules/aptitude.lua',
	'modules/basic_items.lua',
	'modules/player_state.lua',
	'modules/basic_skinshop.lua'
}
