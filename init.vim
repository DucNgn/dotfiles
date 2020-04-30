set shell=/usr/local/bin/fish
let mapleader = " "
set updatetime=200

call plug#begin()
" THEMES, APPEARANCE --------------
Plug 'ryanoasis/vim-devicons'

" MOVEMENT ------------------------
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'

" SNIPPETS, CODE COMPLETE----------
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ycm-core/YouCompleteMe'

" LANGUAGE SUPPORT ----------------
Plug 'tpope/vim-dispatch'
Plug 'rust-lang/rust.vim'
Plug 'lervag/vimtex'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

" FORMATTING-----------------------
Plug 'terryma/vim-expand-region'
Plug 'junegunn/vim-easy-align'
Plug 'Yggdroot/indentLine'
Plug 'jiangmiao/auto-pairs'
Plug 'dense-analysis/ale'

" WRITING--------------------------
Plug 'junegunn/goyo.vim'

" MISC ----------------------------
Plug 'wakatime/vim-wakatime'
Plug 'itchyny/vim-gitbranch'

call plug#end()

"---CONFIG----

" Vim easy align-----------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Vim Expand region --------------------------------------------
map K <Plug>(expand_region_expand)
map J <Plug>(expand_region_shrink)

" Vim indentLine-----------------------------------------------
" Prevent hiding characters in md, json
let g:indentLine_setConceal = 0

" GOYO ---------------------------------------------------------
noremap <leader>g :Goyo <CR>

" fzf fuzzy file searching -------------------------------------
" set rtp+=/usr/local/opt/fzf
nmap <leader>ff :Files <CR>
nmap <leader>fc :Ag <CR>
nmap <leader>fs :Snippets <CR>

" File preview with Bat when using fzf
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" VIMTEX
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmg'
set conceallevel=1

" Compile latex file using xelatex and open preview with Skim
autocmd FileType tex nmap <buffer> <leader>lc :!xelatex %<CR>
autocmd FileType tex nmap <buffer> Lp :!open -a Skim %:r.pdf<CR><CR>

" Ale
let g:ale_sign_column_always = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\}
map <leader>af :ALEFix<CR>
nmap <silent> <leader>ap <Plug>(ale_previous_wrap)
nmap <silent> <leader>an <Plug>(ale_next_wrap)

" Markdown preview
nmap <leader>mp <Plug>MarkdownPreview

" UltiSnip
let g:UltiSnipsExpandTrigger="qq"

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/configuration/.ycm_extra_conf.py'

" Dispatch
nnoremap <leader>mc :Dispatch! make

" rustfmt
let g:rustfmt_autosave = 1

" Tagbar
nmap <leader>tt :TagbarToggle<CR>

"----------------------General Configuration -----------------
set visualbell
set wildmenu
set wildmode=full
set tabstop=2
set shiftwidth=4
set expandtab
set title
set confirm
set history=1000
set scrolloff=5

set cursorline

set wrap linebreak nolist
set breakindent
set breakindent showbreak=..

set ignorecase
set smartcase

" Statusline
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

function! FileNameWithIcon() abort
  return winwidth(0) > 70  ?  WebDevIconsGetFileTypeSymbol() . ' ' . expand('%:t') : ''
endfunction

set statusline=
set statusline+=%{StatuslineGit()}
set statusline+=\|\ 
set statusline+=%{FileNameWithIcon()}
set statusline+=\ %m
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

" No backup file
set noswapfile
set nobackup
set nowritebackup
set autoread

" hybrid line number
set number relativenumber
set nu rnu

" Spell Checker
nmap <F5> :set spell spelllang=en_ca <CR>
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Enable mouse
set mouse=a

"True colours
set background=dark
set termguicolors

" Saving
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" Quitting
noremap <leader>e :quit<CR>

" Disable Arrow Keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Tab Navigation
map <leader>tl :tabs<CR>
map <leader>tc :tabnew<CR>
map <leader>tx :tabc<CR>
map <leader>to :tabo<CR>
map <leader>tn :tabn<CR>
map <leader>tp :tabp<CR>
map <leader>tm :tabm

imap ,tl <Esc>:tabs<CR>
imap ,tc <Esc>:tabnew<CR>
imap ,tn <ESC>:tabn<CR>
imap ,tp <ESC>:tabp<CR>

" Window buffer
map <leader>wl :ls<CR>
map <leader>wd :bd<CR>
map <leader>ws :new<CR>
map <leader>wv :vne<CR>
map <leader>wz <C-w>z

" Terminal mode
map <F2> :term<CR>
map <F3> :new \| :terminal<CR>
map <F4> :vne \| :terminal<CR>
tnoremap <Esc> <C-\><C-n>

" Session management: <BS> backspace to delete the *.vim path of the result
let g:sessions_dir = '~/.vim-sessions'
exec 'nnoremap <leader>ss :mksession! ' . g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'
exec 'nnoremap <leader>sr :so ' . g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'

" Buffer navigation:
map <leader>bp :bprev<CR>
map <leader>bn :bnext<CR>
nnoremap <leader>wh <C-w>h
nnoremap <leader>wj <C-w>j
nnoremap <leader>wk <C-w>k
nnoremap <leader>wl <C-w>l

" Buffer resize
nnoremap <leader>= <C-w>=<CR>
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 5/3)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent> <Leader>] :exe "resize " . (winwidth(0) * 5/3)<CR>
nnoremap <silent> <Leader>[ :exe "resize " . (winwidth(0) * 2/3)<CR>

" Moving Code Blocks
vnoremap < <gv
vnoremap > >g

" Copy to system's clipboard
vnoremap <C-c> "*y

" Escaping insert mode
inoremap jk <esc>
inoremap kj <esc>

" Clear highlight
nnoremap <leader>c :noh<cr>

" Netrw settings
" Open in vertical split by default
nnoremap <leader>fn :Vex <CR> 
let g:netrw_banner = 0
let g:netrw_browse_split = 2
let g:netrw_liststyle = 3
let g:netrw_winsize = 20
"-------------------------------------
