vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set('n', 'Y', 'mzVy`z')

vim.keymap.set('i', '<C-CR>', function()
	if vim.fn.pumvisible() == 1 then
		return '<C-y>'
	end
	return '<C-CR>'
end, { expr = true })

vim.keymap.set("i", "<C-j>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    end
    return "<C-j>"
end, { expr = true })

vim.keymap.set("i", "<C-k>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-p>"
    end
    return "<C-k>"
end, { expr = true })

vim.keymap.set("n", "<leader>/", function()
    local lines = {
        "	/****************************************************",
        "	*",
        "	*",
        "	* @param na : na",
        "	* @return na : na",
        "	* @exception na : na",
        "	* @note : na",
        "	*****************************************************/",
    }

    vim.api.nvim_put(lines, "l", true, true)
end, {
    desc = "Insert documentation comment",
})

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
