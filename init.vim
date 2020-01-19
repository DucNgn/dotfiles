" _ __   ___  _____   _(_)_ __ ___
"| '_ \ / _ \/ _ \ \ / / | '_ ` _ \
"| | | |  __/ (_) \ V /| | | | | | |
"|_| |_|\___|\___/ \_/ |_|_| |_| |_|
"

set shell=/usr/local/bin/fish 
let mapleader = ","
set updatetime=300

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

" Fuzzy finder
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" YouCompleeMe: Code completion engine
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

" Vim-gitgutter: Display Git changes in file
Plug 'airblade/vim-gitgutter'

" Night Sense
Plug 'nightsense/night-and-day'

" Vim color scheme switcher
Plug 'xolox/vim-colorscheme-switcher'

" Vim color schemes
Plug 'rafi/awesome-vim-colorschemes'

" NERD TREE:
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

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
nmap <C-p> <Plug>MarkdownPreviewToggle
let g:mkdp_port = '7070'

" Deoplete
" Use deoplete.
let g:deoplete#enable_at_startup = 1

" Syntastic-------------
let g:syntastic_enable_balloons = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_quiet_messages = {"regex": "36"}

" Split Terminal --------
let g:split_term_default_shell = "fish"
nmap <Leader>1 :Term<CR>
nmap <Leader>2 :VTerm<CR>
nmap <Leader>3 :Term

" Floating Terminal -----
let g:floaterm_winblend = 10
let g:floaterm_position = 'center'
let g:floaterm_keymap_toggle = '<leader>4'

" NightSense ------------
let g:nd_themes = [
   \ ['9:00',  'lucius', 'dark'], 
   \ ['12:00', 'rakr', 'dark'],
   \ ['18:00', 'OceanicNext', 'dark'],
   \ ['22:00', 'gotham256', 'dark']]

" NERD TREE -------------
map <C-n> :NERDTreeToggle<CR>
" Close nerd tree is it is the last opening window.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERD TREE HIGHLIGHT-----
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

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

" Escaping insert mode faster
:imap ii <Esc>
