#!/usr/bin/env python3
# pylint: disable=missing-module-docstring,missing-function-docstring

import sys
import json
import platform
from pathlib import Path


# Ref: https://code.claude.com/docs/ja/settings
def generate_settings(deny_rules_for_os):
    env = {
        # bashコマンドの実行時にプロジェクトのワーキングディレクトリを維持する設定です。
        # ex.
        # Step 1. pwd    # path/to/project
        # Step 2. cd dev # path/to/project/dev
        # Step 3. pwd    # path/to/project
        "CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR": "1",

        # 全ての非必須な外部通信を禁止する設定です。
        # デフォルトでは、Bedrock または Vertex を使用する場合、すべての非必須トラフィック（エラーレポート、テレメトリ、バグレポート機能を含む）を無効にします。
        # Ref: https://code.claude.com/docs/ja/data-usage
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",

        # 0: システムにインストールされた ripgrep を使用します。（デフォルト）
        # 1: Claude Code に組み込まれた ripgrep を使用します
        "USE_BUILTIN_RIPGREP": "1"
    }

    enabled_plugins = {
        "code-simplifier@claude-plugins-official": True,
    }

    additional_directories = [
        "~/src"
    ]

    allow_rules = [
        ("domain:*", ["WebFetch"]),

        ("awk:*", ["Bash"]),
        ("cat:*", ["Bash"]),
        ("cd:*", ["Bash"]),
        ("cp:*", ["Bash"]),
        ("date:*", ["Bash"]),
        ("diff:*", ["Bash"]),
        ("dig:*", ["Bash"]),
        ("echo:*", ["Bash"]),
        ("env:*", ["Bash"]),
        ("find:*", ["Bash"]),
        ("git:*", ["Bash"]),
        ("grep:*", ["Bash"]),
        ("head:*", ["Bash"]),
        ("history:*", ["Bash"]),
        ("kill:*", ["Bash"]),
        ("ls:*", ["Bash"]),
        ("lsof:*", ["Bash"]),
        ("mkdir:*", ["Bash"]),
        ("mv:*", ["Bash"]),
        ("netstat:*", ["Bash"]),
        ("nslookup:*", ["Bash"]),
        ("ping:*", ["Bash"]),
        ("ps:*", ["Bash"]),
        ("pwd:*", ["Bash"]),
        ("sed:*", ["Bash"]),
        ("tail:*", ["Bash"]),
        ("touch:*", ["Bash"]),
        ("wc:*", ["Bash"]),
        ("whoami:*", ["Bash"]),

        ("rg:*", ["Bash"]),

        # dev
        ("docker:*", ["Bash"]),
        ("gh:*", ["Bash"]),

        # Go
        ("go:*", ["Bash"]),
        ("gofmt:*", ["Bash"]),
        ("golint:*", ["Bash"]),
        ("golangci-lint:*", ["Bash"]),

        # Python
        ("python:*", ["Bash"]),
        ("python3:*", ["Bash"]),
        ("pip:*", ["Bash"]),
        ("uv:*", ["Bash"]),

        # Rust
        ("cargo:*", ["Bash"]),
        ("rustc:*", ["Bash"]),
        ("rustup:*", ["Bash"]),
        ("rustfmt:*", ["Bash"]),
        ("clippy:*", ["Bash"]),

        # JavaScript / TypeScript
        ("npm:*", ["Bash"]),
        ("yarn:*", ["Bash"]),
        ("pnpm:*", ["Bash"]),
        ("bun:*", ["Bash"]),
        ("node:*", ["Bash"]),
        ("deno:*", ["Bash"]),
        ("tsx:*", ["Bash"]),
        ("tsc:*", ["Bash"]),
        ("eslint:*", ["Bash"]),
        ("prettier:*", ["Bash"]),
        ("biome:*", ["Bash"]),
        ("esbuild:*", ["Bash"]),
        ("vitest:*", ["Bash"]),
        ("jest:*", ["Bash"]),
        ("webpack:*", ["Bash"]),
        ("vite:*", ["Bash"]),

        ("/usr/bin/**", ["Read"]),
        ("/usr/local/bin/**", ["Read"]),

        ("~/src/**", ["Read", "Edit", "Write"]),
    ]

    ask_rules = [
        ("ln:*", ["Bash"]),
        ("export:*", ["Bash"]),
        ("rsync:*", ["Bash"]),
        ("ssh:*", ["Bash"]),
        ("scp:*", ["Bash"]),

        # dev
        ("aws:*", ["Bash"]),
        ("gcloud:*", ["Bash"]),
        ("azure:*", ["Bash"]),
        ("vercel:*", ["Bash"]),
        ("kubectl:*", ["Bash"]),
        ("terraform:*", ["Bash"]),

        # DB
        ("mysql:*", ["Bash"]),
        ("psql:*", ["Bash"]),
    ]

    deny_rules = [
        # Bash
        ("sudo:*", ["Bash"]),
        ("rm -rf /", ["Bash"]),
        ("rm -rf /*", ["Bash"]),
        ("rm -rf ~/", ["Bash"]),
        ("rm -rf .git", ["Bash"]),
        (" > /dev/*", ["Bash"]),
        (" >> /dev/*", ["Bash"]),
        ("dd:*", ["Bash"]),
        ("mkfs:*", ["Bash"]),
        ("fdisk:*", ["Bash"]),
        ("curl:*", ["Bash"]),
        ("wget:*", ["Bash"]),
        ("mount:*", ["Bash"]),
        ("umount:*", ["Bash"]),
        ("chmod 777 /*", ["Bash"]),
        ("chown root:*", ["Bash"]),
        ("git reset:*", ["Bash"]),
        ("git rebase:*", ["Bash"]),
        ("git push --force:*", ["Bash"]),
        ("git push -f:*", ["Bash"]),

        # Rust
        ("cargo publish*", ["Bash"]),

        # JavaScript / TypeScript
        ("npm publish*", ["Bash"]),
        ("yarn publish*", ["Bash"]),
        ("pnpm publish*", ["Bash"]),
        ("bun publish*", ["Bash"]),
        ("deno publish*", ["Bash"]),
        ("npx:*", ["Bash"]),
        ("pnpx:*", ["Bash"]),
        (".next/**", ["Edit", "Write"]),
        ("node_modules/**", ["Edit", "Write"]),

        # Python
        ("__pycache__/**", ["Edit", "Write"]),

        # readonly
        (".git/**", ["Edit", "Write"]),
        ("dist/**", ["Edit", "Write"]),
        ("build/**", ["Edit", "Write"]),
        ("vendor/**", ["Edit", "Write"]),
        ("target/**", ["Edit", "Write"]),

        # secret
        ("~/.ssh/**", ["Read", "Edit", "Write"]),
        ("**/secrets/**", ["Read", "Edit", "Write"]),
        ("**/.env*", ["Read", "Edit", "Write"]),
    ]

    def convert_rules_to_formatted_list(rules):
        tool_order = ["WebFetch", "Bash", "Read", "Edit", "Write"]

        grouped_by_tool = {tool: [] for tool in tool_order}

        for pattern, tools in rules:
            for tool in tools:
                if tool in grouped_by_tool:
                    grouped_by_tool[tool].append(pattern)

        formatted_list = []
        for tool in tool_order:
            for pattern in grouped_by_tool[tool]:
                formatted_list.append(f"{tool}({pattern})")

        return formatted_list

    settings = {
        "env": env,
        "language": "Japanese",
        "enabledPlugins": enabled_plugins,
        "permissions": {
            "defaultMode": "acceptEdits",
            "additionalDirectories": additional_directories,
            "allow": convert_rules_to_formatted_list(allow_rules),
            "ask": convert_rules_to_formatted_list(ask_rules),
            "deny": convert_rules_to_formatted_list(deny_rules + deny_rules_for_os),
        }
    }

    return settings


