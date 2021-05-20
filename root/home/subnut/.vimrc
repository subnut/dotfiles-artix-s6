scriptencoding utf-8
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim


let mapleader = ' '
set splitbelow
set splitright
set equalalways
set helpheight=0
set smarttab
set updatetime=1000
set timeoutlen=3500
set title
setg nowrap
setg fileformat=unix
set listchars=eol:$,tab:>-
nnoremap <C-l> <cmd>set list!<CR>

set mouse=n
map <MiddleMouse>   <Nop>
map <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>

nnoremap <leader>b :ls<CR>:b<Space>


hi SignColumn ctermbg=none
aug MyClearSignColumn
    au!
    au ColorScheme * hi SignColumn ctermbg=none
aug END

aug ManPlugin
    au!
    au BufWinEnter *.~ setl kp=:Man
    au BufWinEnter *.c,*.h ++once runtime ftplugin/man.vim
    au BufWinEnter *.c,*.h setl kp=:Man
aug END


" Swap files {{{
if !isdirectory(fnamemodify('~/.vimswap', ':p'))
    if exists('*mkdir')
        call mkdir(fnamemodify('~/.vimswap', ':p'), 'p', 0o0700)
        if !isdirectory(fnamemodify('~/.vimswap', ':p'))
            set directory=~/.vimswap//
        endif
    else
        echohl WarningMsg
        echom 'Please create ~/.vimswap directory with with permissions 0700'
        echohl None
    endif
else
    set directory=~/.vimswap//
    if getfperm(fnamemodify('~/.vimswap', ':p')) !=# 'rwx------'
        call setfperm(fnamemodify('~/.vimswap', ':p'), 'rwx------')
    endif
endif
" }}}
" Persistent undo {{{
if has('persistent_undo')
    if !isdirectory(fnamemodify('~/.vimundo', ':p'))
        if exists('*mkdir')
            " NOTE: The execute bit is nessecary, because otherwise we cannot
            " cd into that directory, nor can we create new files in th directory
            call mkdir(fnamemodify('~/.vimundo', ':p'), 'p', 0o0700)
        else
            echohl WarningMsg
            echom 'Directory ~/.vimundo not available. Persistent undo disabled.'
            echohl None
        endif
    endif
    set undofile
    set undodir=~/.vimundo
    if getfperm(fnamemodify('~/.vimundo', ':p')) !=# 'rwx------'
        call setfperm(fnamemodify('~/.vimundo', ':p'), 'rwx------')
    endif
else
    echohl WarningMsg
    echom 'Vim not compiled with +peristent_undo. Persistent undo disabled.'
    echohl None
endif
" }}}
" Delete surrounding (ds) {{{
nnoremap <silent><expr> ds 'di' . nr2char(getchar()) . 'vhp'
" }}}
" Ranger integration {{{
if exists('$RANGER_LEVEL')
    nmap q <cmd>q<CR>
endif "}}}
" GetHiGroup - Get higlight group of the character under cursor {{{
fun! GetHiGroup()
    return synIDattr(synID(line('.'), col('.'), 1), 'name')
endfun
command! GetHiGroup echo GetHiGroup()
"}}}
" Show Trailing Spaces {{{
hi TrailingWhitespace term=standout ctermfg=red ctermbg=red guifg=red guibg=red
let w:trailing_whitespace = matchadd('TrailingWhitespace', '\s\+$')
aug TrailingWhitespace
    au!
    au ColorScheme * hi TrailingWhitespace
                \ term=standout ctermfg=red ctermbg=red guifg=red guibg=red
    au WinNew * let w:trailing_whitespace
                \ = matchadd('TrailingWhitespace', '\s\+$')
aug END
com! TrailingWhitespace
            \ if w:trailing_whitespace
                \|call matchdelete(w:trailing_whitespace)
                \|let w:trailing_whitespace = 0
            \|else
                \|let w:trailing_whitespace =
                    \matchadd('TrailingWhitespace', '\s\+$')
            \|endif
" }}}
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
aug END
" }}}
" My Commentor {{{
map gc <Plug>(MyCommentor)
map gcc gcl

" map gcc <Plug>(My-Commenter)
" map gcu <Plug>(My-Un-Commenter)
map gct <Plug>(My-Comment-Toggler)

