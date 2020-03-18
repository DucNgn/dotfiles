set shell=/usr/local/bin/fish 
let mapleader = " "
set updatetime=200

call plug#begin()
" THEMES, APPEARANCE --------------
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'

" MOVEMENT ------------------------
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" SNIPPETS, CODE COMPLETE----------
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ycm-core/YouCompleteMe'
Plug 'vim-syntastic/syntastic'

" LANGUAGE SUPPORT ----------------
Plug 'rust-lang/rust.vim'
Plug 'lervag/vimtex'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

" FORMATTING-----------------------
Plug 'terryma/vim-expand-region'
Plug 'junegunn/vi-easy-align'
Plug 'Yggdroot/indentLine'
Plug 'jiangmiao/auto-pairs'

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

" Markdown preview 
nmap <leader>mp <Plug>MarkdownPreview

" Syntastic
let g:syntastic_enable_balloons = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
" Let the size of error notice adjusts with content size
function! SyntasticCheckHook(errors)
    if !empty(a:errors)
        let g:syntastic_loc_list_height = min([len(a:errors), 10])
    endif
endfunction

" Vim Lightline 
set noshowmode  " No insert display mode "

function! FileNameWithIcon() abort
  return winwidth(0) > 70  ?  WebDevIconsGetFileTypeSymbol() . ' ' . expand('%:t') : '' 
endfunction

let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename_with_icon', 'modified' ] ],
      \   'right': [['lineinfo', 'percent']]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name',
      \   'filename_with_icon': 'FileNameWithIcon'	
      \ },
      \ }

" UltiSnip 
let g:UltiSnipsExpandTrigger="qq"

" YouCompleteMe 
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/configuration/.ycm_extra_conf.py'

" rustfmt
let g:rustfmt_autosave = 1

" NERD TREE 
map <leader>fn :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERD TREE HIGHLIGHT
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" Devicons 
let g:webdevicons_conceal_nerdtree_brackets = 0

" Tagbar 
nmap <leader>tt :TagbarToggle<CR>

"----------------------General Configuration -----------------
colorscheme murphy
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
