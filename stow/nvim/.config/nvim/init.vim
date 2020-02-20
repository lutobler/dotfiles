"
" vimrc / init.vim
" This is supposed to be compatible with both Vim and Neovim
" Author: lutobler, https://github.com/lutobler
" License: MIT (see https://github.com/lutobler/dotfiles)
"

set mouse=a
set number
set modeline
set wildmenu
set showcmd
set shiftwidth=4
set tabstop=4
set expandtab
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
set clipboard=unnamedplus
set hidden
syntax on

"automatically install vim-plug if not installed
if has('nvim')
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
else
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
let plugin_dir = '~/.vim/plugged'
endif

function! Cond(cond, ...)
let opts = get(a:000, 0, {})
return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

function! AspellInstalled()
let out=system('type aspell')
return !v:shell_error
endfunction

if has('nvim')
let plugin_dir = '~/.local/share/nvim/plugged'
else
let plugin_dir = '~/.vim/plugged'
endif

call plug#begin(plugin_dir)
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

Plug 'Shougo/deoplete.nvim',            Cond(has('nvim'), { 'do': ':UpdateRemotePlugins' })
Plug 'deoplete-plugins/deoplete-jedi',  Cond(has('nvim'), { 'for': 'python' })
Plug 'deoplete-plugins/deoplete-clang', Cond(has('nvim'), { 'for': ['c', 'cpp'] })
Plug 'deoplete-plugins/deoplete-go',    Cond(has('nvim'), { 'for': 'go' })
Plug 'Shougo/neco-vim',                 Cond(has('nvim'), { 'for': 'vim' })
Plug 'racer-rust/vim-racer',            Cond(has('nvim'), { 'for': 'rust' })

Plug 'fatih/vim-go'
Plug 'lervag/vimtex', { 'for': ['tex', 'plaintex'] }
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'Konfekt/vim-DetectSpellLang', Cond(AspellInstalled())

Plug 'dylon/vim-antlr'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
Plug 'jceb/vim-orgmode'
Plug 'neomake/neomake'
Plug 'airblade/vim-gitgutter'
" Plug 'ntpeters/vim-better-whitespace'
Plug 'terryma/vim-multiple-cursors'
Plug 'chriskempson/base16-vim'
Plug 'igankevich/mesonic'
Plug 'junegunn/fzf'
call plug#end()

if ($TERM != 'linux' && has("termguicolors"))
    set termguicolors
    " set background=light
    " colorscheme base16-one-light
    set background=dark
    colorscheme base16-eighties
    let base16colorspace=256
end

if !has('gui_running')
  set t_Co=256
endif

function! Multiple_cursors_before()
    let b:deoplete_disable_auto_complete = 1
endfunction

function! Multiple_cursors_after()
    let b:deoplete_disable_auto_complete = 0
endfunction

"spell checking
set spelllang=en
autocmd FileType gitcommit setlocal spell
autocmd FileType plaintex setlocal spell
autocmd FileType markdown setlocal spell
autocmd BufRead /tmp/neomutt-* setlocal spell
let g:guesslang_langs = [ 'en_US', 'de_DE' ]

"deoplete
let g:deoplete#enable_at_startup=1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
let g:haskellmode_completion_ghc = 0
let g:deoplete#sources#rust#racer_binary = '/usr/bin/racer'
let g:deoplete#sources#rust#rust_source_path = '/opt/rust-bin-9999/lib/rustlib/x86_64-unknown-linux-gnu'
let g:deoplete#sources#rust#show_duplicates = 1
let g:deoplete#sources#rust#disable_keymap = 1
let g:deoplete#sources#rust#documentation_max_height = 20
let g:deoplete#sources#jedi#python_path = '/usr/bin/python3'
let g:racer_cmd = $HOME.'/.cargo/bin/racer'
let g:racer_experimental_completer = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<tab>"

"vimtex for deoplete
if exists('g:vimtex#re#deoplete')
    if !exists('g:deoplete#omni#input_patterns')
        let g:deoplete#omni#input_patterns = {}
    endif
    let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete
    let g:deoplete#omni#input_patterns.plaintex = g:vimtex#re#deoplete
endif

"neomake
" let g:neomake_cpp_enabled_makers = ["clang", "cppcheck"]
let g:neomake_cpp_enabled_makers = ["clang"]
let g:neomake_cpp_clang_args = ['-std=c++11', '-Wextra', '-Wall', '-g']
let g:neomake_tex_enabled_makers = ['chktex']
let g:neomake_plaintex_enabled_makers = ['chktex']
" let g:neomake_lua_enabled_makers = []
call neomake#configure#automake('w')

let mapleader = ","
let maplocalleader = ","
noremap  <leader>n :noh<CR>
nnoremap <leader>f :FZF<CR>
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <C-h> gT
nnoremap <C-l> gt
nnoremap gn :tabnew<CR>
nnoremap gl :tabmove -<CR>
nnoremap gr :tabmove +<CR>
" nnoremap <leader>b :BufExplorer<CR>

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    nnoremap vrc :e ~/.config/nvim/init.vim<CR>
else
    nnoremap vrc :e ~/.vimrc<CR>
endif

"commentstrings for vim-commentary
autocmd FileType matlab     setlocal commentstring=%\ %s
autocmd FileType octave     setlocal commentstring=%\ %s
autocmd FileType vim        setlocal commentstring=\"\ %s
autocmd FileType xdefaults  setlocal commentstring=!\ %s
autocmd FileType cmake      setlocal commentstring=#\ %s
autocmd FileType c          setlocal commentstring=//\ %s
autocmd FileType cpp        setlocal commentstring=//\ %s
autocmd FileType mediawiki  setlocal commentstring=<!--\ %s\ -->
autocmd FileType oberon     setlocal commentstring=(*\ %s\ *)

autocmd FileType c          nnoremap <leader>p ofprintf(stdout, "\n");<Esc>4hi
autocmd FileType cpp        nnoremap <leader>p ofprintf(stdout, "\n");<Esc>4hi
autocmd FileType python     nnoremap <leader>d oimport pdb; pdb.set_trace()<esc>
autocmd FileType rust       nmap gd <Plug>(rust-def)
autocmd FileType rust       nmap gs <Plug>(rust-def-split)
autocmd FileType rust       nmap gx <Plug>(rust-def-vertical)
autocmd FileType rust       nmap <leader>gd <Plug>(rust-doc)

autocmd FileType org        set shiftwidth=4 tabstop=4
autocmd FileType go         set colorcolumn&
autocmd FileType markdown   IndentLinesDisable

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"lightline
if ($TERM != 'linux' && $TERM != 'xterm')
    let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'venv', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component': {
        \   'readonly': '%{&filetype=="help"?"":&readonly?"":""}',
        \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
        \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
        \   'venv': '%{$VIRTUAL_ENV!=""?"venv":""}'
        \ },
        \ 'component_visible_condition': {
        \   'readonly': '(&filetype!="help"&& &readonly)',
        \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
        \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
        \   'venv': '($VIRTUAL_ENV!="")'
        \ },
        \ 'separator': { 'left': '', 'right': '' },
        \ 'subseparator': { 'left': '', 'right': '' }
        \ }
end

