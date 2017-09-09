require("vis")
require("plugins/filetype")
require("plugins/complete-word")
require("vis-commentary")

-- treat .h files as a cpp header file with cpp syntax highlighting
function cpp_header(win)
    local fname = win.file.name
    if fname ~= nil then
        ft = string.sub(fname, -2)
        if ft == ".h" then
            win:set_syntax("cpp")
        end
    end
end

vis.events.subscribe(vis.events.INIT, function()
    vis:command("set theme base16-solar-flare")
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
    cpp_header(win)
    vis:command("set autoindent on")
    vis:command("set numbers on")
    vis:command("set expandtab on")
    vis:command("set cursorline on")
    vis:command("set tabwidth 4")
    vis:command("set colorcolumn 80")
end)
