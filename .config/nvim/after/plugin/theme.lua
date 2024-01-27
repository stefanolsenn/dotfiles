require('onedark').setup {
    style = 'darker'
}

require('onedark').load()
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#51B3EC', bold=false })
vim.api.nvim_set_hl(0, 'LineNr', { fg='white', bold=false })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#FB508F', bold=false })
vim.o.numberwidth = 2
