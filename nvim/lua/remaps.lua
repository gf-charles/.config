-- stop accidentally crashing everything
vim.keymap.set("n", "<C-z>", "<nop>", { noremap = true, silent = true, desc = "Do nothing on Ctrl+Z" })

-- run current file in shell
vim.keymap.set('n', '<leader>r', ':!sh %', {})

-- netrw remap
vim.keymap.set('n', '<leader>pv', ':Ex<CR>', {})

-- argslist remaps
vim.keymap.set('n', '<leader>N', ':wa<CR>:args %<CR>', {})
vim.keymap.set('n', '<leader>na', ':wa<CR>:arge %<CR>', {})
vim.keymap.set('n', '<leader>g', ':wa<CR>:argd %<CR>', {})
vim.keymap.set('n', '<leader>l', ':args<CR>', {})
vim.keymap.set('n', '<leader>1', ':wa<CR>:argu 1<CR>', {})
vim.keymap.set('n', '<leader>2', ':wa<CR>:argu 2<CR>', {})
vim.keymap.set('n', '<leader>3', ':wa<CR>:argu 3<CR>', {})
vim.keymap.set('n', '<leader>4', ':wa<CR>:argu 4<CR>', {})
vim.keymap.set('n', '<leader>5', ':wa<CR>:argu 5<CR>', {})
vim.keymap.set('n', '<leader>6', ':wa<CR>:argu 6<CR>', {})

-- jump to common places
vim.keymap.set('n', '<leader>j1', ':e ~/.config/nvim/lua/<CR>', {})
vim.keymap.set('n', '<leader>j2', ':e ~/code/mine/test/main.sh<CR>', {})
vim.keymap.set('n', '<leader>j3', ':e ~/neorg/notes/ideas.norg<CR>', {})

-- copy current filepath
vim.keymap.set('n', '<leader>c', function()
  local current_file_path = vim.api.nvim_buf_get_name(0)
  os.execute('wl-copy {/ ' .. current_file_path .. '}')
end, { remap = false})

-- go to upwards git dir
function get_upward_git_dir()
  local current_dir = vim.fn.expand("%:p:h")
  local git_dir = vim.fn.finddir(".git", current_dir .. ";")
  if git_dir == '' then
    return nil
  else
    return vim.fn.fnamemodify(git_dir, ":h")
  end
end
vim.keymap.set('n', '<leader>tg', function()
  vim.api.nvim_command("edit " .. get_upward_git_dir())
end, { remap = false })

-- filetype keybinds
local ftbinds =
{
  netrw = function ( )
    vim.keymap.set('n', 'h', '-', { buffer = true, remap = true})
    vim.keymap.set('n', 'l', '<CR>', { buffer = true, remap = true})
  end,
  -- creates a section for a shell script
  sh = function ( )
    vim.keymap.set('n', '<leader>h', function()
      local heading = vim.fn.input("heading title: ")
      local curpos=vim.fn.line('.')
      vim.api.nvim_buf_set_lines(0, curpos, curpos, true, {
        '############################################################',
        '# ' .. heading,
        '############################################################',
      })
    end, { buffer = true, remap = false})
  end,
}
vim.api.nvim_create_autocmd('filetype', {
  pattern = {"netrw", "sh"},
  callback = function(arg)
    ftbinds[arg.match]()
  end,
})

