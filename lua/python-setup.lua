-- Simple Python LSP setup function
local function setup_python_lsp()
  -- Check if we're in a Python file with a .venv
  if vim.bo.filetype == 'python' then
    local venv_path = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
    if venv_path ~= '' then
      local python_path = venv_path .. '/bin/python'
      if vim.fn.executable(python_path) == 1 then
        -- Wait a moment for LSP to attach, then set the path
        vim.defer_fn(function()
          pcall(function()
            vim.cmd('LspPyrightSetPythonPath ' .. python_path)
            print("✅ Python LSP using: " .. python_path)
          end)
        end, 2000)
      end
    end
  end
end

-- Create user command to manually set Python path
vim.api.nvim_create_user_command('SetupPythonLSP', setup_python_lsp, {
  desc = 'Setup Python LSP with uv virtual environment'
})

-- Auto setup when entering Python files
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = '*.py',
  callback = setup_python_lsp,
})

print("Python LSP setup loaded. Use :SetupPythonLSP to manually configure.")