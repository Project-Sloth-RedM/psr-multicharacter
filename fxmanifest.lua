fx_version 'cerulean'
game 'common'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
author "JericoFX#3512"
description 'PSR-MULTICHARACTER'
version '1.0.0'
lua54 'yes'
ui_page 'html/dist/index.html'

shared "config.lua"
server_scripts {
  '@oxmysql/lib/MySQL.lua',
  "config.lua",
  'server/*.lua'
}
client_scripts {
  "config.lua",
  'client/*.lua',
}

files {
  'html/dist/index.html',
  'html/dist/assets/*.js',
  'html/dist/assets/*.css',
  'html/dist/img/*.png',
  'html/dist/img/*.svg'
}
