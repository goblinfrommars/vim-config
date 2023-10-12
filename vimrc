call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/nerdtree'
Plug 'mattn/emmet-vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'ap/vim-css-color'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'kien/rainbow_parentheses.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'pangloss/vim-javascript'
Plug 'docunext/closetag.vim'
Plug 'chiel92/vim-autoformat'
Plug 'jwalton512/vim-blade'
Plug 'flrnprz/plastic.vim'
Plug 'EdenEast/nightfox.nvim'
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'yaegassy/coc-blade', {'do': 'yarn install --frozen-lockfile'}
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'ayu-theme/ayu-vim'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'sheerun/vim-polyglot'
Plug 'alvan/vim-closetag'
call plug#end()


" NERDTree Commands
nnoremap <leader>n :NERDTreeFocus<CR>
nmap <C-e> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" Autoclose commands
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" colorscheme
set termguicolors
let ayucolor="dark"
syntax on
let g:alduin_Shout_Fire_Breath = 1
colorscheme lucius
" colorscheme plastic
" let g:lightline = { 'colorscheme': 'plastic' }

" COC config
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <NUL> coc#refresh()
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "\<Tab>"

" other settings
filetype indent on
set smartindent
autocmd BufRead,BufWritePre *.sh normal gg=G
set ai
set si
set nowrap
set expandtab
set noexpandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set relativenumber
set mouse=a
set encoding=UTF-8
set autoread
set clipboard=unnamed
au CursorHold * checktime  

" alt - up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
nnoremap <A-C-j> yyp
nnoremap <A-C-k> yyP



" Ps = 0  -> blinking block.
" Ps = 1  -> blinking block (default).
" Ps = 2  -> steady block.
" Ps = 3  -> blinking underline.
" Ps = 4  -> steady underline.
" Ps = 5  -> blinking bar (xterm).
" Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[5 q"
let &t_EI = "\e[1 q"
let g:VM_mouse_mappings = 1

" Vim indent file
" Language:     Blade (Laravel)
" Maintainer:   Jason Walton <jwalton512@gmail.com>

if exists('b:did_indent')
    finish
endif

runtime! indent/html.vim
let s:htmlindent = &indentexpr

unlet! b:did_indent
runtime! indent/php.vim
let s:phpindent = &indentexpr

let b:did_indent = 1

" Doesn't include 'foreach' and 'forelse' because these already get matched by 'for'.
let s:directives_start = 'if\|else\|unless\|for\|while\|empty\|push\|section\|can\|hasSection\|verbatim\|php\|' .
            \ 'component\|slot\|prepend\|auth\|guest'
let s:directives_end = 'else\|end\|empty\|show\|stop\|append\|overwrite'

if exists('g:blade_custom_directives_pairs')
    let s:directives_start .= '\|' . join(keys(g:blade_custom_directives_pairs), '\|')
    let s:directives_end .= '\|' . join(values(g:blade_custom_directives_pairs), '\|')
endif

setlocal autoindent
setlocal indentexpr=GetBladeIndent()
exe 'setlocal indentkeys=o,O,<>>,!^F,0=}},0=!!},=@' . substitute(s:directives_end, '\\|', ',=@', 'g')

" Only define the function once.
if exists('*GetBladeIndent')
    finish
endif

function! s:IsStartingDelimiter(lnum)
    let line = getline(a:lnum)
    return line =~# '\%(\w\|@\)\@<!@\%(' . s:directives_start . '\)\%(.*@end\|.*@stop\)\@!'
                \ || line =~# '{{\%(.*}}\)\@!'
                \ || line =~# '{!!\%(.*!!}\)\@!'
                \ || line =~# '<?\%(.*?>\)\@!'
endfunction

function! GetBladeIndent()
    let lnum = prevnonblank(v:lnum - 1)
    if lnum == 0
        return 0
    endif

    let line = getline(lnum)
    let cline = getline(v:lnum)
    let indent = indent(lnum)

    " 1. Check for special directives
    " @section and @slot are single-line if they have a second argument.
    " @php is a single-line directive if it is followed by parentheses.
    if (line =~# '@\%(section\|slot\)\%(.*@end\)\@!' && line !~# '@\%(section\|slot\)\s*([^,]*)')
                \ || line =~# '@php\s*('
        return indent
    endif

    " 2. When the current line is an ending delimiter: decrease indentation
    "    if the previous line wasn't a starting delimiter.
    if cline =~# '^\s*@\%(' . s:directives_end . '\)'
                \ || cline =~# '\%(<?.*\)\@<!?>'
                \ || cline =~# '\%({{.*\)\@<!}}'
                \ || cline =~# '\%({!!.*\)\@<!!!}'
        return s:IsStartingDelimiter(lnum) ? indent : indent - &sw
    endif

    " 3. Increase indentation if the line contains a starting delimiter.
    if s:IsStartingDelimiter(lnum)
        return indent + &sw
    endif

    " 4. External indent scripts (PHP and HTML)
    execute 'let indent = ' . s:htmlindent

    if exists('*GetBladeIndentCustom')
        let indent = GetBladeIndentCustom()
    elseif line !~# '^\s*\%(#\|//\)\|\*/\s*$' && (
                \ searchpair('@include\%(If\)\?\s*(', '', ')', 'bWr') ||
                \ searchpair('{!!', '', '!!}', 'bWr') ||
                \ searchpair('{{', '', '}}', 'bWr') ||
                \ searchpair('<?', '', '?>', 'bWr') ||
                \ searchpair('@php\s*(\@!', '', '@endphp', 'bWr') )
        " Only use PHP's indent if the region spans multiple lines
        if !s:IsStartingDelimiter(v:lnum)
            execute 'let indent = ' . s:phpindent
        endif
    endif

    return indent
endfunction



" Define some single Blade directives. This variable is used for highlighting only.
let g:blade_custom_directives = ['datetime', 'javascript']

" Define pairs of Blade directives. This variable is used for highlighting and indentation.
let g:blade_custom_directives_pairs = {
      \   'markdown': 'endmarkdown',
      \   'cache': 'endcache',
      \ }

autocmd FileType scss setl iskeyword+=@-@

vnoremap <C-c> "*y
map <C-v> "+P

" nerdtree command
autocmd BufEnter NERD_tree_* | execute 'normal R'
au CursorHold * if exists("t:NerdTreeBufName") | call <SNR>15_refreshRoot() | endif
augroup DIRCHANGE
    au!
    autocmd DirChanged global :NERDTreeCWD
augroup END
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


