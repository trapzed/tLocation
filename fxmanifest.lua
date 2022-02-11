fx_version 'adamant'

author 'TrapZed#1725 - tDev : https://discord.gg/WEP4CuuQzd'
description 'tLocation'
version '1.0'

game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/img/**.**',
	'html/js/jquery-3.6.0.min.js',
	'html/js/listener.js'
}

shared_scripts {
    'shared/sh_config.lua',
}

server_scripts {
    '@es_extended/locale.lua',
    'server/sv_config.lua',
	'server/sv_tlocation.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'client/cl_config.lua',
	"client/cl_tlocation.lua",
}