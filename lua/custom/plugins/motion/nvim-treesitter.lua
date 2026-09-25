return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- master branch is archived; main supports Neovim 0.11+
    lazy = false, -- does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'
      ts.setup {}

      -- Parsers kept installed at all times (replaces `ensure_installed` from master)
      local ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      }

      local installed = {} ---@type table<string, true>
      for _, lang in ipairs(ts.get_installed 'parsers') do
        installed[lang] = true
      end

      local missing = vim.tbl_filter(function(lang)
        return not installed[lang]
      end, ensure_installed)
      if #missing > 0 then
        ts.install(missing)
      end

      -- Languages already queued for install, so a missing parser is not
      -- re-requested on every buffer of that filetype.
      local requested = {} ---@type table<string, true>

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
        callback = function(ev)
          local ft = ev.match
          local buf = ev.buf
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then
            return
          end

          -- `language.add` returns nil plus an error message rather than raising
          -- when the parser is missing, so test the value, not the pcall status.
          local ok, added = pcall(vim.treesitter.language.add, lang)
          if not (ok and added) then
            if not requested[lang] then
              requested[lang] = true
              if vim.list_contains(ts.get_available(), lang) then
                -- async; features activate the next time this filetype is opened
                ts.install { lang }
              end
            end
            return
          end

          -- Ruby depends on vim's regex highlighting and its own indent rules.
          if ft == 'ruby' then
            return
          end

          -- Only take over indenting when highlighting actually started, otherwise
          -- indentexpr points at a parser that cannot load and indenting breaks.
          if pcall(vim.treesitter.start, buf, lang) then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
