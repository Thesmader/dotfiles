" Rename symbol
nmap <leader>rn <Plug>(coc-rename)
" nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>
" KeyBindings
" xmap <leader>a <Plug>(coc-codeaction-selected)
" nmap <leader>a <Plug>(coc-codeaction-selected)
"nmap <silent> <C-p>

" FZF
" nnoremap <silent> <C-p> :GFiles<cr>

" GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
" nnoremap <silent> K : call <SID>show_documentation()<CR>

" function! s:show_documentation()
  " if(index(['vim','help'], &filetype) >= 0)
    " execute 'h '.expand('<cword>')
  " else
    " call CocActionAsync('doHover')
  " endif
" endfunction

