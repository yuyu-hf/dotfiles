# tmuxcc - Docker Compose auto-start
# Project: https://github.com/yuyu-hf/tmuxcc

function _tmuxcc_start_compose() {
    local project_dir="${HOME}/src/github.com/yuyu-hf/tmuxcc"
    local compose_file="${project_dir}/compose.yaml"

    # compose.yamlが存在しない場合はスキップ
    [[ ! -f "${compose_file}" ]] && return 0

    # dockerコマンドが利用可能か確認
    command -v docker &> /dev/null || return 0

    # Docker daemonが起動しているか確認
    docker info &> /dev/null || return 0

    # tmuxcc-api と tmuxcc-api-postgresql16 の両方が起動しているか確認
    local api_running db_running
    api_running=$(docker ps --filter "name=tmuxcc-api" --filter "status=running" -q)
    db_running=$(docker ps --filter "name=tmuxcc-api-postgresql16" --filter "status=running" -q)

    if [[ -n "${api_running}" ]] && [[ -n "${db_running}" ]]; then
        return 0
    fi

    # バックグラウンドでdocker compose upを実行
    echo "[tmuxcc] Starting docker compose services..."
    (cd "${project_dir}" && docker compose up -d) &> /dev/null &
}

_tmuxcc_start_compose
