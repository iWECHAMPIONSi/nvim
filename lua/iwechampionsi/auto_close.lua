local M = {}

---@type table<string, table<string, string>>
local language_pairs = {
	c = {
		["{"] = "}",
	},

	cpp = {
		["{"] = "}",
	},

	cs = {
		["{"] = "}",
	},

	java = {
		["{"] = "}",
	},

	zig = {
		["{"] = "}",
	},

	go = {
		["{"] = "}",
	},

	rust = {
		["{"] = "}",
		["["] = "]",
	},

	python = {
		["["] = "]",
		["{"] = "}",
	},

	javascript = {
		["["] = "]",
		["{"] = "}",
	},

	javascriptreact = {
		["["] = "]",
		["{"] = "}",
	},

	typescript = {
		["["] = "]",
		["{"] = "}",
	},

	typescriptreact = {
		["["] = "]",
		["{"] = "}",
	},
}

local function get_pair(bufnr, row, col)
	local filetype = vim.bo[bufnr].filetype
	local pairs = language_pairs[filetype]

	if not pairs then
		return nil
	end

	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]

	if not line then
		return nil
	end

	-- The cursor column is a zero-based byte offset.
	--
	-- Only operate at the actual end of the line. This makes the rule
	-- deliberately conservative when refactoring existing code.
	if col ~= #line then
		return nil
	end

	local before_cursor = line:sub(1, col)

	-- Allow:
	--
	--     foo = {
	--     foo = {
	--            ^
	--
	-- including whitespace between the opener and cursor.
	local trimmed = before_cursor:gsub("%s+$", "")

	if trimmed == "" then
		return nil
	end

	local opener = trimmed:sub(-1)
	local closer = pairs[opener]

	if not closer then
		return nil
	end

	local opener_col = #trimmed - 1

	return {
		opener = opener,
		closer = closer,
		col = opener_col,
	}
end

local function get_node(bufnr, row, col)
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)

	if not ok or not parser then
		return nil
	end

	local parse_ok = pcall(parser.parse, parser)

	if not parse_ok then
		return nil
	end

	local node_ok, node = pcall(vim.treesitter.get_node, {
		bufnr = bufnr,
		pos = { row, col },
		include_anonymous = true,
		ignore_injections = true,
	})

	if not node_ok then
		return nil
	end

	return node
end

local function is_ignored_context(node)
	local current = node

	while current do
		local node_type = current:type()

		if
			node_type:find("comment", 1, true)
			or node_type:find("string", 1, true)
			or node_type:find("character", 1, true)
			or node_type:find("char_literal", 1, true)
		then
			return true
		end

		current = current:parent()
	end

	return false
end

local function has_existing_closer(open_node, closer)
	local sibling = open_node:next_sibling()

	while sibling do
		if sibling:type() == closer then
			return not sibling:missing()
		end

		sibling = sibling:next_sibling()
	end

	return false
end

local function should_close(bufnr, row, pair)
	local node = get_node(bufnr, row, pair.col)

	if not node then
		return false
	end

	-- We specifically asked Tree-sitter for anonymous nodes.
	--
	-- If the character is actually structural syntax, this should be the
	-- delimiter token itself.
	--
	-- A "{" inside an ordinary string, for example, generally will not
	-- appear as the language's anonymous "{" token.
	if node:type() ~= pair.opener then
		return false
	end

	if is_ignored_context(node) then
		return false
	end

	if has_existing_closer(node, pair.closer) then
		return false
	end

	return true
end

function M.enter()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)

	local row = cursor[1] - 1
	local col = cursor[2]

	local pair = get_pair(bufnr, row, col)

	if not pair then
		return "<CR>"
	end

	if not should_close(bufnr, row, pair) then
		return "<CR>"
	end

	return "<CR>" .. pair.closer .. "<Esc>O"
end

return M
