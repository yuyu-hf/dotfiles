# https://qiita.com/muran001/items/7b104d33f5ea3f75353f
export ZDOTDIR="${HOME}/.config/zsh"

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir/latest/
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

export XDG_BIN_HOME="${HOME}/.local/bin"

# Editor
export EDITOR='nvim'
export VISUAL='nvim' # lessコマンドでファイルを閲覧中に"v"を押すとnvimでファイルを開くことができる

# Detect OS
case "$(uname -s)" in
    Darwin)
        export OS='macos'
        export ZSH_PLUGINS_HOME='/opt/homebrew/share'
        ;;
    Linux)
        export OS='linux'
        export ZSH_PLUGINS_HOME='/usr/share/zsh/plugins'
        ;;
    *)
        export OS='unknown'
        ;;
esac

# Homebrew
if [ -d '/opt/homebrew/bin' ]; then
    export PATH="/opt/homebrew/bin:${PATH}"
fi

# Ref: https://zenn.dev/enchan1207/articles/7b9d7d397b7d0d
if [ "${OS}" = "macos" ]; then
    setopt no_global_rcs
    eval `/usr/libexec/path_helper -s`
fi

# 3rd party bin
export PATH="${XDG_BIN_HOME}:${PATH}"

# my bin
export PATH="${HOME}/.bin/common:${PATH}"
export PATH="${HOME}/.bin/local:${PATH}"
