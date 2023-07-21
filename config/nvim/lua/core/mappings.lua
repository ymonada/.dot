vim.g.mapleader = " "


-- NeoTree
vim.keymap.set('n', '<leader>o', ':Neotree show focus<CR>')
vim.keymap.set('n', '<leader>p', ':Neotree close<CR>')

vim.keymap.set('n', '<leader>g', ':Neotree float git_status<CR>')

--BufferLine
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>x', ':BufferLinePickClose<CR>')
vim.keymap.set('n', '<leader>X', ':BufferLineCloseRight<CR>')
vim.keymap.set('n', '<leader>s', ':BufferLineSortByTabs<CR>')
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
 

--Tabs
vim.keymap.set('n', '<Tab>e', ':BufferLineCycleNext<CR>')
vim.keymap.set('n', '<Tab>q', ':BufferLineCyclePrev<CR>')

--Terminal
-- vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<CR>')
-- vim.keymap.set('n', '<leader>th', ':ToggleTerm direction=horizontal<CR>')
-- vim.keymap.set('n', '<leader>tv', ':ToggleTerm direction=vertical`<CR>')
