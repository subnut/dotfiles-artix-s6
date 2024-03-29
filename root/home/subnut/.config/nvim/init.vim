" vim: fdm=marker ts=4 nowrap sw=0 sts=0 et
scriptencoding utf-8
" set nolpl

" Open file at last cursor position " {{{1
" ---------------------------------
augroup file_open_last_pos
au!
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
augroup end " }}}
" Use our specific python venv only {{{
let g:python3_host_prog = '$HOME/.config/nvim/venv/bin/python'
if len($VIRTUAL_ENV) == 0
    let $PATH = '$HOME/.config/nvim/venv/bin:' . $PATH
else
    let $PATH = join(insert(split($PATH, ':'),'$HOME/.config/nvim/venv/bin',1),':')
endif " }}}
" Save Undo history " {{{1
" if has('persistent_undo')                                   " guard for distributions lacking the persistent_undo feature.
"     " define a path to store persistent_undo files
"     let target_path = split(expand('<sfile>:p'),expand('<sfile>:t'))[0] . '.undo_history'
"     if !isdirectory(target_path)                            " if the location does not exist,
"         call system('mkdir -p ' . target_path)              " create the directory and any parent directories
"     endif
"     let &undodir = target_path                              " point Vim to the defined undo directory
"     set undofile                                            " finally, enable undo persistence
" endif   " }}}
" Workaround for correctly switching colorschemes   " {{{1
" https://github.com/altercation/solarized/issues/102#issuecomment-275269574
" https://github.com/altercation/solarized/issues/102#issuecomment-352329521
" https://opensource.stackexchange.com/questions/2187/how-much-is-substantial-portion-in-mit-licence/2188#2188
" -------------------------------------------------------------------------------------------------------------------------
if !exists('s:known_links')
    let s:known_links = {}
endif

fun! s:Find_links() " {{{2
    " Find and remember links between highlighting groups.
    redir => listing
    try
        silent highlight
    finally
        redir END
    endtry
    for line in split(listing, "\n")
        let tokens = split(line)
        " We're looking for lines like "String xxx links to Constant" in the
        " output of the :highlight command.
        if len(tokens) ==# 5 && tokens[1] ==# 'xxx' && tokens[2] ==# 'links' && tokens[3] ==# 'to'
            let fromgroup = tokens[0]
            let togroup = tokens[4]
            let s:known_links[fromgroup] = togroup
        endif
    endfor
endfun

fun! s:Restore_links() " {{{2
    " Restore broken links between highlighting groups.
    redir => listing
    try
        silent highlight
    finally
        redir END
    endtry
    let num_restored = 0
    for line in split(listing, "\n")
        let tokens = split(line)
        " We're looking for lines like "String xxx cleared" in the
        " output of the :highlight command.
        if len(tokens) ==# 3 && tokens[1] ==# 'xxx' && tokens[2] ==# 'cleared'
            let fromgroup = tokens[0]
            let togroup = get(s:known_links, fromgroup, '')
            if !empty(togroup)
                execute 'hi link' fromgroup togroup
                let num_restored += 1
            endif
        endif
    endfor
endfun " }}}

fun! s:AccurateColorscheme(colo_name)
    call <SID>Find_links()
    exec 'colorscheme ' a:colo_name
    call <SID>Restore_links()
endfun

command! -nargs=1 -complete=color MyColorscheme call <SID>AccurateColorscheme(<q-args>)
" --------------------------------------------------------------------------------------------------------------    " }}}

augroup colorscheme_overrides
    au!
augroup END

" Polyglot sets "noswapfile"
" stop it from doing that
    let g:polyglot_disabled = ['sensible']
" see ":h swapfile" for why not

" Disable polyglot plasticboy markdown to avoid clashing with gabrielelana
"   let g:polyglot_disabled += ['markdown.plugin']
" NOTE: This configuration MUST be set before vim-polyglot is loaded

" let g:polyglot_disabled += ['ftdetect']


" Custom settings
" ---------------
" set colorcolumn=+1
" set tildeop         " use ~<motion> to change case of characters over <motion>
set splitright      " default split direction
set splitbelow      " default split direction
set equalalways
set helpheight=0    " Help window height is same as all other windows
set ignorecase      " Ignore uppercase and lowercase
set smartcase       " If search contains UPPERCASE letter, then set "noignorecase"
set mouse=ar
set clipboard=unnamedplus
set cursorline
set undofile                    " keep undo history at &undodir
set notimeout                   " do not timeout mappings
" au BufWinEnter *.py %retab!   " Replace all tabs with spaces when entering a python file
" set foldmethod=marker
set showbreak=¬\                " The backslash is used to escape the space after it
set autoread
set autowrite
set number
set relativenumber
set signcolumn=yes
setg nowrap
setg noexpandtab                " DO NOT replace tabs with spaces
setg tabstop=4                  " No. of spaces that <TAB> stands for
setg shiftwidth=0               " i.e. tabstop value used for auto-indenting

" differences from vim
" set guicursor=n-v-c:block,o:hor50,i-ci:hor15,r-cr:hor30,sm:block   "vim
set  sidescroll=0
set  scrolloff=5
setg fileencoding=utf-8
setg formatoptions+=j
setg formatoptions+=r
setg formatoptions+=o
setg formatoptions+=l
setg complete+=i

nnoremap <C-n>     <cmd>set number! relativenumber!<CR>
nnoremap <C-A-n>   <cmd>set relativenumber!<CR>
nnoremap gB        <cmd>bprev<CR>
nnoremap gb        <cmd>bnext<CR>
nnoremap <C-l>     <cmd>set list!<CR>
" nnoremap <silent> <C-g>     :Goyo<CR>

" NOTE: These are pretty darn useful.
    inoremap <a-o> <c-o>
"   inoremap <C-w> <C-o>

" inoremap <A-Space> <Esc>
" Just use <C-[>

let mapleader = ' '
com! YankAll %y
nnoremap <leader>y <cmd>%y<CR>

nnoremap <leader>e <cmd>CHADopen<cr>
nnoremap <leader>r <cmd>LspRename<cr>
nnoremap <leader>m <cmd>MundoToggle<cr>
nnoremap <leader>u <cmd>UndotreeToggle<cr>
nnoremap <leader>i <cmd>IndentLinesToggle<cr>

" Indent lines for tab-indented files
nnoremap <expr> <leader><S-i> (&l:list ? '<cmd>setl nolist<CR><cmd>setl listchars<<CR>' : '<cmd>setl listchars=tab:│\ <CR><cmd>setl list<CR>')

" Goto specific line-number using <LineNr>Enter
nnoremap <silent><expr> <CR> (v:count ? 'G' : '<CR>')

" buffer-switching
nnoremap <leader>b :ls<CR>:b<Space>

" exit Insert mode in terminal
tnoremap <leader><Esc> <C-\><C-n>

" Plugins{{{1
" ---------

call plug#begin()   " Make sure you use single-quotes in all Plug commands below

" NCM2
" -----------------------------------------------------------------------
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/float-preview.nvim'

" Subscope-detectors
" Plug 'ncm2/ncm2-markdown-subscope'
" Plug 'ncm2/ncm2-html-subscope'

" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
" Plug 'ncm2/ncm2-bufword'
" Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-jedi'       "python
Plug 'ncm2/ncm2-pyclang'    "c/cpp
Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'
Plug 'subnut/ncm2-github-emoji', { 'do': 'python install.py' }
" -----------------------------------------------------------------------

" LSP
" ------------------------------------------------------------------------
" Enable from command line using
"   nvim --cmd 'let g:enable_lsp = 1'  ...
if get(g:,'enable_lsp', 0)
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'

    " Integration with ncm2
    Plug 'ncm2/ncm2-vim-lsp'
    let g:ncm2_vim_lsp_blocklist = ['vim-language-server']
endif
" ------------------------------------------------------------------------

" Neovim nightly
" --------------
if has("nvim-0.5")
    "  Treesitter
    Plug 'nvim-treesitter/nvim-treesitter'
    " Plug 'romgrk/barbar.nvim'
    " Plug 'kyazdani42/nvim-web-devicons'

    " Colorschemes that support treesitter
    Plug 'vigoux/oak'
    Plug 'Th3Whit3Wolf/onebuddy'
    Plug 'mhartington/oceanic-next'
    Plug 'glepnir/zephyr-nvim'
    Plug 'Iron-E/nvim-highlite'
endif
" ---------------

" Colorschemes that support Treesitter but also work in v0.4.4
" ------------------------------------------------------------
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/sonokai', {'on': 'color sonokai'}
Plug 'sainnhe/edge', {'on': 'color edge'}

" Markdown
" Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'], 'on': 'MarkdownPreview'}

" Fuzzy-finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' , 'on':[]}
Plug 'junegunn/fzf.vim', {'on': []}

" Git
Plug 'junegunn/gv.vim', {'on': 'GV'}        " Commit browser
Plug 'tpope/vim-fugitive', {'on': 'GV'}       " Needed by GV

" Statusline
" Plug 'itchyny/lightline.vim'
let g:lightline = {}

" Python
" -------
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }   " Python PEP8 autoindent
Plug 'kalekundert/vim-coiled-snake', { 'for': 'python' }    " Python folding
Plug 'psf/black', { 'branch': 'stable', 'on': [] }          " Auto-formatter
Plug 'Yggdroot/indentLine', {'on': 'IndentLinesToggle'}
" Plug 'lukas-reineke/indent-blankline.nvim'


" Plugins that don't need interaction
" -----------------------------------
Plug 'tpope/vim-surround'
Plug 'airblade/vim-rooter'                          " Change root dir
Plug 'machakann/vim-highlightedyank'
let g:highlightedyank_highlight_duration = 3000
Plug 'tpope/vim-repeat'
Plug 'Konfekt/FastFold'                             " Better folding
" Plug 'sheerun/vim-polyglot'                         " Polyglot => one who knows many languages
Plug 'romainl/vim-cool'                             " Remove search highlight automatically
Plug 'sgur/vim-editorconfig'
Plug 'subnut/visualstar.vim'
Plug 'unblevable/quick-scope', {'on': []}
Plug 'justinmk/vim-sneak', {'on': []}               " s<char><char> (z<char><char> for operator-pending mode)
Plug 'mox-mox/vim-localsearch'
Plug 'junegunn/vim-peekaboo'


" Misc
" ----
"   Plug 'wincent/scalpel'
" The above functionality can be accessed by simply using the /c switch

" Plug 'majutsushi/tagbar'
" Plug 'rhysd/git-messenger.vim', {'on': ['GitMessenger', '<Plug>(git-messenger)']} " :GitMessenger or <Plug>(git-messenger) to see git-blame of current line

Plug 'AndrewRadev/bufferize.vim'
Plug 'AndrewRadev/inline_edit.vim', {'on': 'InlineEdit'}
Plug 'mtth/scratch.vim', {'on': ['Scratch', 'ScratchInsert', 'ScratchPreview', 'ScratchSelection']}

Plug 'tpope/vim-commentary'                         " gc<motion> = toggle comment
Plug 'airblade/vim-gitgutter', {'on': []}           " Git diff
Plug 'vim-syntastic/syntastic'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
let g:mundo_preview_bottom = 1
Plug 'subnut/nvim-ghost.nvim', {'on': [], 'do': ':call nvim_ghost#installer#install()', 'branch': 'devel'}

" Vanity
" ------
Plug 'reedes/vim-pencil'
Plug 'kkoomen/vim-doge', {'do':{->doge#install()}, 'on': ['<Plug>(doge-generate)', 'DogeGenerate']} " (DO)cumentation (GE)nerator


call plug#end()
augroup delayed_plug_load
    au!
    au BufEnter *     ++once call timer_start(10, {->plug#load('nvim-ghost.nvim')})
    au BufEnter *     ++once call timer_start(800, {->plug#load('vim-sneak')})
    au BufEnter *     ++once call timer_start(800, {->plug#load('vim-fugitive')})
    au BufEnter *     ++once call timer_start(100, {->plug#load('fzf')})
    au BufEnter *     ++once call timer_start(100, {->plug#load('fzf.vim')})
    au BufEnter *     ++once call timer_start(0, {->execute("call plug#load('vim-gitgutter')|doau gitgutter CursorHold")})
    au BufEnter *     ++once call timer_start(100, {->plug#load('quick-scope')})
    au BufEnter *     ++once call timer_start(100, {->plug#load('black')})

    " because all of the above plugins were not fortunate enough to receive a
    " VimEnter event, so we shall trigger one ourselves
    "
    " The value should be twice the maximum value above, to ensure all of them
    " have properly loaded.
    au BufEnter *     ++once call timer_start(200, {id->execute("doau VimEnter")})
    au BufEnter *     ++once call timer_start(200, {id->execute("if !empty(nvim_list_uis()) | doau UIEnter | endif")})
augroup end
augroup black_on_write
    au!
    autocmd BufWritePre * if &ft == "python" | let &ch=2 | execute ':Black' | endif
augroup end
"}}}


" Set GUI colors
" --------------
if ($TERM !~ 'linux\|screen\|vt220') && has('termguicolors')
    set termguicolors
endif
syntax enable


" gruvbox-material
" ----------------
" let g:gruvbox_material_enable_italic = 1  " Italic is disabled for Recursive Mono
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_sign_column_background = 'none'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_palette = 'mix'
" let g:gruvbox_material_diagnostic_line_highlight = 1
au colorscheme_overrides ColorScheme gruvbox-material hi CurrentWord gui=underline cterm=underline
            \|if get(g:,'gruvbox_material_transparent_background',0)
                \| hi clear Cursorline
            \|endif
            \|silent! exec 'hi CursorLineNr'
            \.' guibg='
                \.synIDattr(synIDtrans(hlID('CursorLine')), 'bg', 'gui')
            \.' ctermbg='
                \.synIDattr(synIDtrans(hlID('CursorLine')), 'bg', 'cterm')

" set colorscheme
" -----------
fun! My_bg_setter()
    let &background = get(environ(),'MY_NVIM_BG','light')
    colorscheme gruvbox-material
    let g:lightline.colorscheme = 'gruvbox_material'
endfun
if &termguicolors
    call My_bg_setter()
endif

" Goyo customization {{{1
" " ------------------
" " let g:goyo_width=100
" " let g:goyo_height=20
" let g:goyo_width='70%'
" fun! s:goyo_enter()
"   let s:saved_signcolumn_state = &l:scl
"   set scl=no
" endfun
" fun! s:goyo_leave()
"     if exists('s:saved_signcolumn_state')
"         let &l:scl = s:saved_signcolumn_state
"         unlet s:saved_signcolumn_state
"     endif
" endfun
" augroup goyo_customization
"     au!
"     autocmd User GoyoEnter nested call <SID>goyo_enter()
"     autocmd User GoyoLeave nested call <SID>goyo_leave()
"     autocmd User GoyoEnter echo
" augroup end
" " }}}1

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



" Advanced customization
" ----------------------
" Automatically close in markdown and html
"
"       *   "<" --> "<>" with cursor in between < and >
"       *   If <CR> inside tag at beginning, "/", else if <CR> inside tag at end, directly goto next line

augroup my_autoclose_au
    au!
    au BufEnter,FileType * if &l:ft =~ 'markdown\|html'
                \|execute('inoremap <buffer> < <><Left>')
                \|execute("inoremap <buffer><expr> > getline('.')[col('.')-1] == '>' ? '<Right>' : '>'")
                \|execute("imap <buffer><expr> <CR> ((getline('.')[col('.') - 2] == '<') ? '/' : ((getline('.')[col('.') - 1] == '>') ? '<Right><CR>' : ( pumvisible() ? '<c-y><cr>'  : '<CR>')))")
                \|endif
augroup end

" Change previewheight on terminal resize
let g:my_auto_preview_window_height_percentage = 30
let &pvh = &lines * g:my_auto_preview_window_height_percentage / 100
augroup my_auto_previewheight
    au!
    au VimResized * let &pvh = &lines * g:my_auto_preview_window_height_percentage / 100
augroup end


" Battery saver mode
" ------------------
fun! MyOnBattery() " {{{1
    if has('macunix')
        return match(system('pmset -g batt'), "Now drawing from 'Battery Power'") != -1
    elseif has('unix')
        return
                \(
                    \filereadable('/sys/class/power_supply/AC/online') &&
                    \(readfile('/sys/class/power_supply/AC/online') == ['0'])
                \) ||
                \(
                    \(system('uname') =~ 'OpenBSD') &&
                    \(system(['apm','-a']) != '1')
                \)
    endif
    return 0
endfun
    " }}}
if MyOnBattery()
    let g:ncm2#complete_delay = 1000
    let g:mkdp_refresh_slow = 1 " Only refresh on leaving insert mode
endif


" Aliases
" -------
fun! SetupCommandAlias(from, to)    " {{{1
    exec 'cnoreabbrev <expr> '.a:from
            \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
            \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun  " }}}
call SetupCommandAlias('W','w')
call SetupCommandAlias('Q','q')
call SetupCommandAlias('Qa','qa')
call SetupCommandAlias('H','History')
call SetupCommandAlias('Y','YankAll')
call SetupCommandAlias('colo','MyColorscheme')


" NERDTree File explorer
" ----------------------
let g:NERDTreeWinSize = 35
let g:NERDTreeShowHidden = 0
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left open {{{1
augroup NERDTree_au
au!
au bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup end " }}}
" Toggle
" nnoremap <silent> <C-e> :NERDTreeToggle<CR>



" Live substitution (syntax: :%s/from/to)
" -----------------
set inccommand=split
set gdefault        " reverse the work of the /g global switch

" MarkdownPreview
" ---------------
fun! MarkdownBrowserOtter(url)    " {{{1
    silent! execute '!otter-browser' shellescape('--new-window') string(a:url) | redraw!
endfun
fun! MarkdownBrowserQute(url)   " {{{1
    silent! execute '!qutebrowser' shellescape('--target') 'window' string(a:url) '&' | redraw!
endfun " }}}
let g:mkdp_browserfunc='MarkdownBrowserOtter'
let g:mkdp_auto_close = 0

" FZF
" ---
" This is the default extra key bindings
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }
if len(split($FZF_DEFAULT_OPTS,'hidden')) - len(split($FZF_DEFAULT_OPTS,'nohidden')) == 1
    let $FZF_DEFAULT_OPTS = join(split($FZF_DEFAULT_OPTS,'hidden'),'nohidden')
endif

if &lines < 15 | let g:fzf_layout = { 'down': '~40%' } | else | let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.8}} | endif
augroup AutoFZFLayout
    au!
    au VimResized * if &lines < 15 | let g:fzf_layout = { 'down': '~40%' } | else | let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.8}} | endif
augroup end


" Vim rooter
" ----------
" let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_silent_chdir = 1
let g:rooter_resolve_links = 1
let g:rooter_cd_cmd = 'lcd'  " change directory for the current window only

" lightline.vim
" -------------
let g:lightline.tab_component_function = {
            \ 'filename':       'lightline#tab#filename',
            \ 'modified':'custom#lightline#tab#modified',
            \ 'readonly':       'lightline#tab#readonly',
            \ 'tabnum'  :'custom#lightline#tab#tabnum'
            \}


" Show non-printable characters
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" set list


" Floating preview
" ----------------
set completeopt-=preview
let g:float_preview#docked = 1
let g:float_preview#max_width = 100

" Do not show -- MATCH X OF Y -- in completion
" ---------------------------------------------
" if has('patch-7.4.314')
    " set shortmess+=c
" endif


" NCM2
" ----
" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a newline.
        inoremap <silent><expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" enable ncm2 for all buffers
    augroup enable_ncm2
        au!
        autocmd BufEnter * if &l:ft =~ 'python\|vim'
                    \| call ncm2#enable_for_buffer()
                    \| endif
    augroup end
" IMPORTANT: :help Ncm2PopupOpen for more information
    set completeopt=noinsert,menuone,noselect
" Disable syntax hint after completion in python
    let g:ncm2_jedi#call_sig_hint = 0


" Gabrielana markdown
" -------------------
let g:markdown_enable_insert_mode_mappings = 0
let g:markdown_enable_spell_checking = 1
let g:markdown_enable_mappings = 1

" Indentline
" ----------
let g:indentLine_enabled = 0
let g:indentLine_char = '│'
" let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_setColors = 0

" vim-localsearch
" ---------------
" Toggle local search (leader is backlash \, the one beneath Backspace)
" i.e. press \ /
" nmap <leader>/ <Plug>localsearch_toggle
nmap <leader>' <Plug>localsearch_toggle
call localsearch#Enable() " Turn on by default
command! LocalSearch call localsearch#Toggle()


" ShowTrailingWhitespace
" ----------------------
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

" vim-doge
" --------
let g:doge_parsers=['python']
nmap <leader>d <Plug>(doge-generate)

" vim-lsp
" -------
let g:lsp_insert_text_enabled = 0
let g:lsp_text_edit_enabled = 0
let g:lsp_virtual_text_prefix = ''
let g:lsp_document_highlight_delay = 200
let g:lsp_fold_enabled = 0
fun! s:on_lsp_buffer_enabled() abort
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> <leader>r <plug>(lsp-rename)
    nmap <buffer> K <plug>(lsp-hover)
endfun
augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


" vim-sneak
" ---------
fun! SneakOmapOverride()
    for mapping in getcompletion('ounmap z','cmdline')
        execute('ounmap ' . mapping)
    endfor
    omap <silent> z <Plug>Sneak_s
endfun
augroup SneakOmapOverride
    au!
    au BufWinEnter * ++once call SneakOmapOverride()
augroup end

" quick-scope
" -----------
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_second_highlight = 0
hi clear QuickScopePrimary
hi QuickScopePrimary gui=reverse
aug QuickScope
    au!
    au ColorScheme * hi clear QuickScopePrimary
                \| hi QuickScopePrimary gui=reverse
aug END

" vim-gitgutter
" -------------
set updatetime=1000
let g:gitgutter_map_keys = 0
nmap <leader>gp <Plug>(GitGutterPreviewHunk)
nmap <leader>gd <Plug>(GitGutterPreviewHunk)
nmap <leader>ga <Plug>(GitGutterStageHunk)
nmap [g <Plug>(GitGutterPrevHunk)
nmap ]g <Plug>(GitGutterNextHunk)
let g:gitgutter_set_sign_backgrounds = 1

" nvim-ghost.nvim
" --------------
let g:nvim_ghost_disabled = 1
let g:nvim_ghost_logging_enabled = 1
aug nvim_ghost_user_autocommands
    au!
    au User www.reddit.com setl filetype=markdown
aug END

" visualstar.vim
" -------------
xmap <leader>* <Plug>(VisualstarSearchReplace)
nmap <leader>* <Plug>(VisualstarSearchReplace)

" ranger integration
" ------------------
if exists('$RANGER_LEVEL')
    nmap q <cmd>q<CR>
endif
