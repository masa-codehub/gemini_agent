#!/bin/bash
set -e

# GitHub CLIの認証設定
export GITHUB_TOKEN="${GITHUB_MCP_PAT}"
gh auth setup-git

# 外部モジュールのインストール
# python3 -m pip install --upgrade pip  # runnerのOSとのマッチングでアップグレード出来ない
python3 -m pip install -e .[dev]

# pre-commitの設定
pre-commit install

# エージェント切り替え変更
# AGENT_ROLE は環境変数から渡される想定
bash .build/update_gemini_context.sh

# gemini-cliのインストール (GitHub Actions環境以外の場合のみ実行)
if [ "$GITHUB_ACTIONS" != "true" ]; then
    echo "Local environment detected. Installing gemini-cli and extensions..."
    npm install -g @google/gemini-cli@preview
    gemini extensions install https://github.com/github/github-mcp-server --consent
else
    echo "GitHub Actions environment detected. Skipping gemini-cli installation as it is assumed to be pre-installed."
fi