" Implementation {{{
fun! MyCommenterHelper() "{{{
    " if comments like #python
    if &l:cms =~ '\v^.*\%s$'
        " - Goto start of last selection
        " - Restart last selection
        " - Switch to Visual-Block mode
        " - Insert the cms at the front of each line
        " The printf is added to input an extra space between the cms and the
        " commented text, just to look nice.
        execute 'normal! `<gv' . "\<C-V>" . 'I'
                    \. printf(&l:cms, &l:cms =~'\V\s%s' ? '' : ' ')

    " if comments like /* CSS */
    elseif &l:cms =~ '\v^.*\%s.*$'
        " First compute the cms, with nice-to-look spaces added between
        " comment characters and commented text
        let l:cms = '\1' . printf(&l:cms,
                    \(&l:cms =~ '\V\s%s' ? '' : ' ')
                    \. '\2'
                    \. (&l:cms =~ '\V%s\s' ? '' : ' '))
        " Then do the actual commenting, line-by-line
        for line in range(line("'<"), line("'>"))
            call setline(line, substitute(
                            \getline(line), '\v^(\s*)(.{-})$', l:cms, ''
                            \)
                        \)
        endfor
    endif
endfun! "}}}
nmap <Plug>(My-Commenter) V<Plug>(My-Commenter)
vmap <Plug>(My-Commenter) <ESC><cmd>silent! call MyCommenterHelper()<CR>
fun! MyUnCommenterHelper() "{{{
    let l:saved = @/
    let @/ = '\v^(\s{-})\V'
    if &l:cms =~ '\v^.*\%s$'
        let @/ .= escape(printf(&l:cms, '\v {,1}(.*)'), '/')
    elseif &l:cms =~ '\v^.*\%s.*$'
        let @/ .= escape(printf(&l:cms,'\v {,1}(.{-}) {,1}\V'),'/')
    endif
    execute 'normal! ' . ":'<,'>" . 's//\1\2/g' . "\<CR>"
    let @/ = l:saved
endfun! "}}}
nmap <Plug>(My-Un-Commenter) V<Plug>(My-Un-Commenter)
vmap <Plug>(My-Un-Commenter) <ESC><cmd>silent! call MyUnCommenterHelper()<CR>

fun! MyCommentTogglerOpFunc(...) "{{{
    for line in range(line("'["), line("']"))
        if getline(line) =~ ('\v^\s{-}\V' .  printf(&l:cms,'\.\*'))
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
    if getline(line("'[")) =~ ('\v^\s{-}\V' .  printf(&l:cms,'\.\*'))
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
                \ call timer_start(0, {->plug#load('visualstar.vim')})
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
    au delayed_plug_load BufEnter * ++once call timer_start(0, {->execute("
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

Plug 'psf/black', { 'branch': 'stable', 'on': [] }          " Auto-formatter
    au delayed_plug_load BufEnter * ++once
                \ call timer_start(100, {->plug#load('black')})
    aug Black
        au!
        au BufWritePre * exe (&l:ft == 'python' ? 'Black' : '')
    aug END

Plug 'sainnhe/gruvbox-material'
    let g:gruvbox_material_better_performance = 1
    let g:gruvbox_material_sign_column_background = 'none'
    let g:gruvbox_material_background = 'hard'
    let g:gruvbox_material_palette = 'mix'
    aug gruvbox_material_overrides
        au!
        au ColorScheme gruvbox-material hi CurrentWord
                    \ term=underline cterm=underline gui=underline
    aug END
call plug#end()
else
    echohl WarningMsg
    echom 'vim-plug not installed. plugins not available.'
    echohl None
endif
"}}}


if !empty($MY_NVIM_BG)
    let &background = $MY_NVIM_BG
endif


if $TERM =~ 'alacritty\|st-256color' "{{{
    if $TERM =~ 'st-256color'
        ":h xterm-true-color
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    elseif $TERM =~ 'alacritty'
        ":h xterm-true-color
        let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
        let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
    endif
    set termguicolors
    colorscheme gruvbox-material
endif
"}}}


" vim:et:ts=4:sts=0:sw=0:fdm=marker
