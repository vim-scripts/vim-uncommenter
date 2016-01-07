" TODO: ---SIMPLE-TASK--- RE-ORDER BOTTOM LIST ALPHABETICALLY
" TODO: ---HIGH-PRIORITY--- REPLACE ANY REGEX THAT AVOIDS QUOTES ETC, WITH
" REGEX FROM MY `vim-rubyformat` PLUGIN REGEX FUNCTION UNLESS SPECIFIC SYMBOL
" SUCH AS FOR COMMENTS THAT START WITH `QUOTES` OR `/` FOR EXAMPLE
" TODO: CREATE A FUNCTION OR WAY TO ALLOW TO CALL `dc` FOR EXAMPLE LIKE `5dc`
" WHICH ONLY THEN DELETES THE TOP 5 LINES'S COMMENTS IF THERE ARE ANY, OR FOR
" ANOTHER EXAMPLE `10,25dc` WHICH CAN THEN DELETE COMMENTS BETWEEN THE LINES 10
" AND 25. LOOK INTO HOW FUNCTIONS LIKE `:%s` and `:10,25s`
" TODO: REMOVE ANY REMOVED COMMENT'S EMPTY LINES THAT REMAIN AFTER
" REMOVING ANY COMMENTS, BUT ONLY THOSE LINES AND NOT EVERY EMPTY LINE
" TODO: FINISH BLOCK COMMENT FUNCTIONALITY FOR REST OF CURRENT PROGRAMMING LANGUAGE LIST.
" TODO: FIX `dc` RESTORING CURRENT POSITION BUG NOW THAT THERE ARE 2 SEPERATE
" FUNCTIONS CALLING IT. POSSIBLY MAKE ONE FUNCTION CALL BOTH FUNCTIONS AND
" SAVE BEFORE AND RESTORE AFTER CALL?
" TODO: BLOCK COMMENT FOR PYTHON: START ''' END '''

function! DeleteInlineComments(comment_symbol)
	" SAVE CURSOR POSITION IN WINDOW BEFORE FORMAT
	let l:inlinewinview = winsaveview()

	" DELETE COMMENTS THAT ARE AT THE START OF THE LINE ONLY WITH ANY AMMOUNT
	" OF SPACES BEFORE IT
	if &ft == 'vim'
		g/^\s\{-\}"\(.*\)/d
	else
		if a:comment_symbol == "#"
			execute 'g!/^\s\{-\}#!\|^\s\{-\}#>/s/^\s\{-\}#\(.*\)//ge'
			execute 'g!/.\{-\}'."[\"\|']".'\(.*\)'.a:comment_symbol.'\(.*\)'."[\"\|']".'\(.*\)\|^\s\{-\}<#\|\s\{-\}#>/s/\(.\{-\}\)'.a:comment_symbol.'\(.*\)/\1/ge'
		else
			execute 'g/^\s\{-\}'.a:comment_symbol.'\(.*\)/d'
			execute 'g!/.\{-\}'."[\"\|']".'\(.*\)'.a:comment_symbol.'\(.*\)'."[\"\|']".'\(.*\)/s/\(.\{-\}\)'.a:comment_symbol.'\(.*\)/\1/ge'
		endif
		execute 'g!/\('."[\"\|']".'.\{-\}\)\@<!'.a:comment_symbol.'\('."[\"\|']".'\)\@!\('.a:comment_symbol.'\)\@!.*/s/'.a:comment_symbol.'\(.*'."[\"\|']".'\)\@!\('.a:comment_symbol.'\)\@!.*//ge'
	endif

	" RETURN TO CURSOR POSITION IN WINDOW AFTER UNCOMMENT
	call winrestview(l:inlinewinview)
endfunction

function! DeleteBlockComments(comment_start, comment_end)
	" SAVE CURSOR POSITION IN WINDOW BEFORE FORMAT
	let l:blockwinview = winsaveview()

	execute ':%s/'.a:comment_start.'\(.\{-\}\n\{-\}.\{-\}\)\{-\}.\{-\}'.a:comment_end.'\(.\{-\}'.a:comment_end.'\)\@!//ge'

	" RETURN TO CURSOR POSITION IN WINDOW AFTER UNCOMMENT
	call winrestview(l:blockwinview)
endfunction

function! DeleteAllComments(inline_symbol, block_start, block_end)
	" SAVE CURSOR POSITION IN WINDOW BEFORE FORMAT
	let l:allwinview = winsaveview()

	" DELETE BLOCK COMMENTS
	call DeleteBlockComments(a:block_start, a:block_end)

	" GO BACK TO THE TOP TO NOW RUN DELETE INLINE COMMENTS FUNCTION
	normal gg

	" DELETE INLINE COMMENTS
	call DeleteInlineComments(a:inline_symbol)

	" RETURN TO CURSOR POSITION IN WINDOW AFTER UNCOMMENT
	call winrestview(l:allwinview)
endfunction

" DELETE ALL COMMENTS

" RUBY
autocmd FileType ruby nnoremap <buffer> dc :silent! call DeleteAllComments("#","=begin","=end")<CR>

" PERL 
autocmd FileType perl nnoremap <buffer> dc :silent! call DeleteAllComments("#","=[begin\|pod]","=cut")<CR>

