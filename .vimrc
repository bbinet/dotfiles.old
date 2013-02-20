" Pathogen {{{
filetype off
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
" calling helptags slow down vim opening
"call pathogen#helptags()
filetype plugin indent on
" }}}

" Globals {{{
set nocompatible
set modelines=0
set autoread
" make mouse to work with gnu screen
set ttymouse=xterm2
set ttyfast
set viminfo=/10,'10,r/mnt/zip,r/mnt/floppy,f0,h,\"100
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,.git,.svn,*.pyc
set hidden
set switchbuf=useopen
" }}}

" Tab/spaces {{{
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
" }}}

" Backups {{{
if v:version >= 703
    set undofile
    set undodir=~/.tmp/vim/undodir//,/tmp//
else
    let g:gundo_disable = 1
endif
set backupdir=~/.tmp/vim/backupdir//,/tmp//
set directory=~/.tmp/vim/directory//,/tmp//
set history=500
set undolevels=500
" }}}

" User Interface {{{
set guioptions-=T
set guioptions-=r
syntax on
set bg=dark
if exists('+relativenumber')
    set relativenumber
else
    set number
endif
if exists('+cc')
    set cc=80
endif
set listchars=tab:▸\ ,eol:¬,trail:·
set shortmess+=r
set showmode
set showcmd
set showmatch
set t_Co=256
colorscheme molokai
hi ColorColumn ctermbg=234
if has('gui_running')
    set guifont=Menlo:h12
    set go-=m
endif
set ruler
set backspace=indent,eol,start
set laststatus=2
set encoding=utf-8 " Necessary to show unicode glyphs
let g:Powerline_symbols = 'fancy' " 'fancy' needs special patched fonts
" }}}
"
" Tabline {{{
" name tabs to show tab# and # of viewports
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= (i == t ? '%#TabSepSel#' : '%#TabSep#')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= (i == t ? '%#TabNumSel#' : '%#TabNum#')
            let s .= i
            if tabpagewinnr(i,'$') > 1
                let s .= '.'
                let s .= (i == t ? '%#TabWinNumSel#' : '%#TabWinNum#')
                let s .= (tabpagewinnr(i,'$') > 1 ? wn : '')
            end

            let s .= ' %*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= file
            let s .= (i == t ? '%#TabSepSel#' : '%#TabSep#')
            let s .= (i == t ? '%m' : '')
            let i = i + 1
            let s .= ' '
        endwhile
        let s .= '%T%#TabLineFill#%='
        return s
    endfunction
    set tabline=%!MyTabLine()
endif
set tabpagemax=15
" }}}

" Movements {{{
" Use the damn hjkl keys, never use the arrow keys ! Never ever !
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" EasyMotion
let g:EasyMotion_leader_key = '<space>'
" }}}

" VimDiff {{{
" change color scheme when calling vimdiff inside vim
" comment out this part since it causes colorscheme issue when closing a buffer
"au FilterWritePost * if &diff | set t_Co=256 | set bg=dark | colorscheme slate | else | colorscheme molokai | endif
"au BufWinLeave * colorscheme molokai
" }}}

" Leader {{{
let mapleader=','
" }}}

" Search {{{
set incsearch
set hlsearch
"set nowrap
set shiftround
set autoindent
set ignorecase
set smartcase
set gdefault
" }}}

" Text {{{
set formatoptions-=t
set textwidth=79
" }}}

" Scroll {{{
set scrolloff=3
" }}}

" Fn keys mapping {{{
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O><F2>
set pastetoggle=<F2>
function! ToggleNumberSignCol()
    if exists('+relativenumber')
        set relativenumber!
    else
        set number!
    endif
    QuickfixsignsToggle
endfunction
nnoremap <F3> :call ToggleNumberSignCol()<CR>
nnoremap <silent> <F4> :YRShow<cr>
inoremap <silent> <F4> <ESC>:YRShow<cr>
nnoremap <F5> :GundoToggle<CR>
" }}}

" Yankring {{{
let g:yankring_max_history = 10
let g:yankring_max_element_length = 512000
let g:yankring_history_file = '.vim_yankring_history'
let g:yankring_clipboard_monitor = 0
let g:yankring_manual_clipboard_check = 0
function! YRRunAfterMaps()
    " fix 'nnoremap Y y$<CR>' remapping
    nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction
" }}}

" Tagbar {{{
nmap <F8> :TagbarToggle<CR>
let g:tagbar_foldlevel = 1
let g:tagbar_left = 1
" }}}

" Quickfixsigns {{{
" define own signs
function! s:define_highlights()
    highlight qfs_vcs_add ctermfg=2 ctermbg=NONE cterm=bold
    highlight qfs_vcs_change ctermfg=3 ctermbg=NONE cterm=bold
    highlight qfs_vcs_del ctermfg=1 ctermbg=NONE cterm=bold
    highlight qfs_qfl ctermfg=LightGray ctermbg=NONE
endfunction

