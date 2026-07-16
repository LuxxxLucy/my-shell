"====================================
" Neovim Configuration (Bare - no plugins)
" Author: Jialin Lu (luxxxlucy@gmail.com)
"
" Works on any vim/nvim without plugin managers.
" For full version with plugins, use init.vim.
"====================================

" 1. General Settings
set nocompatible " Use Vim settings rather than Vi settings.
filetype on
filetype plugin on
filetype indent on

set encoding=utf-8
set fileencodings=utf-8
scriptencoding utf-8

" Indentation
set tabstop=4 " Show existing tabs with 4 spaces width.
set softtabstop=4
set shiftwidth=4 " When indenting with '>' use 4 spaces width.
set expandtab " On pressing <Tab>, insert 4 spaces.
set smartindent
set autoindent
set smarttab

" Performance
set ttyfast
set lazyredraw

" Search
set incsearch " Find the next match as we type the search.
set ignorecase
set hlsearch " Highlight the search by default.
" Use `,/` to remove the highlight of previous search.
nmap <silent> ,/ :nohlsearch<CR>
set gdefault
set magic

" File handling
set autoread " Automatically re-read files if unmodified inside Vim.
set nobackup " Disable swap and backup (all of backup, swapfile and wb).
set noswapfile
set nowb
set autowrite
set exrc
set secure
set confirm " Display a confirmation dialog when closing an unsaved file.
set spell " enable spell checking (bare version uses built-in spell, full version uses Spelunker)

" Use bo shortcut to browse recently edited files.
nmap <silent> bo :browse old<CR>

set undofile " Enable persistent undo, maintaining undo history between sessions.
let s:undodir = expand('~/.vim/undodir') " Set path for undodir.
set undodir=~/.vim/undodir
" Create undodir if it doesn't exist
if !isdirectory(s:undodir)
    call mkdir(s:undodir, "p", 0700)
endif
function! CleanOldUndoFiles() " Function to clean undo files older than 90 days.
    let l:old_files = split(globpath(s:undodir, '*'), '\n')
    let l:now = localtime()
    for l:file in l:old_files
        if (l:now - getftime(l:file)) > (90 * 24 * 60 * 60) " delete file if file is older than 90 days.
            call delete(l:file)
        endif
    endfor
endfunction
autocmd VimEnter * call CleanOldUndoFiles() " Auto-clean when Vim starts

" UI Elements
set number
set relativenumber

set cursorline " Highlight the line currently under cursor.
set colorcolumn=120
set ruler " Always show cursor position.
set cmdheight=1
set laststatus=2
set showmatch
set matchtime=1
set scrolloff=3 " The number of screen lines to keep above and below the cursor.
set sidescrolloff=5 " The number of screen columns to keep left and right of the cursor.
set mouse=a " Enable mouse for scrolling and resizing.
set clipboard+=unnamedplus
set title " set window's title as the file currently being edited.
set linebreak " Wrap lines at convenient points.
syntax enable " Enable syntax highlighting.

" Color scheme
colorscheme habamax

" Make . to work with visually selected lines in visual mode.
vnoremap . :normal .<CR>

" Auto reload changed file
au CursorHold,CursorHoldI * checktime

" Switch between number modes
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Show trailing spaces in red
autocmd VimEnter,WinEnter,BufRead,Syntax * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd Syntax * syntax match ExtraWhitespace excludenl /\s\+$/ display containedin=ALL
" remove trailing whitespaces automatically (for C/C++ files)
autocmd FileType c,cpp autocmd BufWritePre <buffer> %s/\s\+$//e

" Folder
set foldenable " Enable folding.
set foldlevelstart=10 " Open most of the folds by default.
set foldnestmax=10 " Folds can be nested.
set foldmethod=manual " Use `manual` folding.
augroup remember_folds " Remember folding.
    autocmd!
    autocmd BufWinLeave .vimrc,*.h,*.cpp mkview
    autocmd BufWinEnter .vimrc,*.h,*.cpp silent! loadview
augroup END

" 2. Navigation & Tabs
nnoremap <silent> < gT<CR>
nnoremap <silent> > gt<CR>

" like vscode like keystroke (alt-up and alt-down) to move select lines and down
" to make more comfortable in vim, change to ctrl-j and ctrl-k.
" work in normal mode as well as visual model (multiple line selected)
noremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" jump back to last edited buffer
nnoremap <C-b> <C-^>
inoremap <C-b> <esc><C-^>

nnoremap tn :tabnew<CR>
nnoremap td :tabclose<CR>
nnoremap t1 :tabnext 1<CR>
nnoremap t2 :tabnext 2<CR>
nnoremap t3 :tabnext 3<CR>
nnoremap t4 :tabnext 4<CR>
nnoremap t5 :tabnext 5<CR>
nnoremap t6 :tabnext 6<CR>
nnoremap t7 :tabnext 7<CR>
nnoremap t8 :tabnext 8<CR>
nnoremap t9 :tabnext 9<CR>

" Last active tab
if !exists('g:lasttab')
    let g:lasttab = 1
endif
nmap tl :exe "tabn ".g:lasttab<CR>
nmap t<Tab> :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Show filename in tab
function! Tabline() abort
    let l:line = ''
    let l:current = tabpagenr()

    for l:i in range(1, tabpagenr('$'))
        if l:i == l:current
            let l:line .= '%#TabLineSel#'
        else
            let l:line .= '%#TabLine#'
        endif

        let l:label = fnamemodify(
            \ bufname(tabpagebuflist(l:i)[tabpagewinnr(l:i) - 1]),
            \ ':t'
        \ )

        let l:line .= '%' . i . 'T'
        let l:line .= '  ' . l:label . '  '
    endfor

    let l:line .= '%#TabLineFill#'
    let l:line .= '%T'

    return l:line
endfunction

set tabline=%!Tabline()

nmap <space> :
vmap <space> :

" Use netrw as file explorer (bare replacement for nvim-tree)
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
map <C-n> :Lexplore<CR>

" Visible whitespace
set list
set listchars=space:·,eol:↴,tab:→\ ,trail:~
