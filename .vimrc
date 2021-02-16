"scheme
set ft=nasm
colorscheme slate
syntax on
filetype indent on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set cursorline
set number
set relativenumber
cal matchadd('ColorColumn', '\%81v', 100)
set listchars=tab:\|\ ,trail:_ list
set wildmenu
set autoindent
set smartindent
set cindent
let c_no_curly_error=1
set showmatch
set matchpairs+=<:>
set hlsearch
set ignorecase
set smartcase
set incsearch
set t_Co=256 " makes Vim use 256 colors


"remaps
inoremap kj <ESC>
noremap <F9> :<C-u>!./%:r.out<CR>
inoremap {<CR> {<CR>}<ESC>O
noremap <F5> :w!<CR>:<C-u>!g++ -g -Wall -Wextra -pedantic -Wno-unused-result
\ -DLOCAL -std=c++17 -O2 -Wshadow -Wformat=2 -Wfloat-equal -Wcast-qual
\ -Wcast-align -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -fsanitize=address
\ -fsanitize=undefined -fno-sanitize-recover=all -fstack-protector
\ %:r.cpp -o %:r.out<CR>

" auto comment and uncooment with F6 and F7 key
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
noremap <silent> #6 :<C-B>silent<C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR> " commenting line with F6
noremap <silent> #7 :<C-B>silent<C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR> "uncommenting line with F7
noremap <silent> #3 :tabprevious<CR> " switch to previous tab with F3
noremap <silent> #4 :tabnext<CR> " switch to next tab with F2
map <F8> :setlocal spell! spelllang=en_us<CR> " check spelling with F8

"function to remove trailing white space from a line on save ( :w )
func! DeleteTrailingWS()
silent! execute '%s/\s\+$//ge'
endfunc
autocmd BufWrite *.cpp :call DeleteTrailingWS()
