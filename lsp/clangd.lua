return {
	cmd = { 'clangd', '--background-index', '--clang-tidy' },
	filetypes = {'cpp', 'h'},
	init_options = {fallbackFlags = {'-std=c++26'} },
	root_markers = {'.git'}
}
