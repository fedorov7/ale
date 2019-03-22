scriptencoding utf-8
" Author: Alexander Fedorov <fedorov7@gmail.com>
" Description: Handle errors for iwyu tool.

function! s:RemoveUnicodeQuotes(text) abort
    let l:text = a:text
    let l:text = substitute(l:text, '[`´‘’]', '''', 'g')
    let l:text = substitute(l:text, '\v\\u2018([^\\]+)\\u2019', '''\1''', 'g')
    let l:text = substitute(l:text, '[“”]', '"', 'g')

    return l:text
endfunction

function! ale#handlers#iwyu#HandleIwyuFormat(buffer, lines) abort
    " Look for lines like the following.
    "
    " /path/test.cpp:5:1: error: remove the following line
    let l:pattern = '\v^([^:]+):(\d+):(\d+)?:? ([^:]+): (.+)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        " if bufname(a:buffer) == l:match[1]
        call add(l:output, {
        \   'filename': l:match[1],
        \   'lnum': str2nr(l:match[2]),
        \   'col': str2nr(l:match[3]),
        \   'type': (l:match[4] is# 'error' || l:match[4] is# 'fatal error') ? 'E' : 'W',
        \   'text': s:RemoveUnicodeQuotes(l:match[5]),
        \})
    endfor

    return l:output
endfunction
