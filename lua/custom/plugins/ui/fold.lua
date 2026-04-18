return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

    vim.o.foldcolumn = '1' -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    vim.keymap.set('n', 'zK', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        -- choose one of coc.nvim and nvim lsp
        vim.lsp.buf.hover()
      end
    end)

    -- Folding capability for LSP servers is now injected via vim.lsp.config('*')
    -- in lua/custom/plugins/lsp/init.lua — no per-server setup() needed here.

    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' 󰁂 %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end

    -- global handler
    -- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
    -- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.
    require('ufo').setup {
      fold_virt_text_handler = handler,
    }

    -- See more options at https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#minimal-configuration

    -- tracking max foldlevel on open buffer
    local augroup = vim.api.nvim_create_augroup('Ufo', { clear = false })
    vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
      desc = 'Finds the highest foldlevel in the current file',
      group = augroup,
      callback = function()
        -- vim.cmd [[let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))]] -- FIX: it always go zero
      end,
    })
  end,
}
