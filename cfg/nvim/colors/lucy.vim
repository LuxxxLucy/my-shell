" lucy: Catppuccin Mocha with a transparent background.
" Loads the built-in catppuccin palette, then clears the backgrounds that make
" up the editor field so the terminal (Ghostty) background shows through.
" Add your own `highlight` overrides in the block at the bottom.

runtime colors/catppuccin.vim
let g:colors_name = 'lucy'

" Clear the field backgrounds. CursorLine, ColorColumn, Visual, Search, Pmenu,
" and the diff groups keep their catppuccin backgrounds on purpose.
highlight Normal       guibg=NONE ctermbg=NONE
highlight NormalNC     guibg=NONE ctermbg=NONE
highlight NonText      guibg=NONE ctermbg=NONE
highlight EndOfBuffer  guibg=NONE ctermbg=NONE
highlight SignColumn   guibg=NONE ctermbg=NONE
highlight FoldColumn   guibg=NONE ctermbg=NONE
highlight LineNr       guibg=NONE ctermbg=NONE
highlight CursorLineNr guibg=NONE ctermbg=NONE

" Your overrides go below, e.g.:
"   highlight Comment guifg=#7f849c gui=italic
