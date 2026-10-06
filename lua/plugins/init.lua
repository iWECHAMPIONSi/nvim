return {
	{
		"vhyrro/luarocks.nvim",
		priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
		config = true,
	},
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- optional but recommended
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
	},
	{ "ellisonleao/gruvbox.nvim", priority = 999, config = true, opts = ... },
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "mbbill/undotree" },
	{ "tpope/vim-fugitive" },
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true, -- Mandatory mapping to LSP server
			handler_opts = {
				border = "rounded", -- Choose "single", "double", or "rounded"
			},
			hint_enable = true, -- Show virtual hint next to cursor
			hint_prefix = "💡 ",
		},
	},
	{
		"lopi-py/luau-lsp.nvim",
		opts = {},
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"ShouxTech/rojo.nvim",
		opts = {},
	},
	{
		"nvim-treesitter/playground",
		cmd = "TSHighlightCapturesUnderCursor",
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source with:
		-- build = 'nix run .#build-plugin',

		opts_extend = { "sources.default" },
	},
	{
		"stevearc/conform.nvim",
		opts = {},
	},
	{
		"vyfor/cord.nvim",
	},
	{
		{ "CRAG666/code_runner.nvim", config = true },
	},
	{ "renerocksai/jar-sdk-browser.nvim" },
	{
		"alienman5k/jdecomp.nvim",
		opts = {
			decompiler = "fernflower", -- cfr, procyon, fernflower
			provider = {
				fernflower = {
					jar = os.getenv("HOME") .. ".local/bin/fernflower/build/install/fernflower/lib/fernflower.jar",
				},
			},
		},
	},
	{
		"nvim-java/nvim-java",
		config = function()
			require("java").setup()
			vim.lsp.enable("jdtls")
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-mini/mini.nvim",
			"nvim-mini/mini.icons",
		}, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}
