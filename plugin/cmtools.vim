" ============ CMakeTools for vim ============
" (c) Matthew Mirvish 2018
"

" Public interface

command! -nargs=* CMGen call cmtools#CMToolsGenerate(<f-args>) 
command! -nargs=* CMBuild call cmtools#CMToolsBuild(<f-args>)

