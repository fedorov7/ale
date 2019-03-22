scriptencoding utf-8
" Author: Alexander Fedorov <fedorov7@gmail.com>
" Description: Fixing C/C++ includes with iwyu tool.
" iwyu_tool.py -p build file.cpp | fix_includes.py -p build -b --reorder --comments file.cpp -

call ale#Set('iwyu_tool_executable', 'iwyu_tool.py')
call ale#Set('iwyu_tool_use_global', get(g:, 'ale_use_global_executables', 0))
call ale#Set('iwyu_tool_options', ' ')

call ale#Set('fix_includes_executable', 'fix_includes.py')
call ale#Set('fix_includes_use_global', get(g:, 'ale_use_global_executables', 0))
call ale#Set('fix_includes_options', ' -b --reorder --comments ')

function! ale#fixers#iwyu#GetIwyuTool(buffer) abort
    return ale#node#FindExecutable(a:buffer, 'iwyu_tool', [
    \   'iwyu_tool.py',
    \])
endfunction

function! ale#fixers#iwyu#GetFixIncludes(buffer) abort
    return ale#node#FindExecutable(a:buffer, 'fix_includes', [
    \   'fix_includes.py',
    \])
endfunction

function! ale#fixers#iwyu#Fix(buffer) abort
    let l:options = ale#Var(a:buffer, 'iwyu_tool_options')
    let l:executable = ale#fixers#iwyu#GetIwyuTool(a:buffer)
    let l:build_dir = ale#c#GetBuildDirectory(a:buffer)

    let l:command = ale#Escape(l:executable)
    \   . (empty(l:build_dir) ? '' : ' -p ' . ale#Escape(l:build_dir))
    \   . (empty(l:options) ? ' ' : ' ' . l:options)
    \   . '%s'

    return {
    \   'command': l:command,
    \   'chain_with': 'ale#fixers#iwyu#ApplyFix'
    \}
endfunction

function! ale#fixers#iwyu#ApplyFix(buffer, output, input) abort
    let l:options = ale#Var(a:buffer, 'fix_includes_options')
    let l:executable = ale#fixers#iwyu#GetFixIncludes(a:buffer)
    let l:build_dir = ale#c#GetBuildDirectory(a:buffer)

    let l:temp_file = ale#command#CreateFile(a:buffer)
    call ale#util#Writefile(a:buffer, a:output, l:temp_file)

    return {
    \   'command' :  ale#Escape(l:executable)
    \   . (empty(l:build_dir) ? '' : ' -p ' . ale#Escape(l:build_dir))
    \   . (empty(l:options) ? '' : ' ' . l:options)
    \   . '%t - --stdin --stdin-filename ' . l:temp_file,
    \   'read_temporary_file': 1,
    \}
endfunction
