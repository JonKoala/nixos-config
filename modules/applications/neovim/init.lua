require("gruvbox").setup({
  contrast = "hard"
})

vim.cmd([[
  colorscheme gruvbox
]])

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.clipboard:append({"unnamedplus"})

vim.g.mapleader = ","

local snacks = require("snacks")
local snacks_picker_config = { win = { input = { keys = { ["<esc>"] = { "close", mode = { "n", "i"} } } } } }
vim.keymap.set("n", "<Leader>e", function() snacks.picker.explorer({ hidden = true }) end, {})
vim.keymap.set("n", "<Leader>ff", function() snacks.picker.smart(vim.tbl_deep_extend("force", snacks_picker_config, { filter = { cwd = true } })) end, {})
vim.keymap.set("n", "<Leader>fb", function() snacks.picker.buffers(snacks_picker_config) end, {})

vim.api.nvim_create_user_command("Yazi", function() require("yazi").yazi() end, { desc = "Open yazi at the current file" })


vim.filetype.add({
  extension = {
    uss = "css",
    uxml = "xml"
  },
})
vim.lsp.enable({ "lua_ls", "nixd", "gdscript", "cssls", "eslint", "html", "jsonls", "roslyn_ls" })
vim.diagnostic.config({ virtual_text = { severity = vim.diagnostic.severity.ERROR } })

-- treesitter highlight
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)

    -- avoids running on buffers that don't correspond to a language (e.g., snacks.picker)
    local language = vim.treesitter.language.get_lang(args.match) or args.match
    if not vim.treesitter.language.add(language) then
        return
    end

    vim.treesitter.start(args.buf)
  end,
})

require('mini.icons').setup()

---@diagnostic disable-next-line: missing-fields
require("lazydev").setup({
  ft = "lua"
})

require("blink.cmp").setup({
  completion = { documentation = { auto_show = true } }
})

