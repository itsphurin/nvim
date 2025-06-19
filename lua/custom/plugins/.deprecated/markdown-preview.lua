return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
}

-- To use with mermaid(https://github.com/mermaid-js/mermaid)
-- use code blocks with tag mermaid, e.g.
--
-- ``` mermaid
-- ...your code here...
--
-- ```
--
-- See more: https://github.com/iamcco/markdown-preview.nvim?tab=readme-ov-file#custom-examples
