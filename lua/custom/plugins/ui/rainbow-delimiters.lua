return {
  {
    url = 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
    config = function()
      local rainbow_delimiters = require 'rainbow-delimiters'

      ---@type rainbow_delimiters.config
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
        -- Guard against "attempt to index local 'parser' (a nil value)" in
        -- rainbow-delimiters/lib.lua when entering buffers without a
        -- treesitter parser (e.g. NvimTree, help, dashboard).
        condition = function(bufnr)
          local ft_skip = {
            NvimTree = true,
            ['neo-tree'] = true,
            help = true,
            dashboard = true,
            alpha = true,
            lazy = true,
            mason = true,
            TelescopePrompt = true,
          }
          if ft_skip[vim.bo[bufnr].filetype] then return false end
          local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
          return ok and parser ~= nil
        end,
      }

      -- Wrap lib.attach so a nil treesitter parser cannot crash the autocmd.
      -- Upstream's FileType (pattern '*') autocmd calls attach unconditionally
      -- after its own enabled_for/enabled_when checks — but get_parser can
      -- still return (true, nil) on filetree/ui buffers, which then crashes
      -- at lib.lua:200 (`parser:register_cbs{...}`).
      local lib = require 'rainbow-delimiters.lib'
      local original_attach = lib.attach
      lib.attach = function(bufnr)
        local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
        if not ok or parser == nil then return end
        return original_attach(bufnr)
      end
    end,
  },
}
