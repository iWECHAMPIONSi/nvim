local function toggle_line(lnum, comment)
    local line = vim.fn.getline(lnum)

    -- Split the line into indentation and the remaining text.
    local indent, rest = line:match("^(%s*)(.*)$")

    -- Ignore blank or whitespace-only lines.
    if rest:match("^%s*$") then
        return
    end

    local escaped = vim.pesc(comment)

    -- Uncomment if the first non-whitespace characters are already the
    -- comment marker.
    if rest:match("^" .. escaped .. "%s?") then
        rest = rest:gsub("^" .. escaped .. "%s?", "", 1)
    else
        rest = comment .. " " .. rest
    end

    vim.fn.setline(lnum, indent .. rest)
end

local function get_comment_prefix()
    local commentstring = vim.bo.commentstring

    if commentstring == "" or not commentstring:find("%%s") then
        return nil
    end

    return vim.trim(commentstring:match("^(.*)%%s"))
end

-- Toggle current line.
vim.keymap.set("n", "<C-_>", function()
    local comment = get_comment_prefix()

    if not comment then
        vim.notify("No valid commentstring for this filetype.", vim.log.levels.WARN)
        return
    end

    toggle_line(vim.fn.line("."), comment)
end, {
    desc = "Toggle Comment",
    silent = true,
})

-- Toggle every selected line.
vim.keymap.set("x", "<C-_>", function()
    local comment = get_comment_prefix()

    if not comment then
        vim.notify("No valid commentstring for this filetype.", vim.log.levels.WARN)
        return
    end

    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")

    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end

    for lnum = start_line, end_line do
        toggle_line(lnum, comment)
    end

    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
        "n",
        false
    )
end, {
    desc = "Toggle Comment",
    silent = true,
})
