vim.lsp.enable('luals')
vim.lsp.enable('clangd-cpp')
vim.lsp.enable('clangd-c')
vim.lsp.enable('basedpyright')
vim.lsp.enable('zls')
vim.lsp.enable('jsonls')
vim.lsp.enable('cssls')
vim.lsp.enable('htmlls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('markdown_oxide')
vim.lsp.config("luau-lsp", {
	settings = {
		["luau-lsp"] = {
			completion = {
				fillCallArguments = false, -- disable arguments snippets when completing a function call
			}
		}
	},
	capabilities = capabilities,

	on_attach = function(client, bufnr)
		if client.server_capabilities.semanticTokensProvider then
			vim.lsp.semantic_tokens.start(bufnr, client.id)
		end
	end,
})

