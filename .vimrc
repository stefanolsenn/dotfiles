filetype off
filetype plugin indent on
syntax on
packadd! onedark.vim
colorscheme onedark

" Enable 24-bit true colors if your terminal supports it.
if (has("termguicolors"))
  " https://github.com/vim/vim/issues/993#issuecomment-255651605
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  set termguicolors
endif


" Use a line cursor within insert mode and a block cursor everywhere else.
"
" Using iTerm2? Go-to preferences / profile / colors and disable the smart bar
" cursor color. Then pick a cursor and highlight color that matches your theme.
" That will ensure your cursor is always visible within insert mode.
"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" -----------------------------------------------------------------------------
" Status line
" -----------------------------------------------------------------------------

" Heavily inspired by: https://github.com/junegunn/dotfiles/blob/master/vimrc
function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return '[%n] %f %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction

let &statusline = s:statusline_expr()


" Common things: https://vimdoc.sourceforge.net/htmldoc/options.html
set ruler " Ruler in the right down corner
set autoindent  
"set colorcolumn=80
set cursorline
set directory=/tmp//,. " .swp directory
set encoding=utf-8
set expandtab smarttab " Converts tabs to spaces and uses a combination of spaces and tabs for smart indentation 
set incsearch " Shows the matching search pattern incrementally as you type
set ic " Ignore case
set hlsearch " Highlight search
set nocompatible
set backspace=2
set guifont=Consolas:h1
set nu
set relativenumber
set laststatus=2
set smartcase " Makes searching case-sensitive only if the search pattern contains uppercase characters
set ttyfast " wroom wrrooom, redraw text much faster
set undodir=/tmp " undo things, yaaah
set undofile " enable undo persistent, yaaaaaaaah
set scrolloff=5
set cursorcolumn

" Remaps
"
"

" Map space to search in command mode
nnoremap <Space> /
" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <C-L> :nohlsearch<CR>
" Press * to search for the term under the cursor or a visual selection and
" then press a key below to replace all instances of it in the current file.
nnoremap <Leader>r :%s///g<Left><Left>
nnoremap <Leader>rc :%s///gc<Left><Left><Left>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" :ShowAll
" Show all spaces and line endings
command! -nargs=0 ShowAll execute "set list" | execute "set lcs+=space:·"

" Hides all the line endings and spaces
" :ShowAll
" Show all spaces and line endings
command! -nargs=0 ShowAll execute "set list" | execute "set lcs+=space:·"
"
" Hides all the line endings and spaces
command! -nargs=0 HideAll set nolist    
