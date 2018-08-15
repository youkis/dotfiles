" Basic Conf
" basic conf{{{
syntax on                       "シンタックスハイライト
set encoding=utf8               "エンコード
set fileencoding=utf-8          "ファイルエンコード
set tabstop=2                   "タブ幅の設定
set shiftwidth=2                "タブ幅の設定
set undofile                    "やり直し
set undodir=~/.vim/undofile     "やり直し
silent !mkdir ~/.neovim_undo > /dev/null 2>&1
set imdisable                   "escで半角
set scrolloff=5                 "スクロールする時に下が見えるようにする
set nowritebackup               "バックアップファイルを作らない
set nobackup                    "バックアップをしない
set backspace=indent,eol,start  "バックスペースで各種消せるようにする
set clipboard+=unnamed          "OSのクリップボードを使う
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
autocmd BufNewFile *.cpp 0r $HOME/.vim/template/tmp.cpp
autocmd BufNewFile *.c   0r $HOME/.vim/template/tmp.c
"autocmd BufNewFile *.tex 0r $HOME/.vim/template/tmp.tex
autocmd BufNewFile *.plt 0r $HOME/.vim/template/tmp.plt
au BufRead,BufNewFile *.plt	setfiletype gnuplot " }}}
" Functions
"キーマッピング{{{
nmap <F12>   :w<CR>:only<CR>:QuickRun<CR>
nmap <F11>   :w<CR>:QuickRun<CR>
nmap <F10>   :COMPILE<CR>
" ノーマルモード時だけ;と:を入れ替える
"nnoremap ; :
"nnoremap : ;
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

" Pulgins
let g:python3_host_prog = expand('~/.pyenv/versions/anaconda3-4.1.0/bin/python')
" conf nerdtree
let g:NERDTreeWinPos = 'left'
" conf lose tag
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*erb"
" conf dein{{{
" インストールディレクトリ
let s:dein_dir = expand('~/.vim/dein_vim8')
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
  let g:rc_dir    = expand('~/.vim/rc_vim8')
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
" conf quickrun.vim{{{
if !exists("g:quickrun_config")
	let g:quickrun_config={}
endif
let g:quickrun_config["_"]={
			\ "runner/vimproc/updatetime" : 60,
			\ "outputter" : "error",
			\ "outputter/error/success" : "buffer",
			\ "outputter/error/error"   : "quickfix",
			\ "outputter/buffer/split"  : "botright 5sp",
			\ "outputter/buffer/into"   : 0,
			\ "outputter/buffer/close_on_empty" : 1}
let g:quickrun_config["c"]          = { "cmdopt" : "-lm" }
let g:quickrun_config["cpp"]        = { "cmdopt" : "-lm" }
let g:quickrun_config["opencv/cpp"] = { "command": "clang++","exec": ["%c %o %s -o %s:p:r", "%s:p:r %a"],"cmdopt" : "`pkg-config --cflags opencv --libs opencv`","tempfile": "%{tempname()}.cpp","hook/sweep/files": ["%S:p:r"],}
let g:quickrun_config["opencv/c"]   = { "command": "clang"  ,"exec": ["%c %o %s -o %s:p:r", "%s:p:r %a"],"cmdopt" : "`pkg-config --cflags opencv --libs opencv`","tempfile": "%{tempname()}.cpp","hook/sweep/files": ["%S:p:r"],}
let g:quickrun_config["html"]       = { "command": "open","exec": ["%c %s"]}
let g:quickrun_config["asm"]        = {
			\ "command"         : "nasm",
			\ "exec"            : ["%c %o %s","ld %s:p:r.o -o %s:p:r.out","%s:p:r.out"],
			\ "cmdopt"          : "-f macho","tempfile": "%{tempname()}.asm",
			\ "hook/sweep/files": ["%S:p:r.o","%S:p:r.out"]}
let g:quickrun_config["gnuplot"] = {
			\ "command"         : "gnuplot",
			\ "exec"            : ["%c -c %s","open %s:p:r.eps"]}
"let g:quickrun_config["tex"] = {
"			\ "command"         : "latexmk",
"			\ "outputter/error/success" : "null",
"			\ "cmdopt"          : "-pv",
"			\ "hook/sweep/files": ["%S:p:r.aux","%S:p:r.bbl","%S:p:r.blg","%S:p:r.dvi","%S:p:r.fdb_latexmk","%S:p:r.fls","%S:p:r.log","%S:p:r.out"],
"			\ "exec"            : "%c %o %s"}
" wしたらquickrun実行
"autocmd BufWritePost,FileWritePost *.tex QuickRun tex
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
"}}}
" conf denite{{{
"C-N,C-Pで上下移動
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#source(
    \ 'file_rec', 'matchers', ['matcher_fuzzy', 'matcher_project_files', 'matcher_ignore_globs'])
" 検索対象外のファイル指定
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])
" バッファ一覧
noremap <C-P> :Denite -mode=normal buffer<CR>
" ファイル一覧
noremap <C-N> :Denite -mode=normal -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Denite -mode=normal file_old<CR>
"noremap <S-^Z> :Denite file_rec<CR>
" sourcesを「今開いているファイルのディレクトリ」とする
noremap :uff :<C-u>DeniteWithBufferDir file -buffer-name=file<CR>
" }}}
" submode pulgin for resize window {{{
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>+')
call submode#map('winsize', 'n', '', '-', '<C-w>-')
"}}}
" conf nerdtree {{{
let g:NERDTreeWinPos = 'left'
"}}}
" conf lose tag{{{
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*erb"
" }}}
" conf deoplete {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni_patterns = {}
"Tab補完の設定
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
augroup my_augroup
	au FileType python setlocal completeopt-=preview  "別windowでhelpを表示しない
augroup END
" }}}
" conf vim-latex{{{
if has("mac")
" コンパイル時に使用するコマンド
set shellslash
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Imap_UsePlaceHolders = 1
let g:Imap_DeleteEmptyPlaceHolders = 1
let g:Imap_StickyPlaceHolders = 0
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_MultipleCompileFormats='dvi,pdf'
let g:Tex_FormatDependency_pdf = 'dvi,pdf'
let g:Tex_FormatDependency_ps = 'dvi,ps'
let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
let g:Tex_BibtexFlavor = 'jbibtex'
let g:Tex_UseEditorSettingInDVIViewer = 1
let g:Tex_ViewRule_pdf = 'Skim'
endif
" }}}
" color{{{
if !has("gui_running")
	" カラー設定
	syntax enable
	set background=dark
	let g:solarized_contrast="high"
	colorscheme solarized
endif
"}}}
filetype plugin indent on

