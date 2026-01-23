# https://qiita.com/muran001/items/7b104d33f5ea3f75353f
export ZDOTDIR="${HOME}/.config/zsh"

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir/latest/
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

export XDG_BIN_HOME="${HOME}/.local/bin"

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

# Ref: https://zenn.dev/enchan1207/articles/7b9d7d397b7d0d
if [ "${OS}" = "macos" ]; then
    setopt no_global_rcs
    eval `/usr/libexec/path_helper -s`
fi
