-- `,r` or `:Run`
--      builds and runs the current file in a new tab.
--      (compiled binaries are stored in /tmp)

local function command()
  local src = vim.fn.shellescape(vim.fn.expand('%:p'))
  local bin = vim.fn.shellescape('/tmp/nvim-run-' .. vim.fn.expand('%:t:r'))
  local ft = vim.bo.filetype
  if ft == 'c' then
    return ('cc -std=c11 -Wall -Wextra -g -fsanitize=address,undefined %s -o %s && %s'):format(src, bin, bin)
  elseif ft == 'cpp' then
    return ('c++ -std=c++20 -Wall -Wextra -g -fsanitize=address,undefined %s -o %s && %s'):format(src, bin, bin)
  elseif ft == 'rust' then
    return ('rustc -g %s -o %s && %s'):format(src, bin, bin)
  elseif ft == 'python' then
    return 'python3 ' .. src
  elseif ft == 'sh' then
    return 'bash ' .. src
  end
end

local out_buf

local function run()
  local cmd = command()
  if not cmd then
    return vim.notify('no run rule for filetype ' .. vim.bo.filetype, vim.log.levels.WARN)
  end
  vim.cmd('update')
  -- wiping the last output buffer kills its job and empties its tab
  if out_buf and vim.api.nvim_buf_is_valid(out_buf) then
    vim.api.nvim_buf_delete(out_buf, { force = true })
  end
  local name = vim.fn.expand('%:t')
  local dir = vim.fn.fnameescape(vim.fn.expand('%:p:h'))
  local echoed = ('echo %s; %s'):format(vim.fn.shellescape('$ ' .. cmd), cmd)
  vim.cmd('tabnew | lcd ' .. dir .. ' | terminal ' .. echoed)
  out_buf = vim.api.nvim_get_current_buf()
  vim.cmd('silent file ' .. vim.fn.fnameescape('run:' .. name))
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = 'no'
end

vim.api.nvim_create_user_command('Run', run, {})
vim.keymap.set('n', ',r', run, { silent = true })
