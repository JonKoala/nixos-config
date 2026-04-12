vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- disable the lsp semantic tokens
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "roslyn_ls" then
      return
    end

    client.server_capabilities.semanticTokensProvider = nil
  end,
});

-- roslyn wasnt clearing diganostics after undo and redo
-- reset disgnostics after every textChanged event
vim.api.nvim_create_autocmd("TextChanged" , {
  callback = function(ev)
    local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = "roslyn_ls" })
    if not clients or #clients == 0 then
      return
    end

    vim.diagnostic.reset(nil, ev.buf)
  end,
})
