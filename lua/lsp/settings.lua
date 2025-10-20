-- LSP settings and capabilities

local M = {}

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = vim.tbl_deep_extend('force', M.capabilities, require('cmp_nvim_lsp').default_capabilities())

-- Change diagnostic symbols in the sign column (gutter)
-- if vim.g.have_nerd_font then
--   local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
--   local diagnostic_signs = {}
--   for type, icon in pairs(signs) do
--     diagnostic_signs[vim.diagnostic.severity[type]] = icon
--   end
--   vim.diagnostic.config { signs = { text = diagnostic_signs } }
-- end

return M