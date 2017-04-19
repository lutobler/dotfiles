call plug#begin('~/.config/nvim/plugged')

" tim pope
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'jiangmiao/auto-pairs'

Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'neomake/neomake'
Plug 'Yggdroot/indentLine'
Plug 'jceb/vim-orgmode'
Plug 'osyo-manga/vim-over' " :OverCommandLine
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " :FZF
Plug 'jlanzarotta/bufexplorer' " :BufExplorer
Plug 'vim-scripts/a.vim' " alternate (:A, :AS)
Plug 'sjl/gundo.vim'
Plug 'dag/vim-fish'
Plug 'neovimhaskell/haskell-vim'
Plug 'runoshun/vim-alloy'
" Plug 'xolox/vim-lua-ftplugin'
" Plug 'xolox/vim-misc'

" deoplete
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-clang'
Plug 'eagletmt/neco-ghc'

" colorschemes
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'zanglg/nova.vim'
Plug 'tomasr/molokai'
Plug 'rakr/vim-one'
Plug 'chriskempson/base16-vim'
Plug 'AlessandroYorba/Despacio'
Plug 'rakr/vim-two-firewatch'
call plug#end()

" toggle dark/light background
function! ToggleBackground()
    if g:bg_toggle == "dark"
        let g:bg_toggle = "light"
        set background=light
        colorscheme PaperColor
    else
        let g:bg_toggle = "dark"
        set background=dark
        colorscheme base16-solarflare
    endif
endfunction

" lightline
if (!($TERM=='linux' || $TERM=='screen' || $TERM=='xterm') || has("gui_running"))
    let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component': {
        \   'readonly': '%{&filetype=="help"?"":&readonly?"":""}',
        \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
        \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
        \ },
        \ 'component_visible_condition': {
        \   'readonly': '(&filetype!="help"&& &readonly)',
        \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
        \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
        \ },
        \ 'separator': { 'left': '', 'right': '' },
        \ 'subseparator': { 'left': '', 'right': '' }
        \ }
end

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" neomake
let g:neomake_error_sign = {'text': 'e', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': 'w', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': 'm', 'texthl': 'NeomakeMessageSign'}

" other
let mapleader = ","
let maplocalleader = ","
let g:livepreview_previewer='zathura'
let base16colorspace=256

set number
set modeline
set wildmenu
set showcmd
set shiftwidth=4
set tabstop=4
set smarttab
" set expandtab
set cursorline
set laststatus=2
set smartindent
set autoindent
set nobackup
set nowb
set noswapfile
set ignorecase
set smartcase
set hlsearch
set incsearch
set colorcolumn=80
set path+=**

" colorscheme settings
let g:bg_toggle="dark"
set background=dark
if (has("nvim"))
    if (has("termguicolors"))
        set termguicolors
    endif
endif
colorscheme base16-solarflare

" use tab to cycle in deoplete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<tab>"

" common files
nnoremap vrc :e ~/.config/nvim/init.vim<CR>
nnoremap xrc :e ~/.Xresources<CR>
nnoremap brc :e ~/.bashrc<CR>
nnoremap irc :e ~/.i3/config<CR>
nnoremap frc :e ~/.config/fish/config.fish<CR>

" terminal keybindings for neovim
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l
tnoremap jk <C-\><C-n>

" other
nnoremap <F5> :call ToggleBackground()<CR>
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap gn :tabnew<CR>
nnoremap <C-h> gT
nnoremap <C-l> gt
noremap  <leader>n :noh<CR>
nnoremap <leader>b :BufExplorer<CR>
nnoremap <leader>fz :FZF<CR>
inoremap jk <Esc>

" language settings
autocmd FileType haskell set sw=2 ts=2 expandtab
" autocmd FileType lua set noexpandtab sw=4 tw=4

" keybindings for specific languages
autocmd FileType c nnoremap <leader>p oprintf("\n");<Esc>4hi
autocmd FileType c noremap <leader>d o__asm__("int $3");<Esc>
autocmd FileType cpp nnoremap <leader>p ostd::cout <<   << std::endl;<Esc>14hi
autocmd FileType python nnoremap <leader>d oimport pdb; pdb.set_trace()<esc>

" commentstrings for vim-commentary
autocmd FileType matlab setlocal commentstring=%\ %s
autocmd FileType octave setlocal commentstring=%\ %s
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType xdefaults setlocal commentstring=!\ %s
autocmd FileType cmake setlocal commentstring=#\ %s

" other
autocmd! BufWritePost * Neomake!
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert
autocmd FileType org set shiftwidth=4 tabstop=4
