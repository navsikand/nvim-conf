-- UI-related plugins (themes, statusline, etc.)

return {
  -- Theme
  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   priority = 1000,
  --   config = function()
  --     require('catppuccin').setup {
  --       -- no_italic = true,
  --       -- term_colors = true,
  --       -- transparent_background = false,
  --       styles = {
  --         comments = {},
  --         conditionals = {},
  --         loops = {},
  --         functions = {},
  --         keywords = {},
  --         strings = {},
  --         variables = {},
  --         numbers = {},
  --         booleans = {},
  --         properties = {},
  --         types = {},
  --       },
  --       color_overrides = {
  --         mocha = {
  --           base = '#000000',
  --           mantle = '#000000',
  --           crust = '#000000',
  --         },
  --       },
  --       integrations = {
  --         telescope = {
  --           enabled = true,
  --           -- style = 'nvchad',
  --         },
  --         dropbar = {
  --           enabled = true,
  --           color_mode = true,
  --         },
  --       },
  --     }
  --     -- vim.cmd 'colorscheme catppuccin'
  --     -- vim.cmd 'colorscheme lunaperche'
  --   end,
  -- },
  -- {
  --   'jesseleite/nvim-noirbuddy',
  --   dependencies = {
  --     { 'tjdevries/colorbuddy.nvim' },
  --   },
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     preset = 'miami-nights',
  --     -- All of your `setup(opts)` will go here
  --   },
  -- },
  -- Alternative theme (currently disabled)
  -- { -- You can easily change to a different colorscheme.
  --   -- Change the name of the colorscheme plugin below, and then
  --   -- change the command in the config to whatever the name of that colorscheme is.
  --   --
  --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   init = function()
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     vim.cmd.colorscheme 'tokyonight-night'
  --
  --     -- You can configure highlights by doing something like:
  --     vim.cmd.hi 'Comment gui=none'
  --   end,
  -- },

  -- Aura theme (currently disabled)
  -- {
  --   'baliestri/aura-theme',
  --   lazy = false,
  --   priority = 1000,
  --   config = function(plugin)
  --     vim.opt.rtp:append(plugin.dir .. '/packages/neovim')
  --     vim.cmd [[colorscheme aura-dark]]
  --   end,
  -- },
  {
    'vague-theme/vague.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other plugins
    config = function()
      vim.cmd 'colorscheme vague'
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function()
      local function getWords()
        if vim.bo.filetype == 'md' or vim.bo.filetype == 'txt' or vim.bo.filetype == 'markdown' then
          if vim.fn.wordcount().visual_words == 1 then
            return tostring(vim.fn.wordcount().visual_words) .. ' word'
          elseif not (vim.fn.wordcount().visual_words == nil) then
            return tostring(vim.fn.wordcount().visual_words) .. ' words'
          else
            return tostring(vim.fn.wordcount().words) .. ' words'
          end
        else
          return ''
        end
      end

      -- local noirbuddy_lualine = require 'noirbuddy.plugins.lualine'
      -- require('lualine').setup {
      --   options = {
      --     theme = noirbuddy_lualine.theme,
      --   },
      --   sections = noirbuddy_lualine.sections,
      --   inactive_sections = noirbuddy_lualine.inactive_sections,
      -- }
    end,
  },

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' }, -- optional, for better icons
    config = function()
      require('bufferline').setup {}
      -- Map keys to cycle through buffers with Bufferline
      vim.api.nvim_set_keymap('n', '<C-Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>x', ':bdelete<CR>', { noremap = true, silent = true })
    end,
  },

  -- Zen mode
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode', -- load when the ZenMode command is used
    keys = {
      {
        '<leader>tz',
        '<cmd>ZenMode<CR>',
        desc = 'Toggle Zen Mode',
      },
    },
    config = function()
      require('zen-mode').setup {
        -- You can add your zen mode configuration options here
        -- For example:
        -- window = {
        --   backdrop = 1,
        --   width = 0.85,
        --   height = 1,
        --   options = {
        --     signcolumn = "no",
        --     number = false,
        --     cursorline = false,
        --     cursorcolumn = false,
        --   },
        -- },
      }
    end,
  },

  -- Which key
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          -- BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>q', group = '[Q]uit' },
        { '<leader>b', group = '[B]uffer' },
        { '<leader>y', group = '[Y]ank' },
        { '<leader>h', group = '[H]op', mode = 'n' },
      },
    },
  },
}
