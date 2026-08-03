require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}

require('nvim-treesitter').install {'lua', 'c', 'cpp', 'zig'}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c' },
  callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'cpp' },
  callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua' },
  callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'zig' },
  callback = function() vim.treesitter.start() end,
})
