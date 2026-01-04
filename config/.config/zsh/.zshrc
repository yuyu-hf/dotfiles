# Ref: https://zenn.dev/enchan1207/articles/7b9d7d397b7d0d
if [ -r /etc/zshrc ]; then
    source /etc/zshrc
fi

bindkey -e # Enable emacs keybindings

# zsh/fzf.zshで定義した関数を"Ctrl-r"で呼び出せるようにしています。
# Emacsのkeybindingsでも"Ctrl-r"を利用しているので、"bindkey -e"の設定を上書きするように"bindkey -e"の後にzshの設定を反映させてください。
source "${HOME}/.config/zsh/common/init.zsh"
source "${HOME}/.config/zsh/local/init.zsh"

HISTFILE="${XDG_STATE_HOME}/.zsh_history" # 履歴を保存するファイルパス
HISTSIZE=1000                             # メモリ上に保存する履歴の行数
SAVEHIST=100000                           # 履歴ファイルに保存する履歴の行数

setopt auto_cd           # ディレクトリ名のみでcdを実行
setopt auto_pushd        # cdの度にディレクトリスタックに自動追加
setopt pushd_ignore_dups # ディレクトリスタックに重複を追加しない
setopt correct           # コマンドのスペルミスを修正候補を表示
setopt auto_param_slash  # ディレクトリ名の補完で末尾に/を自動追加
setopt mark_dirs         # ファイル名展開でディレクトリに/を付加
setopt list_types        # 補完候補にファイルの種類を表示（ls -Fのように）
setopt auto_menu         # 補完候補を順次表示
setopt hist_ignore_dups  # 直前と重複するコマンドを履歴に追加しない
setopt EXTENDED_HISTORY  # 履歴にタイムスタンプと実行時間を記録

# https://github.com/zsh-users/zsh-autosuggestions
# zsh-autosuggestionsでは、コマンド履歴から入力候補を自動的に提案する機能を有効化します。
source "${ZSH_PLUGINS_HOME}/zsh-autosuggestions/zsh-autosuggestions.zsh"

# https://github.com/zsh-users/zsh-completions
# zsh-completionsでは、zsh標準の補完機能を拡張し、docker、git、npmなど様々なコマンドの補完定義を提供します。
FPATH="${ZSH_PLUGINS_HOME}/zsh-completions:${FPATH}"

# zshの補完機能を初期化する
autoload -Uz compinit
compinit
