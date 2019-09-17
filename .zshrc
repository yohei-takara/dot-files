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
zplug 'zsh-users/zsh-autosuggestions'
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
# setopt auto_param_keys
## コマンドラインでも # 以降をコメントと見なす
# setopt interactive_comments
## コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
# setopt magic_equal_subst
## 語の途中でもカーソル位置で補完
# setopt complete_in_word
## カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt always_last_prompt
##日本語ファイル名等8ビットを通す
setopt print_eight_bit
## 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
# setopt extended_glob
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

# docker
alias dps='docker ps'
alias dim='docker images'
alias drm='docker rm'
alias drma='docker rm $(docker ps -aqf "status=exited") 2> /dev/null'
alias drmi='docker rmi'
alias drmia='docker rmi $(docker images -aqf "dangling=true") 2> /dev/null'
alias dc='docker-compose'

# kubernetes
alias k='kubectl'


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

#export LSCOLORS=exfxcxdxbxegedabagacad
#export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

#zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

export CLICOLOR=1
export LSCOLORS=gxGxcxdxCxegedabagacad


# bash config 読み込み
source $HOME/.bash_profile


setopt nonomatch
