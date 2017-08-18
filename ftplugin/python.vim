if exists('b:loaded_python_fold')
  finish
endif
let b:loaded_python_fold = 1

":1 PythonFoldText
function! g:PythonFoldText()
  let l:line = getline(v:foldstart)

  if l:line =~# '"""'
    let l:nextline = getline(v:foldstart + 1)
    let l:indent = indent(v:foldstart + 1)
    return repeat(' ', l:indent) . '✎᳟… ' . l:nextline[l:indent:]
  endif

  if l:line =~# '\(from \|import \)'
    let l:indent = indent(v:foldstart)
    return repeat(' ', l:indent) . 'import ' . substitute(l:line, '^.*import\s', '', '')
  endif

  return l:line

endfunction
" endfold

autocmd FileType python setlocal textwidth=90
autocmd BufWritePost,InsertLeave *.py setlocal filetype=python

autocmd BufEnter * if &filetype == 'python' |nmap <F5>   :w<CR>:!time python '%'            <CR>| endif
autocmd BufEnter * if &filetype == 'python' |nmap <S-F5> :w<CR>:!time python '%' < input.txt<CR>| endif
autocmd BufEnter * if &filetype == 'python' |nmap <F9>   :w<CR>:!pep8 '%'                   <CR>| endif
