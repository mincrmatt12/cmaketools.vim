" ============ CMakeTools for vim ============
" (c) Matthew Mirvish 2018
"

" Variables

if !exists('g:cmtools_cmake')
	let g:cmtools_cmake = 'cmake'
endif

if !exists('g:cmtools_mkprog')
	let g:cmtools_mkprog = 'make'
endif

if !exists('g:cmtools_default_dir')
	let g:cmtools_default_dir = 'cmake-build-debug'
endif

if !exists('g:cmtools_ycm_gen')
	let g:cmtools_ycm_gen = 0
endif

if !exists('g:cmtools_ycm_autolink')
	let g:cmtools_ycm_autolink = 0
endif

if !exists('g:cmtools_set_makeprg')
	let g:cmtools_set_makeprg = 1
endif
" Helper functions

" CMToolsGetBuildDir(str val): if val == "" return the default else return
" what is passed in

function! s:CMToolsGetBuildDir(val)
	if a:val == ''
		return "/" . g:cmtools_default_dir
	else
		return "/" . a:val
	endif
endfunction

" CMToolsGetMakeDir(str val) gets the make dir using getbuilddir
let s:cmtools_last_makedir = getcwd() . s:CMToolsGetBuildDir(g:cmtools_default_dir)

function! s:CMToolsGetMakeDir(val)
	if a:val == ''
		return s:cmtools_last_makedir
	endif
	let s:cmtools_last_makedir = getcwd() . s:CMToolsGetBuildDir(a:val)
	return s:cmtools_last_makedir
endfunction

" CMToolsMakeDir(str dir) makes a directory if it does not exist
function! s:CMToolsMakeDir(dir)
	if !isdirectory(a:dir)
		call mkdir(a:dir, "p")
	endif
endfunction 

" Public functions
"
" CMGen.impl
function! cmtools#CMToolsGenerate(...)
	let a:build_dir = get(a:, 1, '')
	let l:cmake_args = a:000[1:]
	if g:cmtools_ycm_gen
		call add(l:cmake_args, "-DCMAKE_EXPORT_COMPILE_COMMANDS=1")
	endif

	let l:make_dir = s:CMToolsGetMakeDir(a:build_dir)
	let l:cmake_args = join(l:cmake_args)

	call s:CMToolsMakeDir(l:make_dir)
	" construct the cmake command out of cd makedir; cmake args
	execute "!cd " . l:make_dir . "; " . g:cmtools_cmake . " .. " . l:cmake_args
	if g:cmtools_ycm_autolink
		call cmtools#CMToolsYCM()
	endif
	if g:cmtools_set_makeprg
		let &makeprg="cd " . l:make_dir . ";" . g:cmtools_mkprog
	endif
endfunction
" CMBuild.impl
function! cmtools#CMToolsBuild(...)
	let l:make_args = join(a:000)

	let l:build_dir = s:CMToolsGetMakeDir('')
	if !isdirectory(l:build_dir)
		echom "The build directory " . l:build_dir . "does not exist! Run :CMGen first!"
		return 1
	endif

	execute "!cd " . l:build_dir . "; " . g:cmtools_mkprog . " " . l:make_args
endfunction
" CMYCM.impl
function! cmtools#CMToolsYCM(...)
	let l:build_dir = s:CMToolsGetMakeDir(get(a:, 1, ''))
	let l:source_file = l:build_dir . "/compile_commands.json"
	let l:target_file = getcwd() . "/compile_commands.json" 

	if !filereadable(l:source_file)
		echom "There isn't a compile_commands.json at " . l:source_file . "!"
		return 1
	endif
	if filereadable(l:target_file)
		call delete(l:target_file)
	endif

	execute "!ln -s " . l:source_file . " " . l:target_file
endfunction

