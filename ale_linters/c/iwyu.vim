" Author: Alexander Fedorov <fedorov7@gmail.com>,
" Description: iwyu linter for c include headers

call ale#Set('c_iwyu_executable', 'iwyu-tool.py')
" Set this option to check the checks iwyu will apply.
" Set this option to manually set some options for iwyu.
" This will disable compile_commands.json detection.
call ale#Set('c_iwyu_options', '-o clang')

function! ale_linters#c#iwyu#GetCommand(buffer) abort
    let l:build_dir = ale#c#GetBuildDirectory(a:buffer)

    return '%e'
    \   . (!empty(l:build_dir) ? ' -p ' . ale#Escape(l:build_dir) : ' - p build ')
    \   . ale#Var(a:buffer, 'c_iwyu_options')
    \   . ' %s'

endfunction

call ale#linter#Define('c', {
\   'name': 'iwyu',
\   'output_stream': 'both',
\   'executable_callback': ale#VarFunc('c_iwyu_executable'),
\   'command_callback': 'ale_linters#c#iwyu#GetCommand',
\   'callback': 'ale#handlers#iwyu#HandleIwyuFormat',
\   'lint_file': 1,
\})