function! s:define_signs()
    sign define QFS_VCS_ADD text=+ texthl=qfs_vcs_add
    sign define QFS_VCS_CHANGE text=~ texthl=qfs_vcs_change
    sign define QFS_VCS_DEL text=_ texthl=qfs_vcs_del
    sign define QFS_QFL text=* texthl=qfs_qfl
endfunction

call s:define_highlights()
call s:define_signs()

let g:quickfixsigns_blacklist_buffer = '^\(__.*__\|ControlP\|.*YankRing.*\|\|index\|NERD_tree_.*\|-MiniBufExplorer-\)$'
" }}} 

" Syntastic {{{
" disable signs
let g:syntastic_enable_signs=0
" }}} 

" Insert <Tab> or complete identifier {{{
" if the cursor is after a keyword character
function! MyTabOrComplete()
    let col = col('.')-1
    if !col || getline('.')[col-1] !~ '\k'
         return "\<tab>"
    else
         return "\<C-N>"
    endif
endfunction
inoremap <Tab> <C-R>=MyTabOrComplete()<CR>
" }}}

" Autocommands {{{
" Jumps to the last known position in a file , if the '"' mark is set:
:au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Python {{{
aug python
    au Filetype python inoremap <silent> <buffer> <F7> import pdb; pdb.set_trace()
    au Filetype python noremap <silent> <buffer> <F7> Oimport pdb; pdb.set_trace()<ESC>j
    au FileType python setlocal omnifunc=pythoncomplete#Complete
aug end
" }}}

" Cursorline {{{
aug cursorline
    " Highlight the current line in the current window.
    au!
    au BufEnter * set cursorline
    au BufLeave * set nocursorline
    au InsertEnter * set nocursorline
    au InsertLeave * set cursorline
aug end
" }}}

" QuickFix {{{
" Add a 'Qargdo' command
" cf. http://stackoverflow.com/questions/5686206/search-replace-using-quickfix-list-in-vim
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction
command! -nargs=1 -complete=command -bang Qargdo exe 'args '.QuickfixFilenames() | argdo<bang> <args>

" Add QGgrep command to display the result of Ggrep directly in the quickfix
command! -nargs=1 -complete=command QGgrep silent exe 'Ggrep! <args>' | redraw! | cope
" git-grep word under cursor
noremap <leader>* "cyiw:QGgrep "\<<c-r>c\>"<CR>
" open the quickfix
noremap <leader>q :cope<CR>
" close the quickfix
noremap <leader>Q :cclose<CR>

" Filter Quickfix list
function! FilterQFList(type, action, pattern)
    if a:pattern == ''
        return ''
    endif
    let s:curList = getqflist()
    let s:newList = []
    for item in s:curList
        if a:type == 'f'     " filter on file names
            let s:cmpPat = bufname(item.bufnr)
        elseif a:type == 'p' " filter on line content (pattern)
            let s:cmpPat = item.text . item.pattern
        endif
        if item.valid
            if a:action == '-'
                " Delete matching lines
                if s:cmpPat !~ a:pattern
                    let s:newList += [item]
                endif
            elseif a:action == '+'
                " Keep matching lines
                if s:cmpPat =~ a:pattern
                    let s:newList += [item]
                endif
            endif
        endif
    endfor
    " Assing as new quickfix list
    call setqflist(s:newList)
endfunction

aug ft_quickfix
    au!
    au Filetype qf setlocal colorcolumn=0 nolist nocursorline nowrap
    " q         to close the quickfix window
    " o         to open (same as enter)
    " go        to preview file (open but maintain focus on ack.vim results)
    " x or s    to open in horizontal split
    " gx or gs  to open in horizontal split silently
    " v         to open in vertical split
    " gv        to open in vertical split silently
    " t         to open in new tab
    " T         to open in new tab silently
    au Filetype qf nnoremap <silent> <buffer> q :cclose<CR>
    au Filetype qf nnoremap <silent> <buffer> o <CR>
    au Filetype qf nnoremap <silent> <buffer> O <CR>:cclose<CR>
    au Filetype qf nnoremap <silent> <buffer> go <CR>:cope<CR>
    au Filetype qf nnoremap <silent> <buffer> x <CR>:sp#<CR><C-W><C-W>
    au Filetype qf nnoremap <silent> <buffer> X <CR>:sp#<CR><C-W><C-W>:cclose<CR>
    au Filetype qf nnoremap <silent> <buffer> gx <CR>:sp#<CR>:cope<CR>
    au Filetype qf nnoremap <silent> <buffer> s <CR>:sp#<CR><C-W><C-W>
    au Filetype qf nnoremap <silent> <buffer> S <CR>:sp#<CR><C-W><C-W>:cclose<CR>
    au Filetype qf nnoremap <silent> <buffer> gs <CR>:sp#<CR>:cope<CR>
    au Filetype qf nnoremap <silent> <buffer> v <CR>:vs#<CR><C-W><C-W>
    au Filetype qf nnoremap <silent> <buffer> V <CR>:vs#<CR><C-W><C-W>:cclose<CR>
    au Filetype qf nnoremap <silent> <buffer> gv <CR>:vs#<CR>:cope<CR>
    au Filetype qf nnoremap <silent> <buffer> t <C-W><CR><C-W>T
    au Filetype qf nnoremap <silent> <buffer> T <C-W><CR><C-W>TgT<C-W><C-W>
    " and some shortcuts to filter out qfix lines:
    " f and F will filter on file names, c and C on line contents
    " (capitalized versions have a :v effect (keep lines not matching), normal
    " versions keep lines matching your pattern)
    au Filetype qf nnoremap <silent> <buffer> F :call FilterQFList('f', '-', inputdialog('Delete from quickfix files matching: ', ''))<CR>
    au Filetype qf nnoremap <silent> <buffer> f :call FilterQFList('f', '+', inputdialog('Keep only quickfix files matching: ', ''))<CR>
    au Filetype qf nnoremap <silent> <buffer> C :call FilterQFList('p', '-', inputdialog('Delete from quickfix content matching: ', ''))<CR>
    au Filetype qf nnoremap <silent> <buffer> c :call FilterQFList('p', '+', inputdialog('Keep only quickfix content matching: ', ''))<CR>
    " Open the quickfix window automatically after a grep command
    au QuickFixCmdPost *grep* cwindow
aug end
" }}}

" Special filetype conf {{{
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
au FileType coffee setlocal ts=2 sts=2 sw=2 expandtab
au FileType html setlocal textwidth=0
au BufNewFile,BufRead *.less setf less
au BufNewFile,BufRead *.map setf map
au BufNewFile,BufRead *.tmux.conf setf tmux
au BufNewFile,BufRead *.pp setf puppet
au BufNewFile,BufRead *.penta setf pentadactyl
au BufNewFile,BufRead .pentadactylrc setf pentadactyl
" }}}

" Execute function preserving state {{{
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
" }}}

" Utilities {{{

" Reload molokai colorscheme
map <leader>c :colorscheme molokai<cr>

" Disable highlight
map <leader><space> :noh<cr>

" Hidden chars
nmap <leader>l :set list!<CR>

" remap Y to follow same principle as C, D
" this used to fail due to YankRing plugin: see fix in YankRing config above
nnoremap Y y$

" Remove trailing spaces
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>

" Indent whole file
nmap _= :call Preserve("normal gg=G")<CR>
nmap _t :call Preserve("%!tidy -i -xml -q")<CR>
" Split/Join block
nmap _j :SplitjoinJoin<CR>
nmap _s :SplitjoinSplit<CR>

" Order CSS properties
nnoremap <leader>S ?{<CR>jV/}$<CR>k:sort<CR>:noh<CR>

" Quicker window switching
nnoremap <leader>, <c-w><c-w>

" ack-grep word under cursor
let g:ackprg="ack-standalone -H --nocolor --nogroup --column --ignore-dir=buildout --ignore-dir=build"
noremap <leader>a "cyiw:Ack <c-r>c<CR>

" Select previous selection
nnoremap <expr> gV '`[' . getregtype()[0] . '`]'

" Sudo save
cmap w!! w !sudo tee % >/dev/null

" From tab to vsplit
nnoremap <c-w>V mAZZ<c-w>v`A

" Gstatus shortcut
noremap <leader>g :Gstatus<cr>

" }}}

" Bubbling {{{
" Bubble single lines
nmap <C-k> [e
nmap <C-j> ]e
" Bubble multiple lines
vmap <C-k> [egv
vmap <C-j> ]egv
" Git/svn blame of selection
vmap sb :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>
vmap gb :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>
" }}}

" Fast file opening {{{
map <leader>p :CtrlP<CR>
map <leader>P :CtrlPBuffer<CR>
map <leader>e :CtrlPCurFile<CR>
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files && git ls-files -o --exclude-standard', 'find %s -type f']
let g:ctrlp_mruf_exclude = '/tmp/.*\|.*\.git/.*'
" Note: In some terminals, it’s not possible to remap <c-h> without also
" changing <bs> (|key-codes|). So if pressing <bs> moves the cursor to the left
" instead of deleting a char for you, add this to your |vimrc| to change the
" default <c-h> mapping:
let g:ctrlp_prompt_mappings = {
    \ 'PrtBS()': ['<bs>', '<c-]>', '<c-h>'],
    \ 'PrtCurLeft()': ['<left>', '<c-^>'],
    \ }
" }}}

" Folding {{{

" Folding methods {{{
" set default foldmethod to 'manual': zf to create a new fold
set foldmethod=manual
au FileType vim setlocal foldmethod=marker
au FileType python setlocal foldmethod=indent
au FileType css setlocal foldmethod=marker
au FileType css setlocal foldmarker={,}
au FileType javascript setlocal foldmethod=marker
au FileType javascript setlocal foldmarker={,}
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax
au FileType html setlocal foldmethod=syntax
" }}}

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}

set foldtext=MyFoldText()
set foldlevel=20
" }}}

" Abbreviations {{{
" Typos
ab calss class
ab hig highlight
" }}}
