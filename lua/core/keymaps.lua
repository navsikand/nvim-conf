-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Better window management
vim.keymap.set('n', '<leader>ww', '<C-W>p', { desc = '[W]indow: Focus previous window' })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = '[W]indow: [D]elete' })
vim.keymap.set('n', '<leader>w-', '<C-W>s', { desc = '[W]indow: Split horizontally' })
vim.keymap.set('n', '<leader>w|', '<C-W>v', { desc = '[W]indow: Split vertically' })
vim.keymap.set('n', '<leader>w=', '<C-W>=', { desc = '[W]indow: Equal size' })

-- Navigate windows with Alt + hjkl (alternative to Ctrl)
vim.keymap.set('n', '<M-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<M-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<M-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<M-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S>', ':w<CR>', { noremap = true, silent = true })

-- Better file operations
vim.keymap.set('n', '<leader>ww', '<C-W>p', { desc = '[W]indow: Focus previous' })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = '[W]indow: [D]elete' })
vim.keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split horizontally' })
vim.keymap.set('n', '<leader>|', '<C-W>v', { desc = 'Split vertically' })

-- Quick save and quit
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = '[Q]uit' })
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', { desc = '[Q]uit all without saving' })
vim.keymap.set('n', '<leader>ws', ':w<CR>', { desc = '[W]rite [S]ave' })
vim.keymap.set('n', '<leader>wS', ':wa<CR>', { desc = '[W]rite [S]ave all' })

-- Better buffer management
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[B', '<cmd>bfirst<cr>', { desc = 'First buffer' })
vim.keymap.set('n', ']B', '<cmd>blast<cr>', { desc = 'Last buffer' })

-- Tab and shift-tab for folding and indentation
vim.api.nvim_set_keymap('n', '<Tab>', 'za', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Tab>', '<C-T>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', '<C-D>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

-- Delete word in insert mode
vim.keymap.set('i', '<C-BS>', '<C-w>', { noremap = true, silent = true })

-- Better text movement
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines keeping cursor position' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move up and center' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result and center' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result and center' })

-- Better line manipulation
vim.keymap.set('n', '<M-S-Up>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('n', '<M-S-Down>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('v', '<M-S-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('v', '<M-S-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })

-- Alternative line movement keys (if Alt+Shift doesn't work in terminal)
-- vim.keymap.set('n', '<M-k>', ':m .-2<CR>==', { desc = 'Move line up (Alt+k)' })
-- vim.keymap.set('n', '<M-j>', ':m .+1<CR>==', { desc = 'Move line down (Alt+j)' })
-- vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up (Alt+k)' })
-- vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down (Alt+j)' })

-- Keep leader j/k for other uses (if needed)
-- vim.keymap.set('n', '<leader>k', ':m .-2<CR>==', { desc = 'Move line up' })
-- vim.keymap.set('n', '<leader>j', ':m .+1<CR>==', { desc = 'Move line down' })
-- vim.keymap.set('v', '<leader>k', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
-- vim.keymap.set('v', '<leader>j', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })

-- Clear search highlight on ESC (already there but improved)
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Better yank and paste
vim.keymap.set('n', '<leader>y', '"+y', { desc = '[Y]ank to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = '[Y]ank selection to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = '[Y]ank line to system clipboard' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = '[P]aste from system clipboard' })
vim.keymap.set('n', '<leader>P', '"+P', { desc = '[P]aste from system clipboard before cursor' })