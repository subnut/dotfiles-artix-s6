scriptencoding utf-8
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim


let mapleader = ' '
set splitbelow
set splitright
set equalalways
set helpheight=0
set undofile
set smarttab
set updatetime=1000
set timeoutlen=3500
set mouse=
setg nowrap
setg fileformat=unix


hi SignColumn ctermbg=none
aug MyClearSignColumn
    au!
    au ColorScheme * hi SignColumn ctermbg=none
aug END


" GetHiGroup - Get higlight group of the character under cursor {{{
fun! GetHiGroup()
    return synIDattr(synID(line('.'), col('.'), 1), 'name')
endfun
command! GetHiGroup echo GetHiGroup()
"}}}
" Colorcolumn customizations {{{
command! ColorColumnToggle       call ColorColumnToggle(1)
command! ColorColumnToggleGlobal call ColorColumnToggle(0)
fun! ColorColumnToggle(local) "{{{
    if a:local
        if &l:colorcolumn == ''
            let &l:colorcolumn = '+'.join(range(1,100),',+')
        else
            let &l:colorcolumn = ''
        endif
    else
        if &colorcolumn == ''
            let &colorcolumn = '+'.join(range(1,100),',+')
        else
            let &colorcolumn = ''
        endif
    endif
endfun "}}}
aug MyCustomColorColumn
    au!
    au BufEnter * if &ft =~ 'gitcommit\|vim'
                \| let &l:colorcolumn = '+'.join(range(1,100),',+')
                \| endif
aug END "}}}
" Ranger integration {{{
if exists('$RANGER_LEVEL')
    nmap q <cmd>q<CR>
endif "}}}
" My Commentor {{{
map gc <Plug>(MyCommentor)
map gcc gcl

" map gcc <Plug>(My-Commenter)
" map gcu <Plug>(My-Un-Commenter)
map gct <Plug>(My-Comment-Toggler)

" Implementation {{{
fun! MyCommenterHelper() "{{{
    if &l:cms =~ '\v^.*\%s$'
        execute "normal! '<\<C-V>".line("'>").'GI'
                    \. printf(&l:cms, &l:cms =~'\V\s%s' ? '' : ' ')
    elseif &l:cms =~ '\v^.*\%s.*$'
        let l:cms = printf(&l:cms,
                    \(&l:cms =~ '\V\s%s' ? '' : ' ')
                    \. '%s'
                    \. (&l:cms =~ '\V%s\s' ? '' : ' '))
        echom l:cms
        for line in range(line("'<"), line("'>"))
            call setline(line, printf(l:cms, getline(line)))
        endfor
    endif
endfun! "}}}
nmap <Plug>(My-Commenter) V<Plug>(My-Commenter)
vmap <Plug>(My-Commenter) <ESC><cmd>silent! call MyCommenterHelper()<CR>

fun! MyUnCommenterHelper() "{{{
    if &l:cms =~ '\v^.*\%s$'
        let l:cms = printf(&l:cms, '\v {,1}(.*)')
        for line in range(line("'<"), line("'>"))
            call setline(line, substitute(getline(line), l:cms , '\1', ''))
        endfor
    elseif &l:cms =~ '\v^.*\%s.*$'
        let @/ = '\V'.escape(printf(&l:cms,'\v {,1}(.{-}) {,1}\V'),'/')
        execute 'normal! ' . ":'<,'>" . 's//\1/g' . "\<CR>"
    endif
endfun! "}}}
nmap <Plug>(My-Un-Commenter) V<Plug>(My-Un-Commenter)
vmap <Plug>(My-Un-Commenter) <ESC><cmd>silent! call MyUnCommenterHelper()<CR>

fun! MyCommentTogglerOpFunc(...) "{{{
    for line in range(line("'["), line("']"))
        if getline(line) =~ ('\V' .  printf(&l:cms,'\.\*'))
            execute 'normal ' . line . "GV\<Plug>(My-Un-Commenter)"
        else
            execute 'normal ' . line . "GV\<Plug>(My-Commenter)"
        endif
    endfor
    let &opfunc = get(g:,'MyCommentToggler_saved_opfunc','')
    silent! unlet g:MyCommentToggler_saved_opfunc
endfun "}}}
nmap <Plug>(My-Comment-Toggler) 
            \<cmd>let g:MyCommentToggler_saved_opfunc=&opfunc<CR>
            \<cmd>setl opfunc=MyCommentTogglerOpFunc<CR>g@
vmap <Plug>(My-Comment-Toggler) <ESC>'<<Plug>(My-Comment-Toggler)'>

fun! MyCommentorOpFunc(...) "{{{
    if getline(line("'[")) =~ ('\V' .  printf(&l:cms,'\.\*'))
        execute "normal '[V']\<Plug>(My-Un-Commenter)"
    else
        execute "normal '[V']\<Plug>(My-Commenter)"
    endif
    let &opfunc = get(g:,'MyCommentor_saved_opfunc','')
    silent! unlet g:MyCommentor_saved_opfunc
endfun "}}}
nmap <Plug>(MyCommentor) 
            \<cmd>let g:MyCommentor_saved_opfunc=&opfunc<CR>
            \<cmd>setl opfunc=MyCommentorOpFunc<CR>g@
vmap <Plug>(MyCommentor) <ESC>'<<Plug>(MyCommentor)'>
"}}}

"}}}


if !empty(glob('~/.vim/autoload/plug.vim'))
" Plugins {{{
" -------
aug delayed_plug_load
    au!
aug END
call plug#begin('~/.config/nvim/plugged')
Plug 'subnut/visualstar.vim'
    au delayed_plug_load BufEnter * ++once
                \ call timer_start(0, {id->plug#load('visualstar.vim')})
    xmap <leader>* <Plug>(VisualstarSearchReplace)
    nmap <leader>* <Plug>(VisualstarSearchReplace)

Plug 'junegunn/gv.vim', {'on': 'GV'}        " Commit browser
Plug 'tpope/vim-fugitive', {'on': 'GV'}     " Needed by GV

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
    let g:undotree_WindowLayout = 2
    let g:undotree_SetFocusWhenToggle = 1
    nnoremap <leader>u <cmd>UndotreeToggle<cr>

Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
    let g:mundo_preview_bottom = 1
    nnoremap <leader>m <cmd>MundoToggle<cr>

Plug 'airblade/vim-gitgutter', {'on': []}   " Git diff
    au delayed_plug_load BufEnter * ++once call timer_start(0, {id->execute("
                \call plug#load('vim-gitgutter')
                \|doau gitgutter CursorHold")})
    let g:gitgutter_map_keys = 0
    nmap <leader>gp <Plug>(GitGutterPreviewHunk)
    nmap <leader>ga <Plug>(GitGutterStageHunk)
    nmap [g <Plug>(GitGutterPrevHunk)
    nmap ]g <Plug>(GitGutterNextHunk)
    let g:gitgutter_set_sign_backgrounds = 0
    hi GitGutterAdd     ctermfg=2
    hi GitGutterChange  ctermfg=3
    hi GitGutterDelete  ctermfg=1
call plug#end() "}}}
endif


" vim:et:ts=4:sw=4:fdm=marker
