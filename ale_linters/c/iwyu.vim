" Author: Alexander Fedorov <fedorov7@gmail.com>,
" Description: iwyu linter for c include headers

call ale#Set('c_iwyu_executable', 'iwyu_tool.py')
" Set this option to check the checks iwyu_tool.py will apply.
" Set this option to manually set some options for iwyu_tool.py.
" This will disable compile_commands.json detection.
call ale#Set('c_iwyu_options', ' -o clang ')

function! ale_linters#c#iwyu#GetCommand(buffer) abort
    let l:build_dir = ale#c#GetBuildDirectory(a:buffer)

    return '%e'
    \   . (!empty(l:build_dir) ? ' -p ' . ale#Escape(l:build_dir) : ' -p . ')
    \   . ale#Var(a:buffer, 'c_iwyu_options')
    \   . ' %s'

endfunction

call ale#linter#Define('c', {
\   'name': 'iwyu',
\   'output_stream': 'both',
\   'executable': {b ->ale#Var(b, 'c_iwyu_executable')},
\   'command': function('ale_linters#c#iwyu#GetCommand'),
\   'callback': 'ale#handlers#iwyu#HandleIwyuFormat',
\})
