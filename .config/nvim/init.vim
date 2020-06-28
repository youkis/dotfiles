" Basic Conf
" basic conf{{{
syntax on                       "シンタックスハイライト
set encoding=utf8               "エンコード
set fileencoding=utf-8          "ファイルエンコード
set tabstop=2                   "タブ幅の設定
set shiftwidth=2                "タブ幅の設定
set undofile                    "やり直し
silent !mkdir ~/.neovim_undo > /dev/null 2>&1
set undodir=~/.neovim_undo     "やり直し
set imdisable                   "escで半角
set scrolloff=5                 "スクロールする時に下が見えるようにする
set nowritebackup               "バックアップファイルを作らない
set nobackup                    "バックアップをしない
set backspace=indent,eol,start  "バックスペースで各種消せるようにする
"set clipboard+=unnamed          "OSのクリップボードを使う
set clipboard=unnamedplus
set number                      "行番号を表示
set noruler                     "右下に表示される行・列の番号を非表示する
set matchpairs& matchpairs+=<:> "対応括弧に<と>のペアを追加
set nowrap                      "ウィンドウの幅より長い行は折り返され、次の行に続けて表示される
set textwidth=0                 "入力されているテキストの最大幅を無効にする
set ignorecase                  "小文字の検索でも大文字も見つかるようにする
set smartcase                   "ただし大文字も含めた検索の場合はその通りに検索する
set incsearch                   "インクリメンタルサーチを行う
set hlsearch                    "検索結果をハイライト表示
set history=1000                "コマンド、検索パターンを1000個まで履歴に残す
set nosplitright                "右に新しいsplit
set visualbell
" タブ、空白、改行の可視化
set list
set listchars=tab:\ \ ,trail:-,extends:>,precedes:<,nbsp:%
set foldmethod=marker           "折りたたみ
" python
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
" カレントディレクトリ設定(自動的に開いたファイルのディレクトリに移動)
if exists('+autochdir')
	set autochdir
endif
" }}}
" テンプレートファイル{{{
autocmd BufNewFile *.cpp 0r $HOME/.config/nvim/.vim/template/tmp.cpp
autocmd BufNewFile *.c   0r $HOME/.config/nvim/.vim/template/tmp.c
"autocmd BufNewFile *.tex 0r $HOME/.config/nvim/.vim/template/tmp.tex
autocmd BufNewFile *.plt 0r $HOME/.config/nvim/.vim/template/tmp.plt
au BufRead,BufNewFile *.plt	setfiletype gnuplot " }}}
" Terminal
" enter terminal-job mode automatically
if has('nvim')
  autocmd WinEnter * if &buftype ==# 'terminal' | startinsert | endif
  noremap  <C-k> :vsplit<CR><C-w>w:terminal<CR>:startinsert<CR>
else
  autocmd WinEnter * if &buftype ==# 'terminal' | normal i | endif
  noremap  <C-k> :vsplit<CR><C-w>w:terminal<CR>:normal i<CR>
endif

"キーマッピング{{{
nnoremap ; :
noremap  <C-j> <C-w>w
inoremap <C-j> <Esc><C-w>w
tnoremap <C-j> <C-\><C-n><C-w>w
ab tt TagbarToggle
"}}}
" Compile"{{{
command! COMPILE call s:COMPILE()
function! s:COMPILE()
	w
	let ftype=expand('%:e')
	if ftype==?'c'
		!clang   % -o %:r.out -lm 2>&1| more
		!./%:r.out
	elseif ftype==?'cpp'
		!clang++ % -o %:r.out -lm 2>&1| more
		!./%:r.out
	elseif ftype==?'py'
		!python %
	elseif ftype==?'java'
		!javac %
		!java %:r
	elseif ftype==?'tex'
		!latexmk -pv %
	endif
endfunction
"}}}
" OpenCV"{{{
command! OPENCV call s:opencv()
function! s:opencv()
	w
	let ftype=expand('%:e')
	if ftype==?'c'
		!clang   % -o %:r.out `pkg-config --cflags opencv` `pkg-config --libs opencv` 2>&1|more
	elseif ftype==?'cpp'
		!clang++ % -o %:r.out `pkg-config --cflags opencv` `pkg-config --libs opencv` 2>&1|more
	endif
	!./%:r.out|more
endfunction
"}}}

let g:python3_host_prog = expand('/usr/bin/python3')
" Pulgins
" conf dein{{{
" インストールディレクトリ
let s:dein_dir = expand('~/.config/nvim/.vim/dein')
" dein.vim path
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から download
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイルを用意
  let g:rc_dir    = expand('~/.config/nvim/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  " TOML 読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

" }}}

" conf lose tag
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*erb"
"Tab補完の設定
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
augroup my_augroup
	au FileType python setlocal completeopt-=preview  "別windowでhelpを表示しない
augroup END

" color{{{
if !has("gui_running")
	" カラー設定
	colorscheme NeoSolarized
	syntax enable
	set background=dark
	"let g:solarized_contrast="high"
	let g:neosolarized_contrast="high"
	"split bar
	set fillchars=vert:\ 
	hi VertSplit ctermbg=blue guibg=blue
endif
"}}}
filetype plugin indent on
