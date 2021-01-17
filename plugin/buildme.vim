" nvim-buildme
" By Olivier Roques
" github.com/ojroques

if exists('g:loaded_buildme')
  finish
endif

command! BuildMe lua require('buildme').build()
command! StopMe lua require('buildme').stop()

let g:loaded_lspfuzzy = 1
