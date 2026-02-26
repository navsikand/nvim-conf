-- LSP server configurations

local M = {}

local function resolve_python_path(root_dir)
  local candidates = {
    root_dir .. '/.venv/bin/python',
    root_dir .. '/venv/bin/python',
  }

  if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= '' then
    table.insert(candidates, 1, vim.env.VIRTUAL_ENV .. '/bin/python')
  end

  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  return vim.fn.exepath('python3')
end

local function python_site_packages(python_path)
  if not python_path or python_path == '' then
    return {}
  end

  local script = [[import site
paths = []
try:
    paths.extend(site.getsitepackages())
except Exception:
    pass
try:
    p = site.getusersitepackages()
    if isinstance(p, str):
        paths.append(p)
except Exception:
    pass
for p in dict.fromkeys(paths):
    print(p)
]]

  local cmd = string.format("%s -c %s", vim.fn.shellescape(python_path), vim.fn.shellescape(script))
  local out = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then
    return {}
  end

  local paths = {}
  for _, p in ipairs(out) do
    if p ~= '' and vim.fn.isdirectory(p) == 1 then
      table.insert(paths, p)
    end
  end

  return paths
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
M.servers = {
  clangd = {},
  -- gopls = {},
  -- basedpyright = {},
  -- rust_analyzer = {},
  -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs

  prismals = {},
  svelte = {},

  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  ts_ls = {},
  pyright = {
    autostart = false,
  },
  basedpyright = {
    before_init = function(_, config)
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      local python_path = resolve_python_path(config.root_dir)
      config.settings.python.pythonPath = python_path
      config.settings.basedpyright = config.settings.basedpyright or {}
      config.settings.basedpyright.analysis = config.settings.basedpyright.analysis or {}
      config.settings.basedpyright.analysis.extraPaths = python_site_packages(python_path)
    end,
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'workspace',
          useLibraryCodeForTypes = true,
          typeCheckingMode = 'basic',
        },
      },
    },
  },
  tailwindcss = {},
  lua_ls = {
    -- cmd = { ... },
    -- filetypes = { ... },
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        -- Add clippy lints for Rust.
        checkOnSave = {
          allFeatures = true,
          command = 'clippy',
          extraArgs = {
            '--',
            '--no-deps',
            '-Dclippy::correctness',
            '-Dclippy::complexity',
            '-Wclippy::perf',
            '-Wclippy::pedantic',
          },
        },
        procMacro = {
          enable = true,
          ignored = {
            ['async-trait'] = { 'async_trait' },
            ['napi-derive'] = { 'napi' },
            ['async-recursion'] = { 'async_recursion' },
          },
        },
      },
    },
  },
}

return M
