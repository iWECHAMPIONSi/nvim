require("blink.cmp").setup({
    keymap = {
        preset = "enter",

        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },

        ["<C-CR>"] = { "accept", "fallback" },
		appearance = {
		  -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		  -- Adjusts spacing to ensure icons are aligned
		  nerd_font_variant = 'mono'
		},
    },

		completion = {
			list = {
				selection = {
					preselect = false,
					auto_insert = false,
				},
			},
			accept = {
				auto_brackets = {
					enabled = false,
				},
			},

			trigger = {
				show_on_keyword = true,
			},
			documentation = { auto_show = true } },

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
		  default = { 'lsp', 'path', 'snippets', 'buffer' },
		},


})
