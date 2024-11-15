vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Hide mode status since it is already in lualine
vim.opt.showmode = false

vim.opt.cursorline = true
-- vim.opt.cursorlineopt = 'screenline'

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.wildmode = 'longest:full,full' -- complete the longest common match and allow tabbing the results to fully complete them
vim.opt.completeopt = 'menuone,longest,preview'

vim.opt.title = true
vim.opt.mouse = 'a' -- enable mouse for all modes

vim.opt.termguicolors = true

vim.opt.spell = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = '▸ ', trail = '·' }
vim.opt.fillchars:append({ eob = ' ' }) -- remove the ~ from end of buffer

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4

vim.opt.clipboard = 'unnamedplus' -- Use system clipboard

vim.opt.confirm = true -- ask for confirmation instead of erroring

-- Persist gitsigns column width
vim.opt.signcolumn = 'yes:2'

vim.opt.undofile = true -- persistent undo
vim.opt.backup = true -- automatically save a backup file
vim.opt.backupdir:remove('.') -- keep backups out of the current directory

vim.o.guifont = "Inconsolata for Powerline:h20"
-- vim.o.guifont = "JetBrains Mono:h20"

vim.opt.linespace = 36

-- disable animated cursor
vim.g.neovide_cursor_animation_length = 0

