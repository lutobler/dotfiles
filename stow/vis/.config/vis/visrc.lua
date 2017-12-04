-- default plugins
require 'vis'
require 'plugins/filetype'
require 'plugins/complete-word'

-- plugins
local plug = require 'vis-plug'
plug:load_plugins({
    { github = 'lutobler/vis-commentary', require_ = 'vis-commentary' },
    { github = 'lutobler/vis-modelines', require_ = 'vis-modelines' },
    { github = 'lutobler/vis-surround', require_ = 'vis-surround' },
    { github = 'guillaumecherel/vis-fzf-open' }
})

local vis_fzf_open = require 'plugins/vis-fzf-open/fzf-open'

local cschemes = { "base16-eighties", "papercolor" }
local i, n = 1, #cschemes
local function ctoggle() -- cycle through the colorschemes in 'cschemes'
    i = (i % n) + 1
    vis:command("set theme " .. cschemes[i])
end

vis.events.subscribe(vis.events.INIT, function()
    vis:command("set theme "..cschemes[1])
end)

vis.events.subscribe(vis.events.WIN_OPEN, function()
    vis:command("set autoindent on")
    vis:command("set numbers on")
    vis:command("set expandtab on")
    vis:command("set cursorline on")
    vis:command("set tabwidth 4")
    vis:command("set colorcolumn 80")
end)

-- toggle color schemes
vis:map(vis.modes.NORMAL,      "<F5>", ctoggle, "Toggle two colorschemes")
vis:map(vis.modes.INSERT,      "<F5>", ctoggle, "Toggle two colorschemes")
vis:map(vis.modes.VISUAL,      "<F5>", ctoggle, "Toggle two colorschemes")
vis:map(vis.modes.VISUAL_LINE, "<F5>", ctoggle, "Toggle two colorschemes")

-- Use C-v, C-c for copy paste ('autoindent' breaks pasting multi-line text)
local paste = '<Escape>:set ai off<Enter>"+p:set ai on<Enter>a'
local copy = '"+y'
vis:map(vis.modes.VISUAL_LINE, "<C-c>", copy,  "Copy selection to clipboard")
vis:map(vis.modes.VISUAL,      "<C-c>", copy,  "Copy selection to clipboard")
vis:map(vis.modes.INSERT,      "<C-v>", paste, "Paste from clipboard")
