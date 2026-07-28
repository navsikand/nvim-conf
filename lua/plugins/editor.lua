-- Editor enhancement plugins

return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Git signs
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Todo comments
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  -- Toggle terminal
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup {
        size = 10, -- Default terminal height
        open_mapping = [[<C-`>]], -- You can change this if you prefer a different key for opening the terminal
        direction = 'horizontal', -- Make the terminal horizontal
      }
    end,
  },

  -- Treesitter
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    main = 'nvim-treesitter',
    build = ':TSUpdate',
    init = function()
      local ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'tsx',
        'typescript',
        'javascript',
      }
      local already = require('nvim-treesitter.config').get_installed()
      local to_install = vim.iter(ensure_installed):filter(function(p)
        return not vim.tbl_contains(already, p)
      end):totable()
      require('nvim-treesitter').install(to_install)

      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  -- Auto tag
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        per_filetype = {
          ['html'] = {
            enable_close = false,
          },
        },
      }
    end,
  },

  -- Mini.nvim collection
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  -- Visual multi cursor
  {
    'mg979/vim-visual-multi',
    event = 'VeryLazy', -- This loads the plugin lazily
    config = function()
      -- You can add any plugin-specific configuration here if needed.
      -- For example, setting up custom mappings (optional).
      -- The default configuration works well out of the box.
    end,
  },

  -- Bullets for markdown
  {
    'bullets-vim/bullets.vim',
    ft = { 'markdown', 'text' },
    config = function()
      -- Optional configuration if you want to adjust bullet style or behavior
      vim.g.bullets_enabled_file_types = { 'markdown', 'text' }
      -- For example, to disable extra padding:
      -- vim.g.bullets_pad_right = 0
    end,
  },

  -- Wrap width
  { 'rickhowe/wrapwidth', config = function() end },

  -- Better indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('ibl').setup {
        indent = {
          char = '┊',
        },
        scope = {
          enabled = true,
          show_start = true,
        },
      }
    end,
  },
}
