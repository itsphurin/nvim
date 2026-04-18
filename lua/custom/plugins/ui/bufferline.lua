return {
  'famiu/bufdelete.nvim',
  'tiagovla/scope.nvim',
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    keys = {
      { '<Tab>', '<Cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
      { '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
      { ']b', '<Cmd>BufferLineMoveNext<CR>', desc = 'Move to next buffer' },
      { '[b', '<Cmd>BufferLineMovePrev<CR>', desc = 'Move to previous buffer' },
      { '<C-w><Tab>', '<Cmd>tabnext<CR>', desc = 'Next tab' },
      { '<C-w><S-Tab>', '<Cmd>tabprevious<CR>', desc = 'Prev tab' },
      { '<C-Tab>', '<Cmd>tabnext<CR>', desc = 'Next tab' },
      { '<C-S-Tab>', '<Cmd>tabprevious<CR>', desc = 'Prev tab' },
    },
    dependencies = {
      -- 'catppuccin',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('scope').setup {}
      require('telescope').load_extension 'scope'
      require('bufferline').setup {
        -- highlights = require('catppuccin.groups.integrations.bufferline').get(),
        options = {
          mode = 'buffers',
          numbers = function(opts)
            return string.format('%s', opts.raise(opts.id))
          end,
          offsets = {
            {
              filetype = 'NvimTree',
              text = 'File Explorer',
              seperator = true,
            },
          },
          close_command = require('bufdelete').bufdelete,
          -- show_buffer_close_icons = false,
          -- show_close_icon = false,
        },
      }
    end,
  },
}
