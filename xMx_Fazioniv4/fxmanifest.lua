resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
fx_version 'adamant'
game 'gta5'
lua54 'yes'

shared_scripts {
	'config.lua',
    '@es_extended/imports.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/*.lua',
	'config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

escrow_ignore {
	'config'
  }