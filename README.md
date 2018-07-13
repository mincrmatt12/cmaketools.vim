# CMakeTools

Vim plugin that helps with cmake project management.


## Install

Use any sane modern plugin installer like vundle, vim-plug or pathogen.

## Use

CMakeTools provides a few helpful commands:

### `:CMGen`

Generates the cmake project in the root directory. Parameters are optional, first one is the dir to build to. Additional arguments are passed to `cmake`

### `:CMBuild`

Builds a cmake project. The build dir is the last one used with CMGen. Additional parameters are passed to the `cmtools_mkprog`.

## Params

| name | desc|
| --- | --- |
| `g:cmtools_default_dir` | default build directory |
| `g:cmtools_mkprog` | build tool (default is just make, although some may want it to be cmake --build)
| `g:cmtools_cmake` | path to cmake (default cmake) |
