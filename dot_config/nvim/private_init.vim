" Download vim-plug if not install
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'jreybert/vimagit'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'morhetz/gruvbox'
Plug 'ap/vim-css-color'
call plug#end()


" True color
if (has("termguicolors"))
    set termguicolors
endif

" Passing xterm because that's what's used in FreeBSD's console
if $TERM =~ '^\(rxvt\|screen\|xterm\|putty\)\(-.*\)\?$'
    set notermguicolors
endif

" Colorscheme
autocmd vimenter * ++nested colorscheme gruvbox


set title
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd

" disable annoying swap
set noswapfile

" hightlight current line
set cursorline

" scrolloff set a margin for scrolling
set scrolloff=5
" highlight line after yanking
autocmd TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false}

" <leader> key
let mapleader = " " " map leader to Space

" Indentation
set expandtab tabstop=4 shiftwidth=4 softtabstop=4

" Some basics:
    nnoremap c "_c
    set nocompatible
    filetype plugin on
    syntax on
    set encoding=utf-8
    set number relativenumber
    " use a dark theme
    set background=dark


" Enable autocompletion:
    set wildmode=longest,list,full
" Disables automatic commenting on newline:
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
    vnoremap . :normal .<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
    map <leader>o :setlocal spell! spelllang=en_us<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
    set splitbelow splitright

" Exit insert mode via jk
    inoremap jk <Esc>

" Keybindings to work like evil in emacs
" Edit neovim config
    nnoremap <leader>fp :e ~/.config/nvim/init.vim<CR>
" Save a file
    nnoremap <leader>fs :w<CR>
" Window operations
    nnoremap <leader>wh <C-w>h
    nnoremap <leader>wl <C-w>l
    nnoremap <leader>wj <C-w>j
    nnoremap <leader>wk <C-w>k

    nnoremap <leader>wH <C-w>H
    nnoremap <leader>wL <C-w>L
    nnoremap <leader>wJ <C-w>J
    nnoremap <leader>wK <C-w>K

    nnoremap <leader>wv <C-w>v
    nnoremap <leader>ws <C-w>s

    nnoremap <leader>w< <C-w><
    nnoremap <leader>w> <C-w>>

    nnoremap <leader>wc <C-w>c
" Refresh a file
    nnoremap <leader>br :e %<CR>
" Tabs
    nnoremap <C-t> :tabnew<CR>
    nnoremap <A-1> :tabn 1<CR>
    nnoremap <A-2> :tabn 2<CR>
    nnoremap <A-3> :tabn 3<CR>
    nnoremap <A-4> :tabn 4<CR>
    nnoremap <A-5> :tabn 5<CR>
    nnoremap <A-6> :tabn 6<CR>
    nnoremap <A-7> :tabn 7<CR>
    nnoremap <A-8> :tabn 8<CR>
    nnoremap <A-9> :tabn 9<CR>

" Alt+hjkl in insert mode
    inoremap <A-h> <left>
    inoremap <A-j> <down>
    inoremap <A-k> <up>
    inoremap <A-l> <right>
" Readline
    inoremap <C-f> <right>
    inoremap <C-b> <left>
    inoremap <C-a> <Home>
    inoremap <C-e> <End>
    inoremap <A-b> <C-Left>
    inoremap <A-f> <C-Right>
    inoremap <C-BS> <C-W>
    cnoremap <C-f> <right>
    cnoremap <C-b> <left>
    cnoremap <C-a> <Home>
    cnoremap <C-e> <End>
    cnoremap <A-b> <C-Left>
    cnoremap <A-f> <C-Right>
    cnoremap <C-BS> <C-W>

" Nerd tree
    map <leader>n :NERDTreeToggle<CR>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
    endif

" Shortcutting split navigation, saving a keypress:
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l

" Replace ex mode with gq
    map Q gq

" Check file in shellcheck
    map <leader>s :!clear && shellcheck -x %<CR>

" Replace all is aliased to S.
    nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
    map <leader>c :w! \| !compiler "<c-r>%"<CR>

" Open corresponding .pdf/.html or preview
    map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
    autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
    let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
    map <leader>v :VimwikiIndex<CR>
    let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
    autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
    autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
    autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
    cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writing
    " autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
    " autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
    " autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
    " autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
    autocmd BufWritePre * let currPos = getpos(".")
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePre * %s/\n\+\%$//e
    autocmd BufWritePre *.[ch] %s/\%$/\r/e
    autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Function for toggling the bottom statusbar:
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>
" Load command shortcuts generated from bm-dirs and bm-files via shortcuts script.
" Here leader is ";".
" So ":vs ;cfz" will expand into ":vs /home/<user>/.config/zsh/.zshrc"
" if typed fast without the timeout.

augroup yaml
    autocmd!
    autocmd FileType yaml setlocal tabstop=4 shiftwidth=4 expandtab
augroup END
