return {
  {
    'kylechui/nvim-surround',
    enabled = true,
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
}

-- NOTE: To adding suround without extra surrounding space
--       e.g. word -> ( word )
--       if you want word -> (word)
--       you have to use ) instead of (
--       also with } ] > instead of { [ <
--
--       See more: https://stackoverflow.com/a/9164449
