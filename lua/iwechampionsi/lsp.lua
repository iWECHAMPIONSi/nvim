vim.lsp.enable("luals")
-- vim.lsp.enable("jdtls")
vim.lsp.enable("clangd-cpp")
vim.lsp.enable("clangd-c")
-- vim.lsp.enable("basedpyright")
vim.lsp.enable("pyright")
vim.lsp.enable("zls")
vim.lsp.enable("jsonls")
vim.lsp.enable("cssls")
vim.lsp.enable("htmlls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("roslyn_ls")
vim.lsp.enable("markdown_oxide")
vim.lsp.config("luau-lsp", {
	settings = {
		["luau-lsp"] = {
			completion = {
				fillCallArguments = false, -- disable arguments snippets when completing a function call
			},
		},
	},
	capabilities = capabilities,

	on_attach = function(client, bufnr)
		if client.server_capabilities.semanticTokensProvider then
			vim.lsp.semantic_tokens.start(bufnr, client.id)
		end
	end,
})
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf

		if not client then
			return
		end

		if client.name == "roslyn_ls" then
			vim.lsp.semantic_tokens.enable(false, {
				bufnr = args.buf,
				client_id = client.id,
			})
			return
		end

		-- Check the filetype of the current buffer
		if vim.bo[bufnr].filetype == "java" then
			-- Disable diagnostics/error checking for this buffer
			vim.diagnostic.enable(false, { bufnr = bufnr })
		end
	end,
})
