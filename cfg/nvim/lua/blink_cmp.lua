-- Bootstrap lazy.nvim and load blink.cmp with super-tab keymap preset.
--   <Tab>     → accept completion (or insert tab when menu not visible)
--   <C-n>     → next item
--   <C-p>     → previous item
--
-- Sources: buffer, path, snippets, lsp. Works without LSP (buffer words
-- still surface); attach an LSP via :LspStart for code-aware completion.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "super-tab" },
      completion = {
        list = { selection = { preselect = false, auto_insert = false } },
        menu = { auto_show = true },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}, {
  -- Don't reset rtp: vim-plug plugins (telescope, orgmode, nvim-tree, ...)
  -- are registered on rtp by plug#end() before this runs; lazy's default
  -- reset=true would wipe them and break `require('telescope.builtin')`.
  performance = { rtp = { reset = false } },
})
