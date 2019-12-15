" _ __   ___  _____   _(_)_ __ ___
"| '_ \ / _ \/ _ \ \ / / | '_ ` _ \
"| | | |  __/ (_) \ V /| | | | | | |
"|_| |_|\___|\___/ \_/ |_|_| |_| |_|

let mapleader = ","

call plug#begin()
" EASYMOTION VIM: quick navigate motions
Plug 'easymotion/vim-easymotion'

" GOYO: Distraction-free writing
Plug 'junegunn/goyo.vim'

" AUTOCLOSE: tags
Plug 'Townk/vim-autoclose'

" VimTex: For LaTex file
Plug 'lervag/vimtex'

" Vim-latex-Preview: 
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

" Markdown Preview 
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

" Waka time stats:
Plug 'wakatime/vim-wakatime'

" CodiVim: Add a side panel for Python real-time result:
Plug 'metakirby5/codi.vim'

" Activate Fuzzy finder
Plug '/usr/local/optfzf'
Plug 'junegunn/fzf.vim'

" Vim Indent display
Plug 'nathanaelkane/vim-indent-guides'

" COC
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"vim-vista
Plug 'liuchengxu/vista.vim'

" Rust-language support
Plug 'rust-lang/rust.vim'

" Vim-syntastic
Plug 'vim-syntastic/syntastic'

" Dependencies for snip-mate:
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'honza/vim-snippets'
Plug 'garbas/vim-snipmate'

" Split Term
Plug 'vimlab/split-term.vim'

"Floating terminal
Plug 'voldikss/vim-floaterm'

" Vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Night Sense
Plug 'nightsense/night-and-day'

" Vim color scheme switcher
Plug 'xolox/vim-colorscheme-switcher'

" Vim color schemes
Plug 'rafi/awesome-vim-colorschemes'
Plug 'arcticicestudio/nord-vim'

" NERD TREE:
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'Xuyuanp/nerdtree-git-plugin'

" Vim Devicons
Plug 'ryanoasis/vim-devicons'

" Vim Smoothie
Plug 'psliwka/vim-smoothie'


call plug#end()

"---CONFIG ----
"EASYMOTION VIM---
"move to line
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)
"move to word
map <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" GOYO ----------
nmap <leader>g :Goyo <CR>

" VIMTEX --------
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

" LaTex Preview---------
autocmd Filetype tex setl updatetime=1
let g:livepreview_previewer = 'open -a Preview'
nmap <F12> :LLPStartPreview<cr>

" INSTANT .MD----
nmap <leader>o <Plug>MarkdownPreviewToggle
let g:mkdp_port = '7070'

" CodiVim:--------------
nmap <F5> :Codi!!<CR>

" Vim indent display-------------------
let g:indent_guides_enable_on_vim_startup = 1

" COC-Auto Complete -------------------
set cmdheight=2
set updatetime=300
set signcolumn=yes
" Highlight symbol under cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" use <TAB> to trigger completion, and navigate
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" check <tab> mapping by ':verbose imap <tab>'

" Trigger completion if missed
inoremap <silent><expr> <c-space> coc#refresh()

" key-binding to definition
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Vim-Vista-------------
" Go to nearest method or function
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
nmap <leader>a :Vista!!<CR>
imap <C-A> :Vista!!<CR> 
let g:vista#renderer#enable_icon = 1
let g:vista_executive_for = {
	\'java': 'coc',
	\'javascript': 'coc',
	\'python': 'coc',
	\'latex': 'coc',
	\ }

" Syntastic-------------
let g:syntastic_enable_balloons = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_quiet_messages = {"regex": "36"}

" Snip-mate:
:imap ss <esc><Plug>snipMateNextOrTrigger
:smap ss <Plug>snipMateNextOrTrigger
:nmap <leader>0 :SnipMateOpenSnippetFiles<CR>

" Split Terminal --------
let g:split_term_default_shell = "fish"
nmap <Leader>1 :Term<CR>
nmap <Leader>2 :VTerm<CR>
nmap <Leader>3 :Term

" Floating Terminal -----
let g:floaterm_winblend = 20 
noremap  <silent> <F2>           :FloatermToggle<CR>i
noremap! <silent> <F2>           <Esc>:FloatermToggle<CR>i
tnoremap <silent> <F2>           <C-\><C-n>:FloatermToggle<CR>

" Vim-Airline------------
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" NightSense ------------
let g:nd_airline = 1
let g:nd_themes = [
   \ ['9:00',  'challenger_deep', 'dark', 'base16' ], 
   \ ['12:00', 'rakr', 'light', 'base16'],
   \ ['18:00', 'OceanicNext', 'dark', 'bubblegum'  ],
   \ ['22:00', 'gotham256', 'dark', 'monochrome']]

" NERD TREE -------------
map <F4> :NERDTreeToggle<CR>
" Close nerd tree is it is the last opening window.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERD TREE HIGHLIGHT-----
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" NERD GIT TAG-----------
set shell=sh "to work with fish shell"

" Devicons --------------
let g:webdevicons_conceal_nerdtree_brackets = 0
let g:WebDevIconsOS = 'darwin'

"----------------------General Configuration -----------------
" word wrapping
set wrap linebreak nolist

" No backup file
set noswapfile
set nobackup
set nowritebackup

" hybrid line number:
:set number relativenumber
:set nu rnu

" Spell Checker:
nmap <F6> :set spell spelllang=en_ca <CR>
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Enable mouse:
set mouse=a

"True colours:
:set termguicolors

" Quick Saving: Ctrl + S
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>


" Quick Quit Command:
noremap <Leader>e :quit<CR>

" Disable Arrow Key: 
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Binding For Tab Navigation:
map <C-S-Right> :tabn<CR>
map <C-S-Left> :tabp<CR>
map <C-S-t> :tabnew<CR>
map <C-S-d> :tab split<CR>
map <C-S-x> :tabc<CR>

map <C-S-l> :tabn<CR>
map <C-S-h> :tabp<CR>

" Moving Code Blocks:
vnoremap < <gv 
vnoremap > >g

" Copy to system's clipboard
vnoremap <C-c> "*y

" Escape mode faster
:imap ii <Esc>
