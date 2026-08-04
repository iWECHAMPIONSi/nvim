return {
	cmd = { 'clangd', '--background-index', '--clang-tidy' },
	filetypes = {'c'},
	init_options = {fallbackFlags = {'-std=c23'} },
	root_markers = {'.git'}
}
