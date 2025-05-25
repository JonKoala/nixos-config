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
vim.api.nvim_create_user_command("Yazi", function() require("yazi").yazi() end, { desc = "Open yazi at the current file" })

vim.keymap.set("n", "<Leader>ff", function() require("snacks").picker.files() end, {})

