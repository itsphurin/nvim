return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufWritePost', 'InsertLeave' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        yaml = { 'yamllint' },
        dockerfile = { 'hadolint' },
        make = { 'checkmake' },
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
        zsh = { 'shellcheck' },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
