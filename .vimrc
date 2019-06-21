call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex'
Plug 'ervandew/supertab'
Plug 'Valloric/YouCompleteMe'
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'tpope/vim-surround'
" Initialize plugin system
call plug#end()


let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsSnippetDirectories = ['/home/tim/.vim/ultisnips', '/home/tim/.vim/plugged/vim-snippets/UltiSnips']

map <C-n> :NERDTreeToggle<CR>
let NERDTreeMapOpenInTab='<tab>'

let g:surround_{char2nr('c')} = "\\\1command\1{\r}"

set number
set incsearch
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>
let g:tex_flavor = "latex"

let mapleader=' '
map <leader>s :!aspell --mode tex -c %<CR>

set laststatus=2
