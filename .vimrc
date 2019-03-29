call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex'
Plug 'ervandew/supertab'
Plug 'Valloric/YouCompleteMe'
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree'

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

set number
