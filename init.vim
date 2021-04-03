let mapleader = " "

call plug#begin()
" Fuzzy file search
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Auto completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Syntax
Plug 'vim-syntastic/syntastic'

" TypeScript
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

" Latex
Plug 'lervag/vimtex'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" MISC
Plug 'co1ncidence/mountaineer.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'luochen1990/rainbow'
Plug 'ryanoasis/vim-devicons'
Plug 'wakatime/vim-wakatime'
Plug 'tpope/vim-fugitive'

call plug#end()

" Plugin config --------
" Fzf
nmap <leader>ff :Files <CR>
nmap <leader>fc :Ag <CR>
nmap <leader>fs :Snippets <CR>

" File preview with Bat when using fzf
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


" Deoplete 
let g:deoplete#enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" VIMTEX
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmg'
set conceallevel=1

" Compile latex file using xelatex and open preview with Skim
autocmd FileType tex nmap <buffer> <leader>lc :!xelatex %<CR>
autocmd FileType tex nmap <buffer> Lp :!open -a Skim %:r.pdf<CR><CR>

" Rainbow
let g:rainbow_active = 1 


"----------------------General Configuration -----------------
colorscheme mountaineer-grey

nmap cs :colorscheme

set visualbell
set wildmenu
set wildmode=full
set tabstop=4
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

function! FileNameWithIcon() abort
  return winwidth(0) > 70  ?  WebDevIconsGetFileTypeSymbol() . ' ' . expand('%:t') : ''
endfunction

set statusline=
set statusline+=%{FugitiveStatusline()}
set statusline+=\ \ 
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


