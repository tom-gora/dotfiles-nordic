-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Alpha
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- my keymaps stolen from Astro and other

map("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })
map("n", "<F7>", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })
map("n", "<leader>h", "<cmd>Alpha<cr>", { desc = "Home" })
map("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Mason" })
map("n", "<leader>o", "<cmd>ToggleNeotreeFocus<cr>", { desc = "Toggle Neotree Focus" })

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
