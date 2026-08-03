require("luau-lsp").setup {
    platform = {
        type = "roblox", -- Tells the LSP to pull Roblox-specific types
    },
    types = {
        roblox_security_level = "PluginSecurity", -- Allows autocomplete for plugin-level APIs
    },
    plugin = {
        enabled = true,
        port = 55843, -- The default port the Roblox Studio luau-lsp plugin listens on
    },
    server = {
        -- Pass your standard on_attach and capabilities here
        on_attach = function(client, bufnr)
            -- Your custom LSP keymaps go here (e.g., gd for definition)
		end
    },
	sourcemap = {
		enabled = true,
		autogenerate = true, -- automatic generation when the server is initialized
		rojo_project_file = "default.project.json",
		sourcemap_file = "sourcemap.json",
	},
	fflags = {
		enable_new_solver = true, -- enables the fflags required for luau's new type solver
		sync = true, -- sync currently enabled fflags with roblox's published fflags
		override = { -- override fflags passed to luau 
			LuauTableTypeMaximumStringifierLength = "100",
		},
	}
}
