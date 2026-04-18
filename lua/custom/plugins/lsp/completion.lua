return {
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '^1.0',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '^2',
        event = 'VeryLazy',
        build = (vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1) and 'make install_jsregexp' or nil,
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
    },
    opts = {
      snippets = { preset = 'luasnip' },
      keymap = {
        preset = 'none',
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-y>'] = { 'select_and_accept', 'fallback' },
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<C-k>'] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.hide()
            else
              cmp.show()
            end
          end,
          'fallback',
        },
      },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = { auto_show = true },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      signature = { enabled = true },
    },
    init = function()
      vim.g.NvimCmpEnabled = true
      vim.api.nvim_create_user_command('CmpToggle', function()
        vim.g.NvimCmpEnabled = not vim.g.NvimCmpEnabled
        vim.notify('Completion: ' .. tostring(vim.g.NvimCmpEnabled))
      end, {})
    end,
    keys = {
      { '<C-S-K>', '<cmd>CmpToggle<cr>', mode = { 'n', 'i' }, desc = 'Toggle completion' },
    },
  },
}