" C/C++/C#/GO/JAVASCRIPT/JAVA/RUST/SASS/SCSS
autocmd FileType c,cpp,cs,go,javascript,java,rust,sass,scss nnoremap <buffer> dc :silent! call DeleteAllComments("\\/\\/","\\/\\*","\\*\\/")<CR>

" ACTIONSCRIPT/RUST/SCALA/SWIFT
autocmd BufEnter *.as,*.rlib,*.rs,*.scala,*.sc,*.swift nnoremap <buffer> dc :silent! call DeleteAllComments("\\/\\/","\\/\\*","\\*\\/")<CR>

" D
autocmd FileType d nnoremap <buffer> dc :silent call DeleteBlockComments("\\/+","+\\/") \| :silent! call DeleteAllComments("\\/\\/","\\/\\*","\\*\\/")<CR>

" CSS - INLINE AND BLOCK ARE THE SAME FOR CSS
autocmd FileType css nnoremap <buffer> dc :silent! call DeleteBlockComments("\\/\\*","\\*\\/")<CR>

" PHP
autocmd FileType php nnoremap <buffer> dc :silent call DeleteInlineComments("#") \| :silent! call DeleteAllComments("\\/\\/","\\/\\*","\\*\\/")<CR>

" PYTHON
autocmd FileType python nnoremap <buffer> dc :silent! call DeleteInlineComments("#")<CR> 

" MAKEFILE
autocmd FileType make nnoremap <buffer> dc :silent! call DeleteInlineComments("#")<CR> 

" R/SHELL/POWERSHELL/TCL/AWK
autocmd FileType r,sh,awk,tcl nnoremap <buffer> dc :silent! call DeleteAllComments("#","<#","#>")<CR>
autocmd BufEnter *.ps1,*.csh,*.zsh nnoremap <buffer> dc :silent! call DeleteAllComments("#","<#","#>")<CR>

" MAPLE
autocmd FileType maple nnoremap <buffer> dc :silent call DeleteBlockComments("(\\*","\\*)") \| :silent! call DeleteAllComments("#","<#","#>")<CR>

" APPLESCRIPT
autocmd FileType applescript nnoremap <buffer> dc :silent! call DeleteAllComments("--","(\\*","\\*)")<CR>
autocmd BufEnter *.applescript nnoremap <buffer> dc :silent! call DeleteAllComments("--","(\\*","\\*)")<CR> 

" AUTOHOTKEY
autocmd FileType autohotkey nnoremap <buffer> dc :silent! call DeleteAllComments(";","\\/\\*","\\*\\/")<CR> 

" AUTOIT
autocmd FileType autoit nnoremap <buffer> dc :silent! call DeleteAllComments(";","#cs","#ce")<CR> 

" COBRA
autocmd BufEnter *.cobra nnoremap <buffer> dc :silent! call DeleteAllComments("#","\\/#","#\\/")<CR>

" COFFEESCRIPT
autocmd BufEnter *.coffee nnoremap <buffer> dc :silent! call DeleteAllComments("#","###","###")<CR>

" SEED7
autocmd BufEnter *.sd7,*.s7i nnoremap <buffer> dc :silent! call DeleteAllComments("#","(\\*","\\*)")<CR>

" ERLANG/TEX
autocmd FileType erlang nnoremap <buffer> dc :silent! call DeleteInlineComments("%")<CR>
autocmd BufEnter *.tex nnoremap <buffer> dc :silent! call DeleteInlineComments("%")<CR>

" MONKEY/VISUAL BASIC/SMALL BASIC
autocmd FileType vb,aspvbs,wsh nnoremap <buffer> dc :silent! call DeleteInlineComments("'")<CR>
autocmd BufEnter *.monkey,*.sb nnoremap <buffer> dc :silent! call DeleteInlineComments("'")<CR>

" VIM
autocmd FileType vim nnoremap <buffer> dc :silent! call DeleteInlineComments('"')<CR>

" LISP/SCHEME
autocmd FileType lisp,scheme nnoremap <buffer> dc :silent! call DeleteAllComments(";","#\|","\|#")<CR> 

" REBOL
autocmd BufEnter *.reb nnoremap <buffer> dc :silent! call DeleteInlineComments(";")<CR>

" HASKELL
autocmd FileType haskell nnoremap <buffer> dc :silent! call DeleteAllComments("--","{-","-}")<CR>
autocmd BufEnter *.lhs nnoremap <buffer> dc :silent! call DeleteAllComments("--","{-","-}")<CR>

" SQL
autocmd FileType sql nnoremap <buffer> dc :silent! call DeleteAllComments("--","\\/\\*","\\*\\/")<CR>

" ADA/EIFFEL/VHDL
autocmd FileType ada,eiffel,vhdl nnoremap <buffer> dc :silent! call DeleteInlineComments("--")<CR>

" LUA
autocmd FileType lua nnoremap <buffer> dc :silent! call DeleteAllComments("--","--[\[\[]","\]\]")<CR>

" PASCAL
autocmd FileType pascal nnoremap <buffer> dc :silent! call DeleteAllComments("\\/\\/","(\\*","\\*)")<CR>
autocmd BufEnter *.p,*.pp nnoremap <buffer> dc :silent! call DeleteAllComments("\\/\\/","(\\*","\\*)")<CR>
