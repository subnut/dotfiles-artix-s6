" vim: et ts=4 sw=4 fdm=marker
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
setg nowrap
set updatetime=1000



hi SignColumn ctermbg=none
aug MyClearSignColumn
    au!
    au ColorScheme * hi SignColumn ctermbg=none
aug END


if !empty(glob('~/.vim/autoload/plug.vim'))
" Plugins {{{
" -------
aug delayed_plug_load
    au!
aug END
call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/gv.vim', {'on': 'GV'}        " Commit browser
Plug 'tpope/vim-fugitive', {'on': 'GV'}     " Needed by GV

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
let g:mundo_preview_bottom = 1

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


" Get the higlight group of the character under cursor
" ----------------------------------------------------
fun! GetHiGroup()
    return synIDattr(synID(line('.'), col('.'), 1), 'name')
endfun
command! GetHiGroup echo GetHiGroup()

" Colorcolumn toggler
" ------------------
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
command! ColorColumnToggle       call ColorColumnToggle(1)
command! ColorColumnToggleGlobal call ColorColumnToggle(0)
aug MyCustomColorColumn
    au!
    au BufEnter * if &ft =~ 'gitcommit\|vim'
                \| let &l:colorcolumn = '+'.join(range(1,100),',+')
                \| endif
aug END
