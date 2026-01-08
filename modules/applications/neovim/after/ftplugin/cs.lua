vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "roslyn_ls" then
      return
    end

    client.server_capabilities.semanticTokensProvider = nil
  end,
});

