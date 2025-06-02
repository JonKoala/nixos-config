require("gruvbox").setup({
  contrast = "hard"
})

vim.cmd([[
  colorscheme gruvbox
]])

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5

vim.opt.clipboard:append({"unnamedplus"})

vim.g.mapleader = ","

local snacks = require("snacks")
local snacks_picker_config = { focus = "list" }
vim.keymap.set("n", "<Leader>e", function() snacks.picker.explorer(vim.tbl_deep_extend("force", snacks_picker_config, { hidden = true })) end, {})
vim.keymap.set("n", "<Leader>ff", function() snacks.picker.smart(vim.tbl_deep_extend("force", snacks_picker_config, { filter = { cwd = true } })) end, {})
vim.keymap.set("n", "<Leader>fb", function() snacks.picker.buffers(snacks_picker_config) end, {})

vim.api.nvim_create_user_command("Yazi", function() require("yazi").yazi() end, { desc = "Open yazi at the current file" })

vim.lsp.enable("lua_ls")
require("lazydev").setup({
  ft = "lua"
})

