local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Initialize packer
require('packer').init({
  compile_path = vim.fn.stdpath('data')..'/site/plugin/packer_compiled.lua',
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'solid' })
    end,
  },
})

local use = require('packer').use

use('wbthomason/packer.nvim')

use('tpope/vim-commentary')
use('tpope/vim-surround')

use({
    'lalitmee/cobalt2.nvim',
    requires = 'tjdevries/colorbuddy.nvim',
    config = function()
      require('colorbuddy').colorscheme('cobalt2')
      local palette = require('cobalt2.palette')
      local colors = require("cobalt2.utils").colors
      local Color = require("cobalt2.utils").Color
      local Group = require("cobalt2.utils").Group
      local styles = require("cobalt2.utils").styles

      Color.new("dark", "#1B2C3F")
      Color.new("selected", "#1F4661")

      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1B2C3F' })
      vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1B2C3F" })

      -- @todo get red undercurl working
      Group.new('SpellBad', nil, nil, styles.undercurl)

      Group.new('TelescopePromptNormal', colors.white, colors.dark, nil)
      Group.new('TelescopePromptBorder', colors.dark, colors.selected, nil)
      Group.new('TelescopeResultsBorder', colors.dark, colors.dark, nil)
      Group.new('TelescopeResultsNormal', colors.white, colors.dark, nil)
      Group.new("TelescopeSelection", colors.white, colors.selected, nil)

      Group.new("CmpItemAbbrMatch", colors.selected, nil, styles.bold)

      -- Lualine
      Group.new("StatusLineNonText", colors.dark, colors.cursor_line)
    end,
})

use({
  'kyazdani42/nvim-tree.lua',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('user.plugins.nvim-tree')
  end,
})

use({
  'nvim-lualine/lualine.nvim',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('user/plugins/lualine')
  end,
})

-- use({
--   'akinsho/bufferline.nvim',
--   requires = 'kyazdani42/nvim-web-devicons',
--   after = 'cobalt2.nvim',
--   config = function()
--     require('user/plugins/bufferline')
--   end,
-- })

use({
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('user/plugins/indent-blankline')
  end
})

-- use({
--   'glepnir/dashboard-nvim',
--   config = function()
--     require('user/plugins/dashboard')
--   end
-- })

-- Indent autodetection with editorconfig support
use('tpope/vim-sleuth')

-- Allow plugins to enable repeating commands
use('tpope/vim-repeat')

use('sheerun/vim-polyglot')

-- Jump to the last location when opening a file
use('farmergreg/vim-lastplace')

-- Enable * searching with visually selected text
use('nelstrom/vim-visual-star-search')

-- Automatically create parent dirs when saving
use('jessarcher/vim-heritage')

-- Apply scrolloff to end of file
use({
  'Aasim-A/scrollEOF.nvim',
  config = function()
    require('scrollEOF').setup()
  end
})

-- Text objects for HTML attributes
use({
    'whatyouhide/vim-textobj-xmlattr',
    requires = 'kana/vim-textobj-user',
})

-- Automatically set the working directory to the project root
use({
  'airblade/vim-rooter',
  setup = function()
    vim.g.rooter_manual_only = 1
  end,
  config = function()
    vim.cmd('Rooter')
  end,
})

use({
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup()
  end,
})

use({
  'nvim-telescope/telescope.nvim',
  requires = {
    { 'nvim-lua/plenary.nvim' },
    { 'kyazdani42/nvim-web-devicons' },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    { 'nvim-telescope/telescope-live-grep-args.nvim' },
  },
  config = function()
    require('user/plugins/telescope')
  end,
})

use({
  'lewis6991/gitsigns.nvim',
  requires = 'nvim-lua/plenary.nvim',
  config = function()
    require('gitsigns').setup({
      sign_priority = 20,
      on_attach = function(bufnr)
        vim.keymap.set('n', ']h', ':Gitsigns next_hunk<CR>')
        vim.keymap.set('n', '[h', ':Gitsigns prev_hunk<CR>')
      end,
    })
  end,
})

use({
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  requires = {
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = function()
    require('user.plugins.treesitter')
  end,
})

use({
    'tpope/vim-fugitive',
    requires = 'tpope/vim-rhubarb',
})

use({
  'neovim/nvim-lspconfig',
  requires = {
    {'williamboman/mason.nvim', build = ':MasonUpdate'},
    'williamboman/mason-lspconfig.nvim',
    'b0o/schemastore.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'jayp0521/mason-null-ls.nvim',
  },
  config = function()
    require('user/plugins/lspconfig')
  end,
})

use({
  'hrsh7th/nvim-cmp',
  requires = {
    'L3MON4D3/LuaSnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-nvim-lua',
    'jessarcher/cmp-path',
    'onsails/lspkind-nvim',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    require('user/plugins/cmp')
  end,
})

-- Floating terminal
use({
  'akinsho/toggleterm.nvim',
  config = function()
    local colors = require("cobalt2.utils").colors
    require('toggleterm').setup({
      shade_terminals = false,
      highlights = {
        Normal = {guibg = '#193549'},
        FloatBorder = {
          guifg = '#193549',
          guibg = '#193549',
        },
      },
    })
    vim.keymap.set('t', '<Esc>', '<C-\\><C-n>:ToggleTerm<CR>')
  end
})

-- Testing helper
use({
  'vim-test/vim-test',
  config = function()
    require('user/plugins/vim-test')
  end
})

-- Automatically set up your configuration after cloning packer.nvim
-- Put this at the end after all plugins
if packer_bootstrap then
    require('packer').sync()
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile>
  augroup end
]])
