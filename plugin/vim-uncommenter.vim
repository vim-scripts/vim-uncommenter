" MAKE SURE `#!` IS NOT COUNTED AS A COMMENT

function! DeleteBlockComments(comment_start, comment_end)
	" TODO
endfunction

function! DeleteInlineComments(comment_symbol)
	" save current position before uncommenting file
	:let l:winview = winsaveview()

	" delete comment if not inside of either type of quotation marks
	if &ft == 'vim'
		:g/^\s\{-\}"\(.*\)/d
	else
		if a:comment_symbol == "#"
			:execute 'g!/^\s\{-\}#!/s/^\s\{-\}#\(.*\)//ge'
		else
			:execute 'g/^\s\{-\}'.a:comment_symbol.'\(.*\)/d'
		endif
		:execute 'g!/.\{-\}'."[\"\|']".'\(.*\)'.a:comment_symbol.'\(.*\)'."[\"\|']".'\(.*\)/s/\(.\{-\}\)'.a:comment_symbol.'\(.*\)/\1/ge'
		:execute 'g!/\('."[\"\|']".'.\{-\}\)\@<!'.a:comment_symbol.'\('."[\"\|']".'\)\@!\('.a:comment_symbol.'\)\@!.*/s/'.a:comment_symbol.'\(.*'."[\"\|']".'\)\@!\('.a:comment_symbol.'\)\@!.*//ge'
	endif

	" remove any comment following the last quotation mark on a line
	" TODO:
	" delete comments such as: `puts "#{name}" + "#{name}" # delete this comment`

	" return to saved position before deleting all commented lines
	:call winrestview(l:winview)
endfunction

autocmd FileType ruby,php,python,r,perl,sh,make nnoremap <buffer> dc :silent! call DeleteInlineComments("#")<CR>
autocmd BufEnter *.ps1,*.cobra,*.sd7,*.s7i,*.coffee nnoremap <buffer> dc :silent! call DeleteInlineComments("#")<CR>

autocmd FileType erlang nnoremap <buffer> dc :silent! call DeleteInlineComments("%")<CR>
autocmd BufEnter *.tex nnoremap <buffer> dc :silent! call DeleteInlineComments("%")<CR>

autocmd BufEnter *.monkey,*.vbs,*.sb nnoremap <buffer> dc :silent! call DeleteInlineComments("'")<CR>

autocmd FileType autoit,lisp,scheme nnoremap <buffer> dc :silent! call DeleteInlineComments(";")<CR>
autocmd BufEnter *.reb nnoremap <buffer> dc :silent! call DeleteInlineComments(";")<CR>

autocmd FileType haskell,sql,ada,applescript,eiffel,lua,vhdl nnoremap <buffer> dc :silent! call DeleteInlineComments("--")<CR>
autocmd BufEnter *.applescript nnoremap <buffer> dc :silent! call DeleteInlineComments("--")<CR>

autocmd FileType vim nnoremap <buffer> dc :silent! call DeleteInlineComments('"')<CR>

autocmd FileType c,cpp,php,rust,cs,sass,scss,d,go,java,javascript,pascal nnoremap <buffer> dc :silent! call DeleteInlineComments('\/\/')<CR>
autocmd BufEnter *.as,*.rlib,*.rs,*.scala,*.sc,*.swift,*.pp,*.p nnoremap <buffer> dc :silent! call DeleteInlineComments('\/\/')<CR>
