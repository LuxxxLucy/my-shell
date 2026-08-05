-- Telescope fuzzy finder settings
--      <leader>f   find files
--      <leader>g   live grep
--      <leader>b   buffers
--      <leader>h   help tags
--      <leader>r   recent files
--      <leader>*   grep the word under the cursor

require('telescope').setup{
    defaults = {
        file_ignore_patterns = {},
    },
    path_display = {
        "filename_first",
    },
    layout_config = {
        prompt_position = "top",
        preview_cutoff = 120,
    },
    sorting_strategy = "ascending",
    pickers = {
        find_files = {
            no_ignore = true,
        },
        live_grep = {
            additional_args = { "--glob", "!Cargo.lock" },
        },
    },
    extensions = {
        frecency = {
            show_scores = true,
            show_filter_column = false,
        },
    },
}

require('telescope').load_extension('frecency')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files)
vim.keymap.set('n', '<leader>g', builtin.live_grep)
vim.keymap.set('n', '<leader>b', builtin.buffers)
vim.keymap.set('n', '<leader>h', builtin.help_tags)
vim.keymap.set('n', '<leader>r', '<cmd>Telescope frecency<cr>')
vim.keymap.set('n', '<leader>*', function()
    builtin.live_grep({ default_text = vim.fn.expand('<cword>') })
end)
