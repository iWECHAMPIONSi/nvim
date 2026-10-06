require("nvim-treesitter").setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
	ensure_installed = {
		"lua",
		"luau",
		"python",
		"c",
		"cpp",
		"c_sharp",
		"java",
		"zig",
		"markdown",
		"markdown_inline",
	},
	highlight = {
		enable = true,
	},

	indent = {
		enable = true,
	},
})

require("nvim-treesitter").install({
	"lua",
	"java",
	"luau",
	"python",
	"c",
	"cpp",
	"c_sharp",
	"zig",
	"markdown",
	"markdown_inline",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cs" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "md" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cpp" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "zig" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "luau" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "java" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "py" },
	callback = function()
		vim.treesitter.start()
	end,
})
