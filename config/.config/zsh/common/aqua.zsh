export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME}/aquaproj-aqua}/bin:$PATH"
export AQUA_GLOBAL_CONFIG="${AQUA_GLOBAL_CONFIG:-}:${XDG_CONFIG_HOME}/aquaproj-aqua/aqua.yaml"

aqua install --all --only-link
