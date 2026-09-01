vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "Y", "mzVy`z")
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("v", "<leader>cps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
	return '"+y<C-v>'
end, { expr = true })

vim.keymap.set("i", "<C-CR>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-y>"
	end
	return "<C-CR>"
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

-- vim.keymap.set("n", "<leader>/", function()
-- local lines = {
-- "	/****************************************************",
-- "	*",
-- "	*",
-- "	* @param na : na",
-- "	* @return na : na",
-- "	* @exception na : na",
-- "	* @note : na",
-- "	*****************************************************/",
-- }

-- vim.api.nvim_put(lines, "l", true, true)
-- end, {
-- desc = "Insert documentation comment",
-- })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
vim.keymap.set({ "n", "i" }, "<F1>", "<nop>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

vim.keymap.set("n", "<leader>vwm", function()
	require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
	require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [[mzV"+y`z]])

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
vim.keymap.set("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
