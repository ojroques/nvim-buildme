" nvim-buildme
" By Olivier Roques
" github.com/ojroques

if exists('g:loaded_buildme')
  finish
endif

command! BuildMe lua require('buildme').build()
command! BuildMeEdit lua require('buildme').edit()
command! BuildMeJump lua require('buildme').jump()
command! BuildMeStop lua require('buildme').stop()

let g:loaded_buildme = 1
