vim.keymap.set('n', '<Leader>tn', ':TestNearest<CR>')
vim.keymap.set('n', '<Leader>tf', ':TestFile<CR>')
vim.keymap.set('n', '<Leader>ts', ':TestSuite<CR>')
vim.keymap.set('n', '<Leader>tl', ':TestLast<CR>')
vim.keymap.set('n', '<Leader>tv', ':TestVisit<CR>')

vim.cmd([[
  let test#php#phpunit#executable = 'vendor/bin/phpunit'
  let test#php#phpunit#options = '--colors=always'

  function! ToggleTermStrategy(cmd) abort
    call luaeval("require('toggleterm').exec(_A[1], 1, 10, 'git_dir', 'horizontal', false)", [a:cmd])
  endfunction

  let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}
  let g:test#strategy = 'toggleterm'
]])
