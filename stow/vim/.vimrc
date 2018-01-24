"
" vimrc / init.vim
" This is supposed to be compatible with both Vim / Neovim
" Author: lutobler, https://github.com/lutobler
" License: MIT (see https://github.com/lutobler/dotfiles
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
syntax on

"vim-plug
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-rails'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-obsession'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-clang'
Plug 'Shougo/neco-vim'
Plug 'fishbullet/deoplete-ruby'

Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
Plug 'jceb/vim-orgmode'
Plug 'neomake/neomake'
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'terryma/vim-multiple-cursors'
Plug 'jlanzarotta/bufexplorer' " :BufExplorer
Plug 'vim-scripts/a.vim' " alternate (:A, :AS)
Plug 'neovimhaskell/haskell-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'chriskempson/base16-vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'eagletmt/neco-ghc'
Plug 'lervag/vimtex'
Plug 'Konfekt/vim-DetectSpellLang'
Plug 'rhysd/vim-grammarous'
Plug 'chikamichi/mediawiki.vim'
Plug 'fatih/vim-go'
Plug 'PotatoesMaster/i3-vim-syntax'
call plug#end()

"multiple cursors
function! Multiple_cursors_before()
    let b:deoplete_disable_auto_complete = 1
endfunction

function! Multiple_cursors_after()
    let b:deoplete_disable_auto_complete = 0
endfunction

"deoplete
let g:deoplete#enable_at_startup=1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
let g:haskellmode_completion_ghc = 0
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<tab>"

" vimtex for deoplete
if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete
let g:deoplete#omni#input_patterns.plaintex = g:vimtex#re#deoplete

"haskell
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell set sw=2 ts=2 expandtab
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

"leader keymappings
let mapleader = ","
let maplocalleader = ","
noremap  <leader>n :noh<CR>
nnoremap <leader>b :BufExplorer<CR>
nnoremap <leader>f :FZF<CR>

"key mappings
nnoremap vrc :e ~/.vimrc<CR>
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <C-h> gT
nnoremap <C-l> gt
nnoremap gn :tabnew<CR>
nnoremap gl :tabmove -<CR>
nnoremap gr :tabmove +<CR>
nnoremap <F2> gg"+yG''
nnoremap <F4> :!$PWD/build.sh<CR>

"commentstrings for vim-commentary
autocmd FileType matlab setlocal commentstring=%\ %s
autocmd FileType octave setlocal commentstring=%\ %s
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType xdefaults setlocal commentstring=!\ %s
autocmd FileType cmake setlocal commentstring=#\ %s
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType cpp setlocal commentstring=//\ %s
autocmd FileType mediawiki setlocal commentstring=<!--\ %s\ -->

autocmd FileType c nnoremap <leader>p oprintf("\n");<Esc>4hi
autocmd FileType c noremap <leader>d o__asm__("int $3");<Esc>

autocmd FileType cpp nnoremap <leader>p ostd::cout <<  << std::endl;<Esc>13hi
autocmd FileType cpp set colorcolumn&

autocmd FileType python nnoremap <leader>d oimport pdb; pdb.set_trace()<esc>
autocmd FileType markdown IndentLinesDisable
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd FileType org set shiftwidth=4 tabstop=4

"neomake
let g:neomake_cpp_enabled_makers = ["clang", "cppcheck"]
let g:neomake_cpp_clang_args = ['-std=c++14', '-Wextra', '-Wall', '-g']
" let g:neomake_lua_enabled_makers = ["luacheck"]
let g:neomake_lua_enabled_makers = []
let g:neomake_buildpathmaker_maker = {
\ 'exe': 'make',
\ 'args': ['-j4'],
\ 'cwd': 'build'
\ }
autocmd! BufWritePost * Neomake!
" autocmd! BufWritePost *.cc Neomake! buildpathmaker
" autocmd! BufWritePost *.cpp Neomake! buildpathmaker
" autocmd! BufWritePost *.h Neomake! buildpathmaker
" autocmd! BufWritePost *.hh Neomake! buildpathmaker
autocmd! BufWritePost *.lua Neomake
" au BufRead /tmp/neomutt-* set tw=72

" spell checking
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal spell
autocmd BufRead /tmp/neomutt-* setlocal spell
let g:guesslang_langs = [ 'en_US', 'de_DE' ]

"lightline
if ($TERM != 'linux' && $TERM != 'xterm')
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

if !exists('s:known_links')
  let s:known_links = {}
endif

function! s:Find_links()
  " Find and remember links between highlighting groups.
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx links to Constant" in the
    " output of the :highlight command.
    if len(tokens) == 5 && tokens[1] == 'xxx' && tokens[2] == 'links' && tokens[3] == 'to'
      let fromgroup = tokens[0]
      let togroup = tokens[4]
      let s:known_links[fromgroup] = togroup
    endif
  endfor
endfunction

function! s:Restore_links()
  " Restore broken links between highlighting groups.
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  let num_restored = 0
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx cleared" in the
    " output of the :highlight command.
    if len(tokens) == 3 && tokens[1] == 'xxx' && tokens[2] == 'cleared'
      let fromgroup = tokens[0]
      let togroup = get(s:known_links, fromgroup, '')
      if !empty(togroup)
        execute 'hi link' fromgroup togroup
        let num_restored += 1
      endif
    endif
  endfor
endfunction

function! s:AccurateColorscheme(colo_name)
  call <SID>Find_links()
  exec "colorscheme " a:colo_name
  call <SID>Restore_links()
endfunction

command! -nargs=1 -complete=color MyColorscheme call <SID>AccurateColorscheme(<q-args>)

function! ToggleColorscheme()
    if &background == 'dark'
        set background=light
        MyColorscheme PaperColor
    else
        set background=dark
        MyColorscheme base16-eighties
    end
endfunction
nnoremap <F5> :call ToggleColorscheme()<CR>

"colorschemes
if ($TERM != 'linux' && $TERM != 'xterm' && has("termguicolors"))
    set termguicolors
    set background=light
    call ToggleColorscheme()
    let base16colorspace=256
end
