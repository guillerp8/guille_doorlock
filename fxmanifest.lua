fx_version 'cerulean'

game 'gta5'

author 'guillerp#1928'

lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    'Shared/Config.lua'
}

client_scripts {
    'Client/CMain.lua'
}

server_scripts {
    'Server/SMain.lua'
}

ui_page 'Ui/index.html'

files {
    'Ui/*.html',
    'Ui/*.js',
    'Ui/*.css',
}
