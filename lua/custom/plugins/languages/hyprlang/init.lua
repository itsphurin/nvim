vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.hl', 'hypr*.conf' },
  callback = function()
    vim.opt.filetype = 'hyprlang'
  end,
})

return {}
