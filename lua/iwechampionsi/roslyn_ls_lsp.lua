local function get_windows_host()
	local result = vim.system({
		"sh",
		"-c",
		"ip route show default | awk '{ print $3; exit }'",
	}, {
		text = true,
	}):wait()

	if result.code ~= 0 then
		error("Failed to determine Windows host address")
	end

	local host = vim.trim(result.stdout or "")

	if host == "" then
		error("Windows host address is empty")
	end

	return host
end

vim.lsp.config("roslyn_ls", {
	cmd = vim.lsp.rpc.connect(get_windows_host(), 56777),
})

vim.lsp.enable("roslyn_ls")
