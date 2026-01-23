# Editor
export EDITOR='nvim'
export VISUAL='nvim' # lessコマンドでファイルを閲覧中に"v"を押すとnvimでファイルを開くことができる

export PATH="${XDG_BIN_HOME}:${PATH}"
export PATH="${HOME}/.bin/common:${PATH}"
export PATH="${HOME}/.bin/local:${PATH}"

# Homebrew
if [ -d '/opt/homebrew/bin' ]; then
    export PATH="/opt/homebrew/bin:${PATH}"
fi

# nix
export PATH="$HOME/.nix-profile/bin:$PATH"

# aqua
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME}/aquaproj-aqua}/bin:$PATH"
export AQUA_GLOBAL_CONFIG="${AQUA_GLOBAL_CONFIG:-}:${XDG_CONFIG_HOME}/aquaproj-aqua/aqua.yaml"

# starship
export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/.starship.toml"

# dotfiles
export DOTFILES_DIR="$(ghq root)/github.com/yuyu-hf/dotfiles"
export PATH="${DOTFILES_DIR}/node_modules/.bin":$PATH
