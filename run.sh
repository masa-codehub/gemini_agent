#!/bin/bash
set -e

# GitHub CLIの認証設定
gh auth setup-git

# エージェント切り替え変更
# AGENT_ROLE は環境変数から渡される想定
bash .build/update_gemini_context.sh

# gemini-cliのインストール
npm install -g @google/gemini-cli@preview
gemini extensions install https://github.com/github/github-mcp-server --consent
