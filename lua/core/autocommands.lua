-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Enable folding by indent for markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.foldmethod = 'indent'
    vim.opt_local.foldlevel = 99 -- Start with folds open
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    -- set virtual-wrap at col 80
    vim.cmd 'Wrapwidth 100'
  end,
})

-- Python LSP configuration for uv virtual environments
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    -- Check if we have a .venv directory in the project root
    local venv_path = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
    if venv_path ~= '' then
      local python_path = venv_path .. '/bin/python'
      if vim.fn.executable(python_path) == 1 then
        -- Wait a bit for LSP to start, then set Python path
        vim.defer_fn(function()
          vim.cmd('LspPyrightSetPythonPath ' .. python_path)
          print("Using Python from: " .. python_path)
        end, 1000)
      end
    end
  end,
})

-- Load Python LSP setup
require('python-setup')