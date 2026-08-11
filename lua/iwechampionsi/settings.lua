vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 5

vim.diagnostic.config({
	virtual_text = {
		severity_sort = true,
		prefix = "",
		spacing = 4,
	},
	signs = false,
	update_in_insert = true,
	severity_sort = true,
})

vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if not client then
			return
		end

		if client.server_capabilities.semanticTokensProvider then
			vim.lsp.semantic_tokens.enable(true, {
				bufnr = args.buf,
				client_id = client.id,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "roblox",
	callback = function()
		vim.cmd([[
            highlight @lsp.type.property guifg=#70a0ff
            highlight @lsp.type.method guifg=#fae4aa
        ]])
	end,
})
