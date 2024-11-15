local telescope = require('telescope')
local actions = require('telescope.actions')

require('telescope.pickers.layout_strategies').horizontal_merged = function(picker, max_columns, max_lines, layout_config)
  local layout = require('telescope.pickers.layout_strategies').horizontal(picker, max_columns, max_lines, layout_config)

  layout.results.line = layout.results.line - 1
  layout.results.height = layout.results.height + 1

  return layout
end

-- vim.cmd([[
--   highlight link TelescopePromptTitle PMenuSel
--   highlight link TelescopePreviewTitle PMenuSel
--   highlight link TelescopePromptNormal NormalFloat
--   highlight link TelescopePromptBorder FloatBorder
--   highlight link TelescopeNormal CursorLine
--   highlight link TelescopeBorder CursorLineBg
-- ]])

local project_actions = require("telescope._extensions.project.actions")

telescope.setup({
  defaults = {
  --   path_display = { truncate = 1 },
    border = false,
    prompt_prefix = ' ',
    selection_caret = '  ',
    layout_config = {
      prompt_position = 'top',
      height = 10,
      width = 80,
    },
    layout_strategy = 'horizontal_merged',
    sorting_strategy = 'ascending',
    mappings = {
      i = {
        ['<esc>'] = actions.close,
      },
    },
    file_ignore_patterns = { '.git/' },
    preview = {
      hide_on_startup = true,
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      prompt_title = false,
      results_title = false,
    },
    commands = {
      prompt_title = false,
      results_title = false,
    },
  --   buffers = {
  --     previewer = false,
  --     layout_config = {
  --       width = 80,
  --     },
  --   },
  --   oldfiles = {
  --     prompt_title = 'History',
  --   },
  --   lsp_references = {
  --     previewer = false,
  --   },
  },
  extensions = {
    project = {
      base_dirs = {
        {path = '~/Code', max_depth = 4},
      },
      on_project_selected = function(prompt_bufnr)
        project_actions.change_working_directory(prompt_bufnr, false)
      end
    },
  },
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('project')
-- require('telescope').load_extension('live_grep_args')

vim.keymap.set('n', '<leader>c', [[<cmd>lua require('telescope.builtin').commands()<CR>]])
vim.keymap.set('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
vim.keymap.set('n', '<leader>F', [[<cmd>lua require('telescope.builtin').find_files({
  no_ignore = true, prompt_title = 'All Files'
})<CR>]]) -- luacheck: no max line length
vim.keymap.set('n', '<leader>b', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
vim.keymap.set('n', '<leader>g', [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]])
vim.keymap.set('n', '<leader>h', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])
vim.keymap.set('n', '<leader>s', [[<cmd>lua require('telescope.builtin').lsp_document_symbols({symbol_width = 70, symbols = 'method'})<CR>]])

vim.api.nvim_set_keymap(
        'n',
        '<leader>r',
        ":lua require'telescope'.extensions.project.project{}<CR>",
        {noremap = true, silent = true}
)
