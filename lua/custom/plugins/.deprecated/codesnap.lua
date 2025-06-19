local function auto_generate_snap_filename()
  return os.date 'CodeSnap_%Y-%m-%d_at_%H-%M-%S.png'
end

local function rename_code_snap_file()
  -- Use a timer to delay the renaming operation
  vim.defer_fn(function()
    local old_path = vim.fn.expand '~/Pictures/tmp.png'
    local new_name = auto_generate_snap_filename()
    local new_path = vim.fn.expand('~/Pictures/' .. new_name)

    -- Check if the file exists
    if vim.loop.fs_stat(old_path) then
      local success, err = vim.loop.fs_rename(old_path, new_path)
      if success then
        vim.notify('Saved screenshot as ' .. new_name)
      else
        vim.notify('Error renaming file: ' .. err, vim.log.levels.ERROR)
      end
    else
      vim.notify('Error: tmp.png does not exist. Screenshot might have failed.', vim.log.levels.ERROR)
    end
  end, 100) -- delay for 100 milliseconds
end

return {
  {
    'mistricky/codesnap.nvim',
    build = 'make build_generator',
    keys = {
      { '<leader>cc', '<cmd>CodeSnap<cr>', mode = 'x', desc = 'Save selected code snapshot into clipboard' },
      {
        '<leader>cs',
        function()
          vim.cmd 'CodeSnapSave'
          rename_code_snap_file()
        end,
        mode = 'x',
        desc = 'Save selected code snapshot in ~/Pictures',
      },
    },
    config = function()
      require('codesnap').setup {
        save_path = '~/Pictures/tmp.png',

        has_breadcrumbs = true,
        has_line_number = true,
        mac_window_bar = true,

        breadcrumbs_separator = '/',
        title = 'CodeSnap.nvim',
        code_font_family = 'CaskaydiaCove Nerd Font',
        watermark = '',
        watermark_font_family = 'Pacifico',
        -- bg_color = '#535c68',
        bg_padding = 0,

        min_width = 0,
      }
    end,
  },
}
