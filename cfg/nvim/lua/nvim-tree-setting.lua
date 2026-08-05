-- nvim-tree file explorer settings
--      <C-n>   toggle the tree

vim.keymap.set({ 'n', 'v', 'o' }, '<C-n>', '<cmd>NvimTreeToggle<cr>')

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
                    bookmark = "",
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
        git_ignored = false,
    },
})
