-- ~/.config/nvim/lua/autopairs.lua

local M = {}

-- Define the pairs to auto-close
M.pairs = {
  ['('] = ')',
  ['['] = ']',
  ['{'] = '}',
  ['"'] = '"',
  ["'"] = "'",
  ['<'] = '>',
}

-- Function to handle auto-closing
function M.setup()
  -- Loop through each pair
  for open_char, close_char in pairs(M.pairs) do
    -- Create the keymap for insert mode
    vim.keymap.set('i', open_char, function()
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local char_after_cursor = string.sub(line, cursor_pos[2] + 1, cursor_pos[2] + 1)

      -- Check if the character after the cursor is already the closing character
      -- This handles cases like typing `foo("|")` where `|` is the cursor
      if char_after_cursor == close_char then
        return open_char .. close_char .. '<Right>' -- Insert both, move past existing close char
      else
        return open_char .. close_char .. '<Left>' -- Insert both, move cursor back inside
      end
    end, { expr = true, silent = true, desc = 'Auto-pair ' .. open_char .. close_char })

    -- Optional: Smart backspace to delete both if the pair is empty
    vim.keymap.set('i', close_char, function()
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local char_before_cursor = string.sub(line, cursor_pos[2], cursor_pos[2])

      -- Check if cursor is immediately after the opening char of this pair,
      -- and the character before it is the corresponding opening char.
      -- This logic might need refinement for nested or complex scenarios,
      -- but it's a simple start.
      if char_before_cursor == open_char and close_char == open_char then -- For quotes
          local char_before_that = string.sub(line, cursor_pos[2] - 1, cursor_pos[2] - 1)
          if char_before_that == open_char then
            return '<BS>'
          end
      elseif char_before_cursor == open_char then
        -- Simple check: if we just typed ')' and char before is '(', delete '('
        -- This logic is very basic for deleting an empty pair.
        -- A robust solution usually involves checking for specific syntax context.
        -- For a simple autopairs, often just letting users backspace normally is fine.
      end
      return close_char -- Just insert the closing char normally
    end, { expr = true, silent = true, desc = 'Insert ' .. close_char })
  end

  -- Optional: Overwrite `backspace` to delete the pair if empty (more robust approach)
  -- This makes backspace smarter.
  vim.keymap.set('i', '<BS>', function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local col = cursor_pos[2]
    if col > 0 then
      local line = vim.api.nvim_get_current_line()
      local char_before = string.sub(line, col, col)
      local char_after = string.sub(line, col + 1, col + 1)

      for open_char, close_char in pairs(M.pairs) do
        if char_before == open_char and char_after == close_char then
          -- If we are between an autopaired set, delete both
          return '<BS><Del>'
        end
      end
    end
    return '<BS>' -- Default backspace
  end, { expr = true, silent = true, desc = 'Smart backspace' })


end

M.setup()
