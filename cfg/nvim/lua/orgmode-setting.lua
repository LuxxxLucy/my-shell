-- Org Mode settings

require('orgmode').setup({
    org_agenda_files = vim.g.org_agenda_files or {},
    org_default_notes_file = vim.g.org_default_notes_file or '~/todo.org',
    org_todo_keywords = {'TODO(t)', 'ONGOING(o)', 'PENDING(p)', '|', 'DONE(d)'},
    org_todo_keyword_faces = {
        ONGOING = ':foreground #ffaf00 :weight bold',
        PENDING = ':foreground #d75fff :weight bold',
    },
    mappings = {
        org = {
            org_todo = '<S-TAB>',
            org_global_cycle = '<leader><TAB>',
            org_toggle_checkbox = '<leader>tt',
            org_move_subtree_up = '<leader>k',
            org_move_subtree_down = '<leader>j',
            -- off '<' and '>' so those stay instant for tab switching
            org_do_promote = '<leader>h',
            org_do_demote = '<leader>l',
            org_promote_subtree = '<leader>H',
            org_demote_subtree = '<leader>L',
        }
    },
})

local org_group = vim.api.nvim_create_augroup('org_local', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
    group = org_group,
    pattern = 'org',
    callback = function()
        vim.opt_local.conceallevel = 2 -- hide the url half of [[url][text]]
        vim.opt_local.concealcursor = 'nc'
        vim.opt_local.wrap = false -- wrap budgets screen rows by the raw line, then conceal skips the url
        vim.keymap.set('i', '<S-CR>', '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>', {
            silent = true,
            buffer = true,
        })
    end,
})

-- the plugin sets @org.hyperlink.desc with default=true, so this wins
local function org_link_highlight()
    vim.api.nvim_set_hl(0, '@org.hyperlink.desc', { fg = '#89b4fa', underline = true })
end
org_link_highlight()
vim.api.nvim_create_autocmd('ColorScheme', {
    group = org_group,
    pattern = '*',
    callback = org_link_highlight,
})
