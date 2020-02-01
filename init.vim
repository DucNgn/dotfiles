" _ __   ___  _____   _(_)_ __ ___
"| '_ \ / _ \/ _ \ \ / / | '_ ` _ \
"| | | |  __/ (_) \ V /| | | | | | |
"|_| |_|\___|\___/ \_/ |_|_| |_| |_|
"
set shell=/usr/local/bin/fish 
let mapleader = ","
set updatetime=400

call plug#begin()
" Vim align easy
Plug 'junegunn/vim-easy-align'

" Vim indent line
Plug 'Yggdroot/indentLine'

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
Plug 'wakatim/vim-wakatime'

" Fuzzy finder
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

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

" Vim-gitgutter: Display Git changes in file
Plug 'airblade/vim-gitgutter'

" Night Sense
Plug 'nightsense/night-and-day'

" Vim color scheme switcher
Plug 'xolox/vim-colorscheme-switcher'

" Vim color schemes
Plug 'rafi/awesome-vim-colorschemes'

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
" Vim easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

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
   \ ['12:00', 'gruvbox','dark'], 
   \ ['18:00', 'OceanicNext', 'dark'],
   \ ['22:00', 'gotham256', 'dark']]

" Vim Lightline ---------
set noshowmode  " No insert display mode "
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

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
:imap <C-]> <Esc>

" Run Java program without quitting vim
" F9/F10 compile/run default file.
" F11/F12 compile/run alternate file. <if driver is in the other file>
map <F9> :set makeprg=javac\ %<CR>:make<CR>
map <F10> :!echo %\|awk -F. '{print $1}'\|xargs java<CR>
map <F11> :set makeprg=javac\ #<CR>:make<CR>
map <F12> :!echo #\|awk -F. '{print $1}'\|xargs java<CR>

map! <F9> <Esc>:set makeprg=javac\ %<CR>:make<CR>
map! <F10> <Esc>:!echo %\|awk -F. '{print $1}'\|xargs java<CR>
map! <F11> <Esc>set makeprg=javac\ #<CR>:make<CR>
map! <F12> <Esc>!echo #\|awk -F. '{print $1}'\|xargs java<CR>

set makeprg=javac\ %
set errorformat=%A:%f:%l:\ %m,%-Z%p^,%-C%.%#

" If two files are loaded, switch to the alternate file, then back.
if argc() == 2
  n
  e #
endif
"-------------------------"
