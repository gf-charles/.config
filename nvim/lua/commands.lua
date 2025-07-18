-- Displays error messages
local function print_err (msg)
  vim.cmd("echohl ErrorMsg")
  vim.cmd("echo 'Error: " .. msg .. "'");
  vim.cmd("echohl None")
end

-- Deletes swap file for current buffer if it exists.
local function del_buf_swp ()
  local cur_buf_path = vim.fn.expand('%:p')
  if cur_buf_path == '' then
    print_err('could not find filepath of current buffer')
    return 1
  end
  local swapfile_name = string.gsub(cur_buf_path, '/', '%%') .. '.swp'
  local swapfile_path = '/home/cgf/.local/state/nvim/swap/' .. swapfile_name
  local success, err = pcall(os.remove, swapfile_path)
  if success then
    print("removed file " .. swapfile_path)
  else
    print_err("os.remove failed on" .. swapfile_path .. ': ' .. err)
  end
end
local opts = {
  desc = 'delete swap file of current buffer'
}
vim.api.nvim_create_user_command('Rmswp', del_buf_swp, opts)
