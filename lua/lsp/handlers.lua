-- LSP handlers and attach function

local M = {}

-- This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
M.on_attach = function(event)
  -- NOTE: Remember that Lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  -- Find references for the word under your cursor.
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Enhanced navigation: Plain jumps (direct, no telescope)
  map('gpd', vim.lsp.buf.definition, '[G]oto [P]lain [D]efinition')
  map('gps', vim.lsp.buf.declaration, '[G]oto [P]lain [D]eclaration')
  map('gpi', vim.lsp.buf.implementation, '[G]oto [P]lain [I]mplementation')

  -- Diagnostic navigation
  map('[d', vim.diagnostic.goto_prev, '[D]iagnostic: [P]revious')
  map(']d', vim.diagnostic.goto_next, '[D]iagnostic: [N]ext')
  map('<leader>e', vim.diagnostic.open_float, '[E]rror diagnostic')
  map('<leader>dl', vim.diagnostic.setloclist, '[D]iagnostic: [L]ist')

  -- Signature help and hover documentation
  map('<C-k>', vim.lsp.buf.signature_help, '[S]ignature [H]elp')
  map('K', vim.lsp.buf.hover, '[H]over documentation')

  -- Formatting and code actions
  map('<leader>f', function()
    vim.lsp.buf.format { async = true }
  end, '[F]ormat buffer')
  map('<leader>qf', vim.lsp.buf.code_action, '[Q]uick [F]ix')

  -- Enhanced code actions in visual mode
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'v', 'n' })

  -- Remove duplicate <leader>ca mapping from actions-preview plugin
  -- This was causing the conflict with the handler's mapping
  -- The plugin's mapping is now redundant since we have better mappings

  -- The following two autocommands are used to highlight references of the
  -- word under your cursor when your cursor rests there for a little while.
  --    See `:help CursorHold` for information about when this is executed
  --
  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
      end,
    })
  end

  -- The following code creates a keymap to toggle inlay hints in your
  -- code, if the language server you are using supports them
  --
  -- This may be unwanted, since they displace some of your code
  if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    map('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
    end, '[T]oggle Inlay [H]ints')
  end

  -- Enhanced workspace commands
  map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  map('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Additional useful keymaps
  map('<leader>td', function()
    local enabled = vim.diagnostic.is_enabled()
    vim.diagnostic.enable(not enabled)
  end, '[T]oggle [D]iagnostics')
  map('<leader>oc', require('telescope.builtin').lsp_outgoing_calls, '[O]utgoing [C]alls')
  map('<leader>lr', function()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
  end, '[L]SP [R]estart')
end

return M