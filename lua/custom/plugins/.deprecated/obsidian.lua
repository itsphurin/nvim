-- For more configurations
-- See also: https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#configuration-options

return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    { '<leader>orn', [[:ObsidianRename<CR><C-R>+]], desc = '[O]bsidian [R]e[n]ame from clipboard' },
    { '<leader>orN', [[:ObsidianRename<CR>]], desc = '[O]bsidian hard [R]e[n]ame' },
  },
  opts = {
    workspaces = {
      { name = 'second-brain', path = '~/vaults/second-brain' },
    },
    notes_subdir = 'Inbox',
    new_notes_location = 'notes_subdir',
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = 'Journal',
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = '%Y-%m-%d',
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = '%B %-d, %Y',
      -- Optional, default tags to add to each new daily note created.
      default_tags = { 'daily-notes' },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil,
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ['<cr>'] = {
        action = function()
          return require('obsidian').util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },

    templates = {
      folder = 'Templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
    },

    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ''
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,

    -- Optional, customize how wiki links are formatted. You can set this to one of:
    --  * "use_alias_only", e.g. '[[Foo Bar]]'
    --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
    --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
    --  * "use_path_only", e.g. '[[foo-bar.md]]'
    -- Or you can set it to a function that takes a table of options and returns a string, like this:
    wiki_link_func = 'use_alias_only',

    -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
    ---@return string
    image_name_func = function()
      -- Prefix image names with timestamp.
      return string.format('%s-', os.time())
    end,
  },
}
