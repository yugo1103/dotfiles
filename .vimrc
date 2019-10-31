set encoding=utf-8 
scriptencoding utf-8

set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set ambiwidth=double " □や○文字が崩れる問題を解決

set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop=4 " 画面上でタブ文字が占める幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set shiftwidth=4 " smartindentで増減する幅

set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト

" ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

set whichwrap=b,s,h,l,<,>,[,],~ " カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set number " 行番号を表示
set cursorline " カーソルラインをハイライト

" 行が折り返し表示されていた場合、行単位ではなく表示行単位でカーソルを移動する
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

" バックスペースキーの有効化
set backspace=indent,eol,start

set showmatch " 括弧の対応関係を一瞬表示する
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する

set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数

if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function! XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif



if has('vim_starting')
    " 小笠コメント：
    " NeoBundleは作者Shougo氏すら非推奨してるくらい古いのでvim-plugに変更
    " Shougo氏はdein.nvimを推奨
    set runtimepath+=$HOME/.vim
    if !filereadable(escape(substitute($HOME.'/.vim/autoload','\','/','g'),' ').'/plug.vim')
        " vim-plugが未インストールの場合、インストール
        echo "install vim-plug..."
        call system(printf('curl -flo "%s/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',substitute($HOME,'\','/','g')))
        augroup vimplug_install
            autocmd!
            autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
        augroup END
    endif
endif

call plug#begin(expand('~/.vim/plugged'))

"------------------------------------------------------------------------------
" ここに追加したいVimプラグインを記述する・・・・・・②

" カラースキームmolokai
Plug 'tomasr/molokai'

set t_Co=256 " iTerm2など既に256色環境なら無くても良い
syntax enable " 構文に色を付ける
"----------------------------------------------------------



" ステータスラインの表示内容強化
Plug 'itchyny/lightline.vim'

"----------------------------------------------------------
" ステータスラインの設定
"----------------------------------------------------------
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの現在位置を表示する
"----------------------------------------------------------



" 末尾の全角と半角の空白文字を赤くハイライト(:FixWhitespace)
Plug 'bronson/vim-trailing-whitespace'



" インデントの可視化
Plug 'Yggdroot/indentLine'



"----------------------------------------------------------
" 小笠コメント：
" YouCompleteMe推奨
" NeoBundle同様作者Shougo氏は非推奨していて、
" 今はdeoplete.nvimを推奨している
"
" if has('lua') " lua機能が有効になっている場合・・・・・・①
"     " コードの自動補完
"     Plug 'Shougo/neocomplete.vim'
"     " スニペットの補完機能
"     Plug 'Shougo/neosnippet'
"     " スニペット集
"     Plug 'Shougo/neosnippet-snippets'
" endif

"----------------------------------------------------------
" neocomplete・neosnippetの設定
"----------------------------------------------------------
" if has_key(g:plugs, 'neocomplete.vim')
"     " Vim起動時にneocompleteを有効にする
"     let g:neocomplete#enable_at_startup = 1
"     " smartcase有効化. 大文字が入力されるまで大文字小文字の区別を無視する
"     let g:neocomplete#enable_smart_case = 1
"     " 3文字以上の単語に対して補完を有効にする
"     let g:neocomplete#min_keyword_length = 3
"     " 区切り文字まで補完する
"     let g:neocomplete#enable_auto_delimiter = 1
"     " 1文字目の入力から補完のポップアップを表示
"     let g:neocomplete#auto_completion_start_length = 1
"     " バックスペースで補完のポップアップを閉じる
"     inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"
"
"     " エンターキーで補完候補の確定. スニペットの展開もエンターキーで確定・・・・・・②
"     imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
"     " タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ・・・・・・③
"     imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
" endif
"----------------------------------------------------------



" 小笠コメント：
" fzfでも同様のことができるので、いらない可能性
" この手のプラグインはctrlp、fzfに加え、Shougo氏のdenite.nvimが有名
" 一番使われてるのはおそらくfzf
" 因みに最近プルリクエストを出したけどマージされなくて悲しい
" https://github.com/ctrlpvim/ctrlp.vim/pull/516

"----------------------------------------------------------
" 多機能セレクタ
"Plug 'ctrlpvim/ctrlp.vim'
" CtrlPの拡張プラグイン. 関数検索
"Plug 'tacahiroy/ctrlp-funky'
" CtrlPの拡張プラグイン. コマンド履歴検索
"Plug 'suy/vim-ctrlp-commandline'

"----------------------------------------------------------
" CtrlPの設定
"----------------------------------------------------------
"let g:ctrlp_match_window = 'order:ttb,min:20,max:20,results:100' " マッチウインドウの設定. 「下部に表示, 大きさ20行で固定, 検索結果100件」
"let g:ctrlp_show_hidden = 1 " .(ドット)から始まるファイルも検索対象にする
"let g:ctrlp_types = ['fil'] "ファイル検索のみ使用
"let g:ctrlp_extensions = ['funky', 'commandline'] " CtrlPの拡張として「funky」と「commandline」を使用

" CtrlPCommandLineの有効化
"command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())

" CtrlPFunkyの有効化
"let g:ctrlp_funky_matchtype = 'path'
"------------------------------------------------------------------------------



" 小笠コメント：
" 一時期agも有名だったが今はgrepツールはもっぱらripgrepのほうが有名でかつ速い
" https://github.com/BurntSushi/ripgrep
" let g:ctrlp_user_command='rg %s --files --color=never -i --hidden --glob ""'
"----------------------------------------------------------
" CtrlPの検索にagを使う
"Plug 'rking/ag.vim'

"----------------------------------------------------------
" ag.vimの設定
"----------------------------------------------------------
"if executable('ag') " agが使える環境の場合
"  let g:ctrlp_use_caching=0 " CtrlPのキャッシュを使わない
"  let g:ctrlp_user_command='ag %s -i --hidden -g ""' " 「ag」の検索設定
"endif
"----------------------------------------------------------




Plug 'scrooloose/nerdtree'
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"autocmd vimenter * NERDTree
nnoremap <silent><C-t> :NERDTreeToggle<CR>
" 小笠コメント：↓このバインドは一体・・・？
nnoremap <C-c> :closetab
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
  exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
  exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
"------------------------------------------------------------------------------

Plug 'tpope/vim-fugitive'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'iberianpig/ranger-explorer.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'


nnoremap <silent><C-g> :Rg<CR>
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\ 'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
\ <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
\ : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
\ <bang>0)
"------------------------------------------------------------------------------
"fzf 設定
"------------------------------------------------------------------------------
" ファイル一覧を出すときにプレビュー表示
command! -bang -nargs=? -complete=dir Files
\ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" [Replace of ctrlp.vim] ========================================
nnoremap <C-p> :FZFFileList<CR>
command! FZFFileList call fzf#run({
            \ 'source': 'find . -type d -name .git -prune -o ! -name .DS_Store',
            \ 'sink': 'e'})


" [MRU] ========================================
command! Fmru FZFMru
command! FZFMru call fzf#run({
            \  'source':  v:oldfiles,
            \  'sink':    'tabe',
            \  'options': '-m -x +s',
            \  'down':    '40%'})

"------------------------------------------------------------------------------
" 以下小笠推奨プラグイン
"------------------------------------------------------------------------------
" neosnippetの代わりのプラグイン群
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'

" インサートモードを抜けたときに、YouCompleteMe補完時に
" 上部に出てくるドキュメントプレビューを閉じる
let g:ycm_autoclose_preview_window_after_insertion = 1

" 保管時のタブの挙動をいい感じにする設定群
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" 参考: https://stackoverflow.com/questions/14896327/ultisnips-and-youcompleteme


" 括弧勝手に閉じてくれるやつ
Plug 'jiangmiao/auto-pairs'


" コメントアウトプラグイン
Plug 'scrooloose/nerdcommenter'
" 使い方：
"
" ノーマルモードまたはヴィジュアル選択モードで<Leader>cbの順で押すとコメントアウトになる
" <Leader>はデフォルトでは\になっているので\cbの順で押せばいい。
" コメントアウト解除は<Leader>cu
" トグルは<Leader>c<Space>
" 詳細は:help NERDCommenterを参照


" 括弧やクオートで囲ったりするのを楽にできる用にするプラグイン
Plug 'tpope/vim-surround'
" 使い方：
"
" 以下のwordをヴィジュアル選択(ノーマルモードからvで選択できるようになるやつ)した状態で、
" S) の順でキーを押すと囲えたりとかする(Sは大文字なことに注意)
"
" word
"
" 因みに、ノーマルモードで上のコメントのwordの上にカーソルを載せ、
" viwの順でキーを押すと単語選択できる。意味はvisual inner wordらしい。
" vi)とすれば()内を選択出来、vi'とすれば''内を選択できる。他にも色々ある。
" (v)isual (i)nner (w)ord のvとiとwの部分の選択肢でよく使うものは以下
"
" vの部分の選択肢：
"   v: visual 選択
"   d: delete 削除
"   c: change 変更
"   y: yank   ヤンク（コピー）
" iの部分の選択肢:
"   i: inner  内側（括弧等の内側)
"   a: a/an   外側（括弧等も含めて）
" wの部分の選択肢:
"   w: word   単語（単語っぽいところを判別）
"   W: WORD   単語（スペースまで全部）
"   (: 括弧
"   ): 括弧
"   [: 括弧
"   ]: 括弧
"   ": クオート
"   ': クオート
"
" 他にも色々あるが、詳細は:help text-objectsを参照



" スペースやカンマ等で整列できるプラグイン
Plug 'junegunn/vim-easy-align'

" ヴィジュアルモードのEnterにバインド
vmap <CR> <Plug>(LiveEasyAlign)

" 使い方説明用
let s:test_format = ""
let    s:test_format            =    ""
" 使い方：
"
" 1. 上のs:test_formatの二行をヴィジュアル行選択モード(Vで行ける(Vは大文字小文字なことに注意))で選択し、
"    Enterを押すとLiveEasyAlignモードに入る
" 2. そのまま=を押すと=で整列される
" 3. そのままもう一度=を押すと確定する
" 4. もう一度上のs:test_formatの二行を選択し、Enterを押すとLiveEasyAlignモードに入る
" 5. そのまま<Space>を押すと１つめのスペースで整列される
" 6. そのまま*を押すと全てのスペースで整列される
" 7. そのままもう一度<Space>を押すと確定する
"
" 詳細は:help easyalign参照
unlet s:test_format

" linterプラグイン("imported but unused"とか出るやつ)
Plug 'w0rp/ale'

"------------------------------------------------------------------------------
call plug#end()

"----------------------------------------------------------
" molokaiの設定
"----------------------------------------------------------
if has_key(g:plugs, 'molokai') " molokaiがインストールされていれば
    " plug#end後でないと正常に読み込めないことがある（小笠）
    colorscheme molokai " カラースキームにmolokaiを設定する
endif


"------------------------------------------------------------------------------
" 以下小笠推奨設定
"------------------------------------------------------------------------------
" Vimでコピーしたものがクリップボードに入る
set clipboard=unnamed,unnamedplus
" 詳細は:help 'clipboard'参照

" 一行が一ページ以上に長い場合でも@にせずちゃんと表示
set display=lastline                                     "
" 詳細は:help 'display'参照

" 保存せずに編集中ファイルを一旦バックグラウンドにおいておける
" 例）
" 1. :e ~/.vimrc
" 2. 何か編集する
" 3. :e ~/.bashrc
" 4. :ls
"    →編集中ファイル一覧が番号付きで表示される
" 5. :b <~/.vimrcの番号>
" →編集中の~/.vimrcに戻れる
set hidden
" 詳細は:help 'hidden'参照

" 他のソフトで、編集中ファイルが変更されたとき自動Reload
set autoread
" 詳細は:help 'autoread'参照


" set undofileアンドゥデータがファイルを閉じても残るようになる
" set undodirでアンドゥデータの保存先を変更
" 該当フォルダがなければ作成しておく
if !isdirectory($HOME . '/.vim/undofiles')
    call mkdir($HOME . '/.vim/undofiles','p')
endif
set undodir=$HOME/.vim/undofiles
set undofile

" set backupでバックアップファイルを保存するようになる
" set backupdirでバックアップファイルの保存先を変更
" 該当フォルダがなければ作成
if !isdirectory($HOME . '/.vim/backupfiles')
    call mkdir($HOME . '/.vim/backupfiles','p')
endif
set backupdir=$HOME/.vim/backupfiles
set backup

" set dir-=.でカレントディレクトリに.swpファイルを作成しないようにする
" set dir^=$HOME/tmp//で~/tmp/に.swpファイルを%区切りでフルパスで保存するようにする
" 該当フォルダがなければ作成
if !isdirectory($HOME . '/tmp')
    call mkdir($HOME . '/tmp','p')
endif
set dir-=.
set dir^=$HOME/tmp//

" コマンドラインの補完の挙動の設定
" 1回目のTABキーで候補に共通する文字列までを補完
" 2回目以降のTABキーで全文字補完
set wildmode=longest:full,full

" コマンドラインの高さを2にする
set cmdheight=2
" タブバーを常に表示
set showtabline=2

" ターミナルでフルカラーにしたい場合の設定
"set termguicolors
" " tmuxでもフルカラーを使える用にするおまじない
" let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
" let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
" " 上のでやばかったらこっちを使う
"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" " どっちもだめなら諦める

" :Wsudoでsudoで保存できるようにする
command! Wsudo execute("w !sudo tee % > /dev/null")
