" _ __   ___  _____   _(_) __ ___
"| '_ \ / _ \/ _ \ \ / / | '_ ` _ \
"| | | |  __/ (_) \ V /| | | | | | |
"|_| |_|\___|\___/ \_/ |_|_| |_| |_|
"
set shell=/usr/local/bin/fish 
let mapleader = ","
set updatetime=100

call plug#begin()
" vim-startify: fancy start screen 
Plug 'mhinz/vim-startify'

" Vim-expand-region
Plug 'terryma/vim-expand-region'

" Vim align easy
Plug 'junegunn/vim-easy-align'

" Vim indent line
Plug 'Yggdroot/indentLine'

" EASYMOTION VIM: quick navigate motions
Plug 'easymotion/vim-easymotion'

" GOYO: Distraction-free writing
Plug 'junegunn/goyo.vim'

" VimTex: For LaTex file
Plug 'lervag/vimtex'

" Vim-latex-Preview: 
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

" Waka time
Plug 'wakatime/vim-wakatime'

" Fuzzy finder
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" MRU: Most recent use file
Plug 'yegappan/mru'

" UltiSnip to trigger snippets
Plug 'SirVer/ultisnips'

" Snippet library
Plug 'honza/vim-snippets'

" YouCompleteMe: Code completion engine
Plug 'ycm-core/YouCompleteMe'

" Deoplete: Auto completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } 

" Use Tab for auto completion
Plug 'ervandew/supertab'

" Vim-wiki for note-taking
Plug 'vimwiki/vimwiki'

" Vim-syntastic
Plug 'vim-syntastic/syntastic'

" Split Term
Plug 'vimlab/split-term.vim'

"Floating terminal
Plug 'voldikss/vim-floaterm'

" Vim-fugitive for git
Plug 'tpope/vim-fugitive'

" Night Sense
Plug 'nightsense/night-and-day'

" Vim color scheme switcher
Plug 'xolox/vim-colorscheme-switcher'

" Vim color schemes
Plug 'rafi/awesome-vim-colorschemes'

" Candid color scheme
Plug 'flrnd/candid.vim'

" Vim Lightline
Plug 'itchyny/lightline.vim'

" Git branch name displat
Plug 'itchyny/vim-gitbranch'

" NERD TREE:
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Vim Devicons
Plug 'ryanoasis/vim-devicons'

" Vim Smoothie
Plug 'psliwka/vim-smoothie'

call plug#end()

"---CONFIG ----
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

" MRU Most recent use files-------------------------------------
map <leader>re :MRU<CR>

" GOYO ---------------------------------------------------------
noremap <leader>g :Goyo <CR>

" fzf fuzzy file searching -------------------------------------
nmap <leader>f :Files <CR>
nmap <leader>a :Ag <CR>
nmap <leader>snip :Snippets <CR>

" File preview with Bat
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" VIMTEX -------------------------------------------------------
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmg'

" LaTex Preview-------------------------------------------------
autocmd Filetype tex setl updatetime=1
let g:livepreview_previewer = 'open -a Preview'
nmap <F12> :LLPStartPreview<cr>

" Markdown preview ---------------------------------------------
nmap <C-p> <Plug>MarkdownPreview

" Deoplete -----------------------------------------------------
let g:deoplete#enable_at_startup = 1

" Syntastic-----------------------------------------------------
let g:syntastic_enable_balloons = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Split Terminal ------------------------------------------------
let g:split_term_default_shell = "fish"
nmap <Leader>1 :Term<CR>
nmap <Leader>2 :VTerm<CR>

" Floating Terminal ---------------------------------------------
let g:floaterm_winblend = 10
let g:floaterm_position = 'center'
let g:floaterm_keymap_toggle = '<leader>4'

" NightSense ----------------------------------------------------
let g:nd_themes = [
   \ ['9:00',  'lucius', 'dark'], 
   \ ['12:00', 'hybrid', 'dark'], 
   \ ['18:00', 'OceanicNext', 'dark'],
   \ ['22:00', 'gotham256', 'dark']]
" Suggested colorscheme: lucius-dark, gotham256-dark 

" Vim Lightline --------------------------------------------------
set noshowmode  " No insert display mode "
" Suggested color: seoul256
let g:lightline = {
      \ 'colorscheme': 'candid',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

" UltiSnip --------------------------------------------------------
let g:UltiSnipsExpandTrigger="qq"

" YouCompleteMe ---------------------------------------------------
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/configuration/.ycm_extra_conf.py'

" NERD TREE -------------------------------------------------------
map <C-n> :NERDTreeToggle<CR>
" Close nerd tree is it is the last opening window.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERD TREE HIGHLIGHT----------------------------------------------
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" Devicons ---------------------------------------------------------
let g:webdevicons_conceal_nerdtree_brackets = 0

"----------------------General Configuration -----------------
" word wrapping
set wrap linebreak nolist

" case-insensitive when searching in file
set ignorecase

" No backup file
set noswapfile
set nobackup
set nowritebackup

" Auto reload
set autoread

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
map <C-t> :tabnew<CR>
map <C-d> :tab split<CR>
map <C-x> :tabc<CR>
map <C-S-l> :tabn<CR>
map <C-S-h> :tabp<CR>

" Moving Code Blocks:
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
