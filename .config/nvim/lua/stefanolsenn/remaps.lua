-- Map space to search in command mode
vim.api.nvim_set_keymap('n', '<Space>', '/', { noremap = true })

-- Use <C-L> to clear the highlighting of :set hlsearch.
vim.api.nvim_set_keymap('n', '<C-L>', ':nohlsearch<CR>', { noremap = true })

-- Press * to search for the term under the cursor or a visual selection and
-- then press a key below to replace all instances of it in the current file.
vim.api.nvim_set_keymap('n', '<Leader>r', ':%s///g<Left><Left>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>rc', ':%s///gc<Left><Left><Left>', { noremap = true })

-- Select some text in visual mode and remove \n in the selection
vim.api.nvim_set_keymap('x', '<Leader>n', ':s/\\%V\\n//g<Left><Left>', { noremap = true })

-- Show all spaces and line endings
vim.api.nvim_command("command! -nargs=0 ShowAll execute 'set list' | execute 'set lcs+=space:·'")

-- Hides all the line endings and spaces
vim.api.nvim_command("command! -nargs=0 HideAll set nolist")

-- Remove all new lines in the file
vim.api.nvim_command("command! -nargs=0 RemoveNewLines execute '%s/\\$//e | %s/\\n//g'")

-- :W sudo saves the file
-- (useful for handling the permission-denied error)
vim.api.nvim_command("command! -nargs=0 W execute 'w !sudo tee % > /dev/null' | edit!")

