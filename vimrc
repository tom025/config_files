filetype off
call pathogen#runtime_append_all_bundles()
syntax on
filetype plugin indent on
set modelines=0
set nocompatible

set tabstop=2
set softtabstop=2
set smarttab
set shiftwidth=2
set expandtab

set autoindent
set encoding=utf-8
set showmode
set showcmd

" From http://items.sjbach.com/319/configuring-vim-right
set hidden
let mapleader = ","
let maplocalleader = ","
set history=1000
set wildmenu
set wildmode=list:longest
set ignorecase
set smartcase
set title
set ttyfast
set cursorline
set scrolloff=3
set backupdir=~/.vim/backups,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim/backups,~/.tmp,~/tmp,/var/tmp,/tmp

nnoremap <tab> %
vnoremap <tab> %
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
set gdefault
set backspace=indent,eol,start

" File-type highlighting and configuration.
" Run :filetype (without args) to see what you may have
" to turn on yourself, or just set them all to be sure.
set incsearch
set shortmess=atI
set visualbell
" From http://weblog.jamisbuck.org/2008/11/17/vim-follow-up
set grepprg=ack
set grepformat=%f:%l:%m
autocmd FileType make     set noexpandtab
autocmd FileType python   set noexpandtab
set ruler
set number
set hlsearch
syntax on

map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

"CommandT
map <leader>ga :CommandTFlush<CR>\|:CommandT<CR>
map <leader>gv :CommandTFlush<CR>\|:CommandT app/views<CR>
map <leader>gc :CommandTFlush<CR>\|:CommandT app/controllers<CR>
map <leader>gm :CommandTFlush<CR>\|:CommandT app/models<CR>

" From http://biodegradablegeek.com/2007/12/using-vim-as-a-complete-ruby-on-rails-ide/
set cf  " Enable error files & error jumping.
set clipboard+=unnamed  " Yanks go on clipboard instead.
set autowrite  " Writes on make/shell commands
set showmatch
set laststatus=2

"Save on losing focus
"au FocusLost * :wa

"My own keybindings
map <leader>gd :GitDiff<CR>
map <leader>gs :GitStatus<CR>
"map <leader>gc :GitCommit<CR>
nnoremap <leader><space> :noh<cr>
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
map <leader>f :set nofu<CR>:set lines=100 columns=400 fu<CR>
map <leader>id !!date +'\%Y-\%m-\%d \%T \%z'<CR>
map <leader>pc :ColorHEX<CR>

" Use .as for ActionScript files, not Atlas files.
au BufNewFile,BufRead *.as set filetype=actionscript
au BufNewFile,BufRead *.ru set filetype=ruby
au BufNewFile,BufRead Gemfile set filetype=ruby
au BufNewFile,BufRead *.md set filetype=mkd

" Understand :W as :w
command! W :w

" Show unwanted whitespace
set listchars=tab:-✈,trail:,extends:>
set list!
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Running tests
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-makegreen binds itself to ,t unless something else is bound to its
" function.
map <leader>\dontstealmymapsmakegreen :w\|:call MakeGreen('spec')<cr>


function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! SetRspec1()
  let t:st_rspec_command="spec"
endfunction

function! SetRspec2()
  let t:st_rspec_command="rspec"
endfunction

function! SetBundle()
  let t:st_bundle_command="bundle exec"
endfunction

function! SetNoBundle()
  let t:st_bundle_command=""
endfunction

function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !echo;echo;echo;echo;echo

  if !exists("t:st_bundle_command")
    call SetBundle()
  endif

  if !exists("t:st_rspec_command")
    call SetRspec2()
  endif

  exec ":!" . t:st_bundle_command . " " . t:st_rspec_command . " " . a:filename
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    if in_spec_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

command! Rspec1 :call SetRspec1()
command! Rspec2 :call SetRspec2()
command! NoBundle :call SetNoBundle()
command! WithBundle :call SetNobundle()

map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('spec')<cr>
map <leader>C :w\|:!bundle exec cucumber %<cr>
map <leader>c :w\|:!bundle exec cucumber -p wip -r features %<cr>

" Status line
set statusline=%f\ %(%m%r%h\ %)%([%Y]%)%=%<%-20{getcwd()}\ [b%n]\ %l/%L\ ~\ %p%%\ \
colorscheme tir_black
set t_Co=256

"Colour column
set colorcolumn=80
map <leader>z :set colorcolumn=80

map <leader>H :%s/:\(\w\+\) =>/\1:<CR>``
map <leader>, :b#<CR>
