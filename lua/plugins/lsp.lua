-- LSP Configuration
return {
  -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  -- used for completion, annotations and signatures of Neovim apis
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },

  -- LSP UI enhancements
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {}
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons', -- optional
    },
  },

  -- LSP signature help
  {
    'ray-x/lsp_signature.nvim',
    event = 'InsertEnter',
    opts = {
      bind = true,
      handler_opts = {
        border = 'rounded',
      },
    },
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },

  -- Enhanced code actions UI
  {
    'aznhe21/actions-preview.nvim',
    config = function()
      require('actions-preview').setup({
        backend = { 'telescope', 'nui' },
        telescope = require('telescope.themes').get_dropdown(),
      })
      vim.keymap.set({ 'v', 'n' }, '<leader>ca', require('actions-preview').code_actions, { desc = '[C]ode [A]ctions' })
    end,
  },

  -- Main LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local handlers = require('lsp.handlers')
      local servers = require('lsp.servers')
      local settings = require('lsp.settings')

      -- Create autocommand for LSP attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = handlers.on_attach,
      })

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers.servers)
      vim.list_extend(ensure_installed, {
        'stylua',
        'ruff',
        'black',
        'isort',
        'pyright',
        'debugpy',
      })

      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers.servers), -- which LSPs to install
        automatic_installation = true, -- install any you configure
        automatic_enable = true, -- satisfy the typechecker
        handlers = {
          function(server_name) -- your existing handler
            local opts = servers.servers[server_name] or {}
            opts.capabilities = vim.tbl_deep_extend('force', {}, settings.capabilities, opts.capabilities or {})
            require('lspconfig')[server_name].setup(opts)
          end,
        },
      }
    end,
  },
}