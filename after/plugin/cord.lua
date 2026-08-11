require("cord").setup({
	editor = {
		client = "neovim",
	},
	display = {
		theme = "atom",
		flavor = "accent",
		swap_fields = true,
	},
	idle = {
		enabled = false,
	},
	timestamp = {
		enabled = true,
		shared = true,
	},
	text = {
		file_browser = true,
		plugin_manager = true,
	},
})
