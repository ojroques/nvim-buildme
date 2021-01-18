" nvim-buildme
" By Olivier Roques
" github.com/ojroques

if exists('g:loaded_buildme')
  finish
endif

command! BuildMeEdit lua require('buildme').edit()
command! BuildMe lua require('buildme').build()
command! BuildMeStop lua require('buildme').stop()

let g:loaded_buildme = 1
