vim.opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" }
vim.opt.complete = {
    ".,w,b,u,t,kspell",
}
vim.opt.complete:append('k')
vim.lsp.completion.enable()
vim.lsp.config("luau-lsp", {
    on_attach = function(client, bufnr)
        vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
        })
    end,
})
vim.api.nvim_create_autocmd("TextChangedI", {
    callback = function()
        if vim.fn.pumvisible() ~= 0 then
            return
        end
		 if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then
			return
        end
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]

        -- Text before cursor
        local before_cursor = line:sub(1, col)

        -- Only trigger if currently typing an identifier
        if before_cursor:match("[%w_]+$") then
            vim.lsp.completion.get()
        end
    end,
})
