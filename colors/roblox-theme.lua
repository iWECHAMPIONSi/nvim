local colors = {
	fg = "#BCBEC8",
	bg = "#202227",

	selection = "#0B5AAF",
	selection_fg = "#FFFFFF",

	operator = "#9772C2",

	number = "#F2BA2A",
	string = "#8EE9B6",
	comment = "#6A6F81",

	keyword = "#EB7973",

	error = "#DF281F",
	warning = "#F57630",
	info = "#494D5A",
	hint = "#335FFF",

	builtin = "#8FB4FF",

	function_name = "#FAE4AA",
	method = "#FAE4AA",
	property = "#70A0FF",

	type = "#528BFF",

	menu_bg = "#191A1F",
	menu_selected = "#0027B8",

	whitespace = "#494D5A",
}

vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "roblox"

vim.o.background = "dark"

local set = vim.api.nvim_set_hl

vim.api.nvim_set_hl(0, "@keyword.type.java", {
	link = "@keyword",
})

set(0, "Normal", {
	bg = "none",
})

set(0, "NormalFloat", {
	bg = "none",
})

set(0, "CursorLine", {
	bg = "none",
})

set(0, "Visual", {
	fg = colors.selection_fg,
	bg = colors.selection,
})

set(0, "Search", {
	bg = "#976C00",
})

set(0, "IncSearch", {
	bg = "#976C00",
})

set(0, "MatchParen", {
	bg = colors.info,
})

set(0, "Whitespace", {
	fg = colors.whitespace,
})

set(0, "NonText", {
	fg = colors.whitespace,
})

set(0, "LineNr", {
	fg = colors.comment,
})

set(0, "CursorLineNr", {
	fg = colors.fg,
})

set(0, "Comment", {
	fg = colors.comment,
})

set(0, "String", {
	fg = colors.string,
})

set(0, "Number", {
	fg = colors.number,
})

set(0, "Boolean", {
	fg = colors.number,
})

set(0, "Constant", {
	fg = colors.number,
})

set(0, "Identifier", {
	fg = colors.fg,
})

set(0, "Function", {
	fg = colors.function_name,
})

set(0, "Statement", {
	fg = colors.keyword,
})

set(0, "Keyword", {
	fg = colors.keyword,
})

set(0, "Operator", {
	fg = colors.operator,
})

set(0, "Type", {
	fg = colors.type,
})

set(0, "Special", {
	fg = colors.builtin,
})

set(0, "Todo", {
	fg = colors.comment,
})

set(0, "DiagnosticError", {
	fg = colors.error,
})

set(0, "DiagnosticWarn", {
	fg = colors.warning,
})

set(0, "DiagnosticInfo", {
	fg = colors.info,
})

set(0, "DiagnosticHint", {
	fg = colors.hint,
})

set(0, "Pmenu", {
	fg = "#FFFFFF",
	bg = colors.menu_bg,
})

set(0, "PmenuSel", {
	fg = "#FFFFFF",
	bg = colors.menu_selected,
})

set(0, "PmenuSbar", {
	bg = colors.menu_bg,
})

set(0, "@punctuation.bracket", {
	fg = colors.fg,
})

set(0, "@punctuation.delimiter", {
	fg = colors.fg,
})

set(0, "@comment", {
	fg = colors.comment,
})

set(0, "@comment.todo", {
	fg = colors.comment,
})

set(0, "@string", {
	fg = colors.string,
})

set(0, "@number", {
	fg = colors.number,
})

set(0, "@boolean", {
	fg = colors.number,
	bold = true,
})

set(0, "@constant.builtin", {
	fg = colors.number,
	bold = true,
})

set(0, "@keyword", {
	fg = colors.keyword,
	bold = true,
})

set(0, "@keyword.function", {
	fg = colors.keyword,
	bold = true,
})

set(0, "@keyword.return", {
	fg = colors.keyword,
	bold = true,
})

set(0, "@operator", {
	fg = colors.operator,
})

set(0, "@function", {
	fg = colors.function_name,
})

set(0, "@function.call", {
	fg = colors.function_name,
})

set(0, "@function.method", {
	fg = colors.method,
})

set(0, "@function.method.call", {
	fg = colors.method,
})

set(0, "@method", {
	fg = colors.method,
})

set(0, "@property", {
	fg = colors.property,
})

set(0, "@field", {
	fg = colors.property,
})

set(0, "@type", {
	fg = colors.type,
})

set(0, "@type.builtin", {
	fg = colors.type,
})

set(0, "@variable.builtin", {
	fg = colors.property,
})

set(0, "@variable.member", {
	fg = colors.variable,
})

set(0, "@lsp.type.type", {
	link = "@type",
})

set(0, "@lsp.type.class", {
	link = "@type",
})

set(0, "@lsp.type.enum", {
	link = "@type",
})

set(0, "@lsp.mod.defaultLibrary", {
	fg = colors.builtin,
})

set(0, "@lsp.typemod.function.defaultLibrary", {
	fg = colors.builtin,
})

set(0, "@lsp.typemod.variable.defaultLibrary", {
	fg = colors.builtin,
})

set(0, "@lsp.type.interface", {
	fg = colors.type,
})

set(0, "@lsp.type.function", {
	fg = colors.function_name,
})

set(0, "@lsp.type.method", {
	fg = colors.method,
})

set(0, "@lsp.type.property", {
	fg = colors.property,
})

set(0, "@lsp.type.parameter", {
	fg = colors.fg,
})

set(0, "@lsp.type.variable", {
	fg = colors.fg,
})
