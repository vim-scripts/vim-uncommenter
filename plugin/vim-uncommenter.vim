function! DeleteBlockComments(comment_start, comment_end)
	" save current position before uncommenting file
	:let l:winview = winsaveview()

	:execute ':%s/'.a:comment_start.'\(.\{-\}\n\{-\}.\{-\}\)\{-\}.\{-\}'.a:comment_end.'\(.\{-\}'.a:comment_end.'\)\@!//ge'
	
	" return to saved position before deleting all commented lines
	:call winrestview(l:winview)
endfunction

function! DeleteInlineComments(comment_symbol)
	" save current position before uncommenting file
	:let l:winview = winsaveview()

	" delete comment if not inside of either type of quotation marks
	if &ft == 'vim'
		:g/^\s\{-\}"\(.*\)/d
	else
		if a:comment_symbol == "#"
			:execute 'g!/^\s\{-\}#!\|^\s\{-\}#>/s/^\s\{-\}#\(.*\)//ge'
			:execute 'g!/.\{-\}'."[\"\|']".'\(.*\)'.a:comment_symbol.'\(.*\)'."[\"\|']".'\(.*\)\|^\s\{-\}<#\|\s\{-\}#>/s/\(.\{-\}\)'.a:comment_symbol.'\(.*\)/\1/ge'
		else
			:execute 'g/^\s\{-\}'.a:comment_symbol.'\(.*\)/d'
			:execute 'g!/.\{-\}'."[\"\|']".'\(.*\)'.a:comment_symbol.'\(.*\)'."[\"\|']".'\(.*\)/s/\(.\{-\}\)'.a:comment_symbol.'\(.*\)/\1/ge'
		endif
		:execute 'g!/\('."[\"\|']".'.\{-\}\)\@<!'.a:comment_symbol.'\('."[\"\|']".'\)\@!\('.a:comment_symbol.'\)\@!.*/s/'.a:comment_symbol.'\(.*'."[\"\|']".'\)\@!\('.a:comment_symbol.'\)\@!.*//ge'
	endif

	" return to saved position before deleting all commented lines
	:call winrestview(l:winview)
endfunction

" DELETE ALL COMMENTS

" RUBY
autocmd FileType ruby nnoremap <buffer> dc :silent! call DeleteInlineComments("#")<CR> \| :silent! call DeleteBlockComments("=begin","=end")<CR>

" PHP
autocmd FileType php nnoremap <buffer> dc :silent! call DeleteInlineComments("\/\/")<CR> \| :silent! call DeleteBlockComments("\\/\\*","\\*\\/")<CR>

" PYTHON
" TODO: BLOCK COMMENT FOR PYTHON: START ''' END '''
autocmd FileType python nnoremap <buffer> dc :silent! call DeleteInlineComments("#")<CR> 

" R
autocmd FileType r nnoremap <buffer> dc :silent! call DeleteInlineComments("#")<CR> 

" PERL
autocmd FileType perl nnoremap <buffer> dc :silent! call DeleteInlineComments("#")<CR> \| :silent! call DeleteBlockComments("=begin","=cut")<CR> \| :silent! call DeleteBlockComments("=pod","=cut")<CR>

" SHELL
autocmd FileType sh nnoremap <buffer> dc :silent! call DeleteInlineComments("#")<CR> \| :silent! call DeleteBlockComments("<#","#>")<CR>

" MAKEFILES
autocmd FileType make nnoremap <buffer> dc :silent! call DeleteInlineComments("#")<CR> 

" DELETE ALL INLINE COMMENTS
autocmd BufEnter *.ps1,*.cobra,*.sd7,*.s7i,*.coffee nnoremap <buffer> dc :silent! call DeleteInlineComments("#")<CR>

autocmd FileType erlang nnoremap <buffer> dc :silent! call DeleteInlineComments("%")<CR>
autocmd BufEnter *.tex nnoremap <buffer> dc :silent! call DeleteInlineComments("%")<CR>

autocmd BufEnter *.monkey,*.vbs,*.sb nnoremap <buffer> dc :silent! call DeleteInlineComments("'")<CR>

autocmd FileType autoit,lisp,scheme nnoremap <buffer> dc :silent! call DeleteInlineComments(";")<CR>
autocmd BufEnter *.reb nnoremap <buffer> dc :silent! call DeleteInlineComments(";")<CR>

autocmd FileType haskell,sql,ada,applescript,eiffel,lua,vhdl nnoremap <buffer> dc :silent! call DeleteInlineComments("--")<CR>
autocmd BufEnter *.applescript nnoremap <buffer> dc :silent! call DeleteInlineComments("--")<CR>

autocmd FileType vim nnoremap <buffer> dc :silent! call DeleteInlineComments('"')<CR>

autocmd FileType c,cpp,rust,cs,sass,scss,d,go,java,javascript,pascal nnoremap <buffer> dc :silent! call DeleteInlineComments('\/\/')<CR>
autocmd BufEnter *.as,*.rlib,*.rs,*.scala,*.sc,*.swift,*.pp,*.p nnoremap <buffer> dc :silent! call DeleteInlineComments('\/\/')<CR>
