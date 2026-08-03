vim.opt.number = true
vim.opt.relativenumber = true

vim.diagnostic.config({
	virtual_text = {
		severity_sort = true,
		prefix = '',
		spacing = 4
	},
	signs = false,
	update_in_insert = true,
	severity_sort = true
})

vim.opt.autocomplete = true
vim.opt.autocompletedelay = 0

vim.lsp.completion.enable()

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

