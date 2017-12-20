":1 Vundle setup
set rtp+=~/.vim/bundle/vundle/
set rtp+=/Applications/MacVim.app/Contents/Resources/vim/runtime
call vundle#rc()

Bundle 'gmarik/vundle'

":1 Plugin - Snipmate
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
":1 Plugin - NERDTree
Bundle 'scrooloose/nerdtree'

" Fast toggle
map <F2> :NERDTreeToggle<CR>

" Common
let g:NERDTreeMapOpenVSplit = 'a'
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeWinPos = 'right'
let g:NERDTreeQuitOnOpen = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodeDefaultSymbol = ''

let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['nerdtree'] = ''
let g:NERDTreeBookmarksFile = $HOME . '/.vim/.nerdtree-bookmarks'

let NERDTreeIgnore=[
      \'\.jar$',
      \'\.db$',
      \'AndroidStudioProjects',
      \'EffectiveAndroidUI',
      \'VirtualBox VMs',
      \'Desktop',
      \'Downloads',
      \'Dropbox',
      \'Documents',
      \'Pictures',
      \'Music',
      \'Movies',
      \]

":1 Plugin - Syntastic
Bundle 'scrooloose/syntastic'
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_python_python_exec = '/usr/bin/python2'
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_java_checkers = ['']
let g:syntastic_auto_loc_list = 0

":1 Plugins
" Features
Plugin 'octol/vim-cpp-enhanced-highlight'
Bundle 'godlygeek/tabular'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mklabs/split-term.vim'
Plugin 'ryym/vim-riot'
Bundle 'hynek/vim-python-pep8-indent'
Plugin 'pangloss/vim-javascript'
Plugin 'wavded/vim-stylus'
Plugin 'burnettk/vim-angular'
Plugin 'jvanja/vim-bootstrap4-snippets'
Plugin 'mxw/vim-jsx'
let g:jsx_ext_required = 0
let g:jsx_pragma_required = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

"1 Standard (frozen) configurations
syntax on                              " Enable syntax hightlight
filetype off                           " Disable file type detection
filetype plugin on                     " Enable plugins
filetype indent on                     " Enable indent

syntax enable
set background=dark
let g:solarized_termcolors=256
let g:airline_powerline_fonts = 1
set nocompatible                       " Enable VIM features
set number                             " Enable line numbers
set autoindent                         " Enable auto indent
set nobackup nowritebackup noswapfile  " Disable backup
set title
set background=dark
set t_Co=256

set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/

" Always show statusline
"
let g:solarized_termcolors = 256  " New line!!

set laststatus=2
set hlsearch                           " Highlight search result
set encoding=utf-8                     " Preferred encoding
set nobomb                             " Unicode without BOM (Byte Order Mark)
set fileformats=unix fileformat=unix   " Preferred filetype
set hidden                             " Undo history save when changing buffers
set wildmenu                           " Show autocomplete menus
set autoread                           " Auto update if changed outside of Vim
set noerrorbells novisualbell          " No sound on errors
set backspace=indent,eol,start         " Allow backspace in insert mode
":1 Configurations may change
set numberwidth=4                      " Line number width
set shellslash                         " Always use unix style slash /
set nojoinspaces                       " no insert two spaces in line join
set t_Co=256                           " (CLI only) Number of colors
set gdefault                           " Add the g flag to search/replace by default

" Easy fold toggle
nmap <Space> za
nmap <CR> za

" Easy fold toggle for enter key. (Exclude `quickfix` filetype)
autocmd BufEnter * if &filetype == 'qf' |unmap <CR>|    endif
autocmd BufEnter * if &filetype != 'qf' | nmap <CR> za| endif
" endfold

":1 Aestetic customizations

" Tab Configuration
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Define list characters
set listchars=tab:▸\ ,eol:¬,trail:~,extends:>,precedes:<

" Define line break
set linebreak showbreak=…     " Wrap long line
set fillchars=vert:\|,fold:\  " Make foldtext more clean

" Recognize numbered list in text formatting
set formatoptions+=n

":1 Keyboard mapping
" Change the leader map
let mapleader = ','
let g:mapleader = ','
let maplocalleader = ','
let g:maplocalleader = ','

" Shortcut to rapidly toggle 'set wrap'
nmap <leader>r :set wrap!<CR>

" Easy indent
nmap > >>
nmap < <<

nmap <M-H> L
nmap <M-T> H

" Window move
nmap <leader>d <C-w><LEFT>
nmap <leader>n <C-w><RIGHT>
nmap <leader>t <C-w><UP>
nmap <leader>h <C-w><DOWN>

" Window tab settings
nnoremap gk gt
nmap <C-t> :tabnew<CR>

" for xterm
set <M-1>=1
set <M-2>=2
set <M-3>=3
set <M-4>=4

map <M-1> 1gk
map <M-2> 2gk
map <M-3> 3gk
map <M-4> 4gk

" Keymap switch
let g:current_keymap = ''
function! ToggleKeymap()
  if g:current_keymap == ''
    set keymap=mongolian-dvorak
    let g:current_keymap = 'mongolian-dvorak'
  else
    set keymap=""
    let g:current_keymap = ''
  endif
endfunction

imap <C-l> <ESC>:call ToggleKeymap()<CR>a
map <C-l> :call ToggleKeymap()<CR>

" Save file
" Need 'stty -ixon' command in shell (CLI).
" more: http://superuser.com/questions/227588/vim-command-line-imap-problem
autocmd BufEnter * nmap <C-s> :w! <bar> redraw!<CR>
autocmd BufEnter * imap <C-s> <ESC>:w! <bar> redraw!<CR>

" Close file
nmap <C-b> :close<CR>
imap <C-b> <ESC>:close<CR>
" endfold

":1 Automatic commands
" Change to the directory of the current file
autocmd BufEnter * silent! lcd %:p:h

" Remove trailing spaces
autocmd BufWritePre * :%s/\s\+$//e

" Filetype
autocmd FileType python setlocal foldmethod=syntax foldtext=PythonFoldText()

so $HOME/.vim/filetype.vimrc
