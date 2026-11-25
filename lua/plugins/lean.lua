-- Lean 4 support
--
-- lean.nvim wires itself into `lean --server` from the elan toolchain that is
-- active for the current project (it reads `lean-toolchain` / lake projects),
-- so there is no server binary to install or pin here.
--
-- Handy commands after opening a `.lean` file:
--   :LeanInfoviewToggle  :LeanGoal  :LeanRestartFile  :LeanDiagnostics  :LeanAxioms
--   :Telescope loogle    (frontend for https://loogle.lean-lang.org)
--
-- NOTE: suggested mappings are buffer-local. Because `maplocalleader` == `leader`
-- (space), `<Leader>p` becomes the infoview pin-pause toggle inside .lean buffers
-- instead of the global clipboard paste binding.
return {
  {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
    },
    init = function()
      -- See https://github.com/Julian/lean.nvim/wiki/The-lean.nvim-Manual
      vim.g.lean_config = {
        -- Install the suggested Lean-specific keymaps in Lean buffers.
        mappings = true,
        infoview = {
          -- Open the infoview when a Lean file gets an LSP client attached.
          autoopen = true,
        },
        -- Render goals/infoview above the file in a split (newer lean.nvim).
        -- Set to 'vertical' for a side-by-side layout instead.
        infoview_position = 'below_right',
      }
    end,
  },
}
