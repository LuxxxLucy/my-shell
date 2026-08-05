-- Language servers for
--      C/C++
--      Rust
--      Python.
-- Use `:Lsp` to toggle starting the server

local servers = {
  c = 'clangd',
  cpp = 'clangd',
  objc = 'clangd',
  objcpp = 'clangd',
  rust = 'rust_analyzer',
  python = 'basedpyright',
}

vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=never' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
})

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
})

vim.lsp.config('basedpyright', {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', '.git' },
  -- the default mode flags every unannotated parameter
  settings = { basedpyright = { analysis = { typeCheckingMode = 'standard' } } },
})

-- short text on the line itself, full text in a float once the cursor hovers
vim.diagnostic.config({
  virtual_text = { spacing = 4, prefix = '●' },
  float = { border = 'rounded', source = true, focusable = false, header = '' },
})

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function() vim.diagnostic.open_float(nil, { scope = 'line' }) end,
})

local function toggle()
  local name = servers[vim.bo.filetype]
  if not name then
    return vim.notify('no language server for ' .. vim.bo.filetype, vim.log.levels.WARN)
  end
  if next(vim.lsp.get_clients({ name = name })) then
    vim.lsp.enable(name, false)
    return vim.notify(name .. ' stopped')
  end
  -- blink.cmp asks for more than the built-in client, and loads on InsertEnter
  vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })
  vim.lsp.enable(name)
  vim.notify(name .. ' started')
end

vim.api.nvim_create_user_command('Lsp', toggle, {})

-- Neovim maps grr, gri, grn, gra and K itself
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
  end,
})