def generate_settings_for_linux():
    deny_rules_for_linux = [
        # Linux system directories
        ("/etc/**", ["Edit", "Write"]),
        ("/usr/**", ["Edit", "Write"]),
        ("/var/**", ["Edit", "Write"]),
        ("/opt/**", ["Edit", "Write"]),
        ("/bin/**", ["Edit", "Write"]),
        ("/sbin/**", ["Edit", "Write"]),
        ("/lib/**", ["Edit", "Write"]),
        ("/lib64/**", ["Edit", "Write"]),
        ("/boot/**", ["Edit", "Write"]),
        ("/proc/**", ["Edit", "Write"]),
        ("/sys/**", ["Edit", "Write"]),
        ("/dev/**", ["Edit", "Write"]),
    ]

    return generate_settings(deny_rules_for_linux)


def generate_settings_for_macos():
    deny_rules_for_macos = [
        # MacOS system directories
        ("/System/**", ["Edit", "Write"]),
        ("/Library/**", ["Edit", "Write"]),
        ("/Applications/**", ["Edit", "Write"]),
        ("/usr/**", ["Edit", "Write"]),
        ("/bin/**", ["Edit", "Write"]),
        ("/sbin/**", ["Edit", "Write"]),
        ("/var/**", ["Edit", "Write"]),
        ("/etc/**", ["Edit", "Write"]),
        ("/private/**", ["Edit", "Write"]),
        ("/opt/**", ["Edit", "Write"]),
        ("/cores/**", ["Edit", "Write"]),
        ("/dev/**", ["Edit", "Write"]),
        ("/Volumes/**", ["Edit", "Write"]),
    ]

    return generate_settings(deny_rules_for_macos)


def main():
    os_type = platform.system()

    if os_type == "Darwin":
        settings = generate_settings_for_macos()
    elif os_type == "Linux":
        settings = generate_settings_for_linux()
    else:
        print(f"Error: Unsupported OS type: {os_type}")
        return 1

    script_dir = Path(__file__).parent
    output_path = script_dir / "settings.json"

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(settings, f, indent=4)
        f.write("\n")

    print(f"Generated {output_path} for {os_type}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
