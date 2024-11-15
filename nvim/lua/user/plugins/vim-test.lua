vim.keymap.set('n', '<Leader>tn', ':TestNearest<CR>')
vim.keymap.set('n', '<Leader>tf', ':TestFile<CR>')
vim.keymap.set('n', '<Leader>ts', ':TestSuite<CR>')
vim.keymap.set('n', '<Leader>tl', ':TestLast<CR>')
vim.keymap.set('n', '<Leader>tv', ':TestVisit<CR>')


vim.cmd([[
  let test#php#phpunit#executable = './vendor/bin/phpunit'
  let test#php#phpunit#options = '--colors=always --no-coverage'

  function! ToggleTermStrategy(cmd) abort
    call luaeval("require('toggleterm').exec(_A[1], 1, 10, 'git_dir', 'horizontal', 'PHPUnit', false, true)", [a:cmd])
  endfunction

  function! DispatchStrategy(cmd) abort
    call execute('Dispatch '.a:cmd)
  endfunction

  let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy'), 'dispatch': function('DispatchStrategy')}
  let g:test#strategy = 'dispatch'
]])

    -- call timer_start(200, { tid -> execute('AnsiEsc')})
