" _ __   ___  _____   _(_)_ __ ___
"| '_ \ / _ \/ _ \ \ / / | '_ ` _ \
"| | | |  __/ (_) \ V /| | | | | | |
"|_| |_|\___|\___/ \_/ |_|_| |_| |_|
"
set shell=/usr/local/bin/fish 
let mapleader = ","
set updatetime=200

call plug#begin()
" THEMES, APPEARANCE --------------
Plug 'ryanoasis/vim-devicons'

Plug 'psliwka/vim-smoothie'

Plug 'itchyny/lightline.vim'

" MOVEMENT ------------------------
Plug 'easymotion/vim-easymotion'

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'majutsushi/tagbar'

Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" SNIPPETS, CODE COMPLETE----------

Plug 'SirVer/ultisnips'

Plug 'honza/vim-snippets'

Plug 'ycm-core/YouCompleteMe'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugin' } 

Plug 'ervandew/supertab'

Plug 'vim-syntastic/syntastic'

" FORMATTING-----------------------
Plug 'terryma/vim-expand-region'

Plug 'junegunn/vim-easy-align'

Plug 'Yggdroot/indentLine'

Plug 'jiangmiao/auto-pairs'

" WRITING--------------------------

Plug 'junegunn/goyo.vim'

Plug 'lervag/vimtex'

Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

Plug 'vimwiki/vimwiki'

" MISC ----------------------------
Plug 'wakatime/vim-wakatime'

Plug 'vimlab/split-term.vim'

Plug 'voldikss/vim-floaterm'

Plug 'airblade/vim-gitgutter'

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

"EASYMOTION VIM------------------------------------------------
"move to line
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)
"move to word
map <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" GOYO ---------------------------------------------------------
noremap <leader>g :Goyo <CR>

" fzf fuzzy file searching -------------------------------------
nmap <C-g> :Files <CR>
nmap <leader>a :Ag <CR>
nmap <leader>snip :Snippets <CR>

" File preview with Bat when using fzf 
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" VIMTEX 
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmg'

" LaTex Preview
autocmd Filetype tex setl updatetime=1
let g:livepreview_previewer = 'open -a Preview'
nmap <F12> :LLPStartPreview<cr>

" Markdown preview 
nmap <C-p> <Plug>MarkdownPreview

" Deoplete
let g:deoplete#enable_at_startup = 1

" Syntastic
let g:syntastic_enable_balloons = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Split Terminal 
let g:split_term_default_shell = "fish"
nmap <F2> :Term<CR>
nmap <F3> :VTerm<CR>

" Floating Terminal 
let g:floaterm_winblend = 10
let g:floaterm_position = 'center'
let g:floaterm_keymap_toggle = '<F4>'

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

" NERD TREE 
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERD TREE HIGHLIGHT
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" Devicons 
let g:webdevicons_conceal_nerdtree_brackets = 0

" Tagbar 
nmap <leader>t :TagbarToggle<CR>

"----------------------General Configuration -----------------
" word wrapping
set wrap linebreak nolist

" Breakindent
set breakindent
set breakindent showbreak=..

" case-insensitive when searching in file
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
nmap <F6> :set spell spelllang=en_ca <CR>
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Enable mouse
set mouse=a

"True colours
set termguicolors

" Quick Saving
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" Quick Quit Command
noremap <Leader>e :quit<CR>

" Disable Arrow Key
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Binding For Tab Navigation
map <C-t> :tabnew<CR>
map <C-d> :tab split<CR>
map <C-x> :tabc<CR>
map <C-S-l> :tabn<CR>
map <C-S-h> :tabp<CR>

" Moving Code Blocks
vnoremap < <gv 
vnoremap > >g

" Copy to system's clipboard
vnoremap <C-c> "*y

" Escaping insert mode faster
inoremap jk <esc>
inoremap kj <esc>

" Map <Space> to / (search) and <Ctrl>+<Space> to ? (backwards search):
map <space> /
map <C-space> ?
map <silent> <leader><cr> :noh<cr>

" Clear highlighting after searching
nnoremap <esc> :noh<return><esc>
"-------------------------"
