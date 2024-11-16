"====================================
" Neovim Configuration
" Author: Jialin Lu (luxxxlucy@gmail.com)
" Heavily influenced by ggerganov/ggterm
"
" Table of Contents:
" 1. General Settings
" 2. Navigation & Tabs
" 3. Plugin Management & Configurations
" 4. UI & Visual Settings
" 5. Lua Configurations
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
set spell " Enable spell checking.

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
set clipboard+=unnamed
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
" remove trailing whitespaces automatically
autocmd BufWritePre * :%s/\s\+$//e

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
runtime! plugin/rplugin.vim
silent! UpdateRemotePlugins

" 3. Plugin Management & Configurations
let plug_install = 0
let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(autoload_plug_path)
        execute '!curl -fL --create-dirs -o ' . autoload_plug_path .
                \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
        execute 'source ' . fnameescape(autoload_plug_path)
        let plug_install = 1
endif
unlet autoload_plug_path
call plug#begin(stdpath('config') . '/plugged')

" Tree-sitter for better syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter'

" File explorer
Plug 'nvim-tree/nvim-tree.lua'
map <C-n> :NvimTreeToggle<CR>

" Input method management
Plug 'ybian/smartim'
let g:smartim_default = 'com.apple.keylayout.ABC'

" Command completion
Plug 'gelguy/wilder.nvim'

" Cursorline management
Plug 'delphinus/auto-cursorline.nvim'

" Auto-pairs
Plug 'tmsvg/pear-tree'

" Fuzzy finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
nnoremap <leader>f <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>b <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>h <cmd>lua require('telescope.builtin').help_tags()<cr>

" CSS color preview
Plug 'ap/vim-css-color'

" Status line
Plug 'vim-airline/vim-airline'

call plug#end()
call plug#helptags()

if plug_install
        PlugInstall --sync
endif
unlet plug_install

" 4. UI & Visual Settings
" Neovide specific settings
if exists("g:neovide")
        let g:neovide_transparency=0.0
        let g:transparency = 1 
        let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:transparency))
        let g:neovide_floating_blur_amount_x = 2.0
        let g:neovide_floating_blur_amount_y = 2.0
        let g:neovide_scroll_animation_length = 0.3
        let g:neovide_remember_window_size = v:true
        let g:neovide_cursor_antialiasing=v:true
endif

" 5. Lua Configurations
lua <<EOF
    -- Set up specs
    vim.opt.list = true
    vim.opt.listchars:append "space:⋅"
    vim.opt.listchars:append "eol:↴"
    vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
    vim.opt.shortmess = vim.opt.shortmess + { c = true}
    vim.api.nvim_set_option('updatetime', 300) 
    vim.cmd([[
        set signcolumn=yes
        autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
    ]])

    -- Set up NerdTree
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    
    vim.g.nvim_tree_show_icons = {
        git = 0,
        folders = 0,
        files = 0,
        folder_arrows = 0,
    }
    require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
            adaptive_size = true,
        },
        renderer = {
            group_empty = true,
            highlight_diagnostics = false,
            indent_markers = {
                    enable = false,
                    inline_arrows = true,
                    icons = {
                        corner = "└",
                        edge = "│",
                        item = "│",
                        bottom = "─",
                        none = " ",
                    },
                },
            icons = {
                    padding = " ",
                    symlink_arrow = " ➜ ",
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                        modified = true,
                        diagnostics = true,
                        bookmarks = true,
                    },
                    glyphs = {
                        default = "▤",
                        symlink = "~",
                        bookmark = "",
                        modified = "●",
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                            default = "▶",
                            open = "▼",
                            empty = "▶",
                            empty_open = "▼",
                            symlink = "└",
                            symlink_open = "└",
                        },
                        git = {
                            unstaged = "✗",
                            staged = "✓",
                            unmerged = "U",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "D",
                            ignored = "◌",
                        },
                    }
            }
        },
        filters = {
            dotfiles = false,
        },
    })

    require('telescope').setup{
        path_display = {
            "filename_first",
        },
        layout_config = {
            prompt_position = "top",
            preview_cutoff = 120,
        },
        sorting_stratefy = "ascending",
    }
EOF
