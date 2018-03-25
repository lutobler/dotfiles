-- default plugins
require 'vis'
require 'plugins/filetype'
require 'plugins/complete-word'

-- plugins
local HOME = os.getenv('HOME')
package.path = package.path .. ';' .. HOME .. '/.config/vis/?.lua'
package.path = package.path .. ';' .. HOME .. '/.config/vis/plugins/?/?.lua'
require 'vis-commentary'
require 'vis-modelines'
require 'vis-surround'
require 'vis-git-status'
require 'plugins.vis-fzf-open.fzf-open'

-- editor config
vis.events.subscribe(vis.events.WIN_OPEN, function()
    vis:command('set autoindent on')
    vis:command('set numbers on')
    vis:command('set expandtab on')
    vis:command('set cursorline on')
    vis:command('set tabwidth 4')
    vis:command('set colorcolumn 80')
end)

-- toggle color schemes with F5
local cschemes = { 'base16-eighties', 'papercolor' }
local i = 1
local function ctoggle()
    i = (i % #cschemes) + 1
    vis:command('set theme ' .. cschemes[i])
end

vis.events.subscribe(vis.events.INIT, function()
    vis:command('set theme ' .. cschemes[1])
end)

vis:map(vis.modes.NORMAL,      '<F5>', ctoggle, 'Toggle two colorschemes')
vis:map(vis.modes.INSERT,      '<F5>', ctoggle, 'Toggle two colorschemes')
vis:map(vis.modes.VISUAL,      '<F5>', ctoggle, 'Toggle two colorschemes')
vis:map(vis.modes.VISUAL_LINE, '<F5>', ctoggle, 'Toggle two colorschemes')

