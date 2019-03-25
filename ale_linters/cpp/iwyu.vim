" Author: Alexander Fedorov <fedorov7@gmail.com>,
" Description: iwyu linter for cpp include headers

call ale#Set('cpp_iwyu_executable', 'iwyu_tool.py')
" Set this option to check the checks iwyu_tool.py will apply.
" Set this option to manually set some options for iwyu_tool.py.
" This will disable compile_commands.json detection.
call ale#Set('cpp_iwyu_options', ' -o clang ')

function! ale_linters#cpp#iwyu#GetCommand(buffer) abort
    let l:build_dir = ale#c#GetBuildDirectory(a:buffer)

    return '%e'
    \   . (!empty(l:build_dir) ? ' -p ' . ale#Escape(l:build_dir) : ' -p . ')
    \   . ale#Var(a:buffer, 'cpp_iwyu_options')
    \   . ' %s'

endfunction

call ale#linter#Define('cpp', {
\   'name': 'iwyu',
\   'output_stream': 'both',
\   'executable': {b ->ale#Var(b, 'cpp_iwyu_executable')},
\   'command': function('ale_linters#cpp#iwyu#GetCommand'),
\   'callback': 'ale#handlers#iwyu#HandleIwyuFormat',
\})
