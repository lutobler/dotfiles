"settings
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
syntax on

"vim-plug
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-obsession'
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
Plug 'maralla/completor.vim'
Plug 'eagletmt/neco-ghc'
call plug#end()

"completor
let g:completor_node_binary = '/usr/bin/node'
let g:completor_clang_binary = '/usr/bin/clang'
let g:completor_python_binary = '/usr/bin/python'
let g:completor_css_omni_trigger = '([\w-]+|@[\w-]*|[\w-]+:\s*[\w-]*)$'
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

"haskell
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

"leader keymappings
let mapleader = ","
let maplocalleader = ","
noremap  <leader>n :noh<CR>
nnoremap <leader>b :BufExplorer<CR>
nnoremap <leader>fz :FZF<CR>

"key mappings
nnoremap vrc :e ~/.vimrc<CR>
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <C-h> gT
nnoremap <C-l> gt
nnoremap gn :tabnew<CR>
nnoremap <F2> gg"+yG''

"commentstrings for vim-commentary
autocmd FileType matlab setlocal commentstring=%\ %s
autocmd FileType octave setlocal commentstring=%\ %s
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType xdefaults setlocal commentstring=!\ %s
autocmd FileType cmake setlocal commentstring=#\ %s
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType cpp setlocal commentstring=//\ %s

" keybindings for specific languages
autocmd FileType c nnoremap <leader>p oprintf("\n");<Esc>4hi
autocmd FileType c noremap <leader>d o__asm__("int $3");<Esc>
autocmd FileType cpp nnoremap <leader>p ostd::cout <<   << std::endl;<Esc>14hi
autocmd FileType python nnoremap <leader>d oimport pdb; pdb.set_trace()<esc>

autocmd FileType markdown IndentLinesDisable
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd FileType org set shiftwidth=4 tabstop=4

"neomake
let g:neomake_cpp_enabled_makers = ["clang", "cppcheck"]
let g:neomake_cpp_clang_args = ['-std=c++14', '-Wextra', '-Wall', '-g']
let g:neomake_lua_enabled_makers = ["luacheck"]
" let g:neomake_lua_enabled_makers = []
autocmd! BufWritePost * Neomake!
autocmd! BufWritePost *.lua Neomake

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
