###############################
# 基本設定
###############################

#### 履歴 {

# ヒストリーに重複を表示しない
setopt histignorealldups
# 他のターミナルとヒストリーを共有
setopt sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

#### }

#### zplug for mac {
# brewのインストールパスを設定する
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# pluginの追加

## zsh plugins
### コマンド候補を表示(C+f or C+e or ->)
### お好みで
#zplug 'zsh-users/zsh-autosuggestions'
### 補完の強化
zplug 'zsh-users/zsh-completions'
### 色をつける
zplug "zsh-users/zsh-syntax-highlighting", defer:2


## 未インストール項目をインストールする
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
       echo; zplug install
  fi
fi
## コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load --verbose
#### }


#### 補完強化 {

# 補完強化
# zplugで読み込まれるのでコメントアウトしている
#autoload -U compinit
#compinit
## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
## ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs
## 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt list_types
## 補完キー連打で順に補完候補を自動で補完
setopt auto_menu
## カッコの対応などを自動的に補完
setopt auto_param_keys
## コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments
## コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst
## 語の途中でもカーソル位置で補完
setopt complete_in_word
## カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt always_last_prompt
##日本語ファイル名等8ビットを通す
setopt print_eight_bit
## 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt extended_glob
## 明確なドットの指定なしで.から始まるファイルをマッチ
setopt globdots
## 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)
bindkey "^I" menu-complete
## <Tab> でパス名の補完候補を表示したあと、
## 続けて <Tab> を押すと候補からパス名を選択できるようになる
## 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=2
## 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## s詳細な情報を利用する
zstyle ':completion:*' verbose yes
### 補完候補
### _oldlist 前回の補完結果を再利用する。
### _complete: 補完する。
### _match: globを展開しないで候補の一覧から補完する。
### _history: ヒストリのコマンドも補完候補とする。
### _ignored: 補完候補にださないと指定したものも補完候補とする。
### _approximate: 似ている補完候補も補完候補とする。
### _prefix: カーソル以降を無視してカーソル位置までで補完する。
zstyle ':completion:*' completer _oldlist _complete _match _history _ignored _approximate _prefix

#### }

#### 表示系 {

# 色を使用できるようにする
autoload -Uz colors
colors

# zshのテーマ
autoload -U promptinit
promptinit
# prompt adam1

#### その他基本設定 {
# 日本語を使用
export LANG=ja_JP.UTF-8

# 単語の一部として扱われる文字のセットを指定する
# ここではデフォルトのセットから / を抜いたものとする
# こうすると、 Ctrl-W でカーソル前の1単語を削除したとき、 / までで削除が止まる
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
#### }

###############################
# カスタマイズ系
###############################

#### alias {
alias l='ls -lFG'
alias ll='ls -alFG'
alias rp="cd \$(realpath .)"
alias o="open"  # for mac
#alias sed="gsed" # for mac(needs install)
alias fd="find -type d -name"
alias ff="find -type f -name"
alias glog="git log --stat"
alias gb="git branch -a"
alias gs="git status"
alias gdiff="git diff"
alias gdiffo="git diff --no-ext-diff"
alias gch="git checkout"
alias ggr="git lg"
alias -g V="| nvim -"
alias -g L="| less -FX"
alias -g TS="-Dmaven.test.skip=true"
alias -g EE="eclipse:eclipse"
alias -g EC="eclipse:clean"
alias -g UC="-U clean"
alias -g BR='`git branch | fzf `' # need install fzf
#### }

#### Prompt customize {

# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info
# 表示フォーマットの指定
# %b ブランチ情報
# %a アクション名(mergeなど)
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
# バージョン管理されているディレクトリにいれば表示，そうでなければ非表示
RPROMPT="%1(v|%F{green}%1v%f|)"
#### }

# CTRL + R を便利に (needs isntall fzf)
if which fzf &> /dev/null; then
  function fzf_select_history() {
    BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
    CURSOR=$#BUFFER11
  }
  zle -N fzf_select_history
  bindkey '^R' fzf_select_history
fi

#### }


###############################
# 移動改善
###############################

## upコマンド
function up(){ cpath=./; for i in `seq 1 1 $1`; do cpath=$cpath../; done; cd $cpath;}

## dwコマンド（自作）
function dw(){
  num=$1
  root=$(pwd | cut -d / -f -3)
  if [ $root = $HOME ]; then
    res=$((num + 3))
  else
    res=$((num + 1))
  fi
  dir=$(pwd | cut -d / -f -$((res)))/
  cd $dir
}

## fasd
if which fasd &> /dev/null; then
  eval "$(fasd --init posix-alias zsh-hook)"
fi

## ディレクトリ名だけでcd
setopt autocd

## ディレクトリが変更されたら ls -lG
autoload -Uz add-zsh-hook
add-zsh-hook precmd autols
autols(){
  [[ $AUTOLS_DIR != $PWD ]] && ls -lG
  AUTOLS_DIR="${PWD}"
}
export PROMPT_COMMAND="autols" 

###############################
# その他関数
###############################

# camelcase変換
camel() {
    perl -pe 's#(_|^)(.)#\u$2#g'
}

# snakecase変換
snake() {
    perl -pe 's#([A-Z])#_\L$1#g' | perl -pe 's#^_##'
}

# --------------------------------------
# Google search from terminal
# --------------------------------------
ggl(){
    if [ $(echo $1 | egrep "^-[cfs]$") ]; then
        local opt="$1"
        shift
    fi
    local url="https://www.google.co.jp/search?q=${*// /+}"
    local app="/Applications"
    local g="${app}/Google Chrome.app"
    local f="${app}/Firefox.app"
    local s="${app}/Safari.app"
    case ${opt} in
        "-g")   open "${url}" -a "$g";;
        "-f")   open "${url}" -a "$f";;
        "-s")   open "${url}" -a "$s";;
        *)      open "${url}";;
    esac
}

###############################
# lessコマンド改善
###############################
# less コマンドの起動時オプション
export LESS='-i -M -R -W -z-4'
export LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh  %s'

# manなどを上記オプションのless利用
export PAGER=less


# zplugなどでzをインストールしとく
# zplug "rupa/z", use:z.sh

fzf-z-search() {
    local res=$(z | sort -rn | cut -c 12- | sed -r "s/([ |\(|\)])/\\\\\1/g" | fzf)
    if [ -n "$res" ]; then
        BUFFER+="cd $res"
        zle accept-line
    else
        return 1
    fi
}

zle -N fzf-z-search
bindkey '^b' fzf-z-search

function toon {
  echo -n ""
}

### プロンプト設定
if [ $EMACS ]; then
	export TERM=xterm-256color
	PROMPT="%F{green}%~%f %{$fg[red]%}>%{$reset_color%} "
else
	PROMPT="%F{green}%~%f %{$fg[white]%}$(toon)%{$reset_color%} "
fi
PROMPT2="%_%% "
SPROMPT="%r is correct? [n,y,a,e]: "
RPROMPT="%1(v|%F{yellow}%1v%f|)%F{red}%T%f"
