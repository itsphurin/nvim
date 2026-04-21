return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- master branch is archived; main supports Neovim 0.11+
    lazy = false, -- does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
        callback = function(ev)
          local ft = ev.match
          local buf = ev.buf
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then return end

          -- Auto-install parser if missing (async; features activate on next open)
          local has_parser = pcall(vim.treesitter.language.add, lang)
          if not has_parser then
            ts.install { lang }
            return
          end

          -- Enable treesitter highlighting (ruby keeps vim regex via fallback)
          if ft ~= 'ruby' then
            pcall(vim.treesitter.start, buf, lang)
          end

          -- Enable treesitter indentation (ruby uses its own indent rules)
          if ft ~= 'ruby' then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
