#!/bin/bash
set -e

echo "=== Environment Setup ==="

# ★ 追加設定: uv の暴走（リソース食いつぶし）を防ぐ
# 並列数を 4 程度に制限（デフォルトはCPU全開なので、Dockerだと落ちやすい）
export UV_CONCURRENT_DOWNLOADS=4
export UV_CONCURRENT_BUILDS=2
export UV_CONCURRENT_INSTALLS=4

# ★ 追加設定: 警告が出ていたハードリンク問題を明示的に解決
export UV_LINK_MODE=copy

# 1. 依存関係の同期
if [ -f "pyproject.toml" ]; then
    echo "Syncing dependencies..."
    # --all-extras: dev依存なども含めて全部入れる
    uv sync --all-extras
fi

# 2. pre-commit のインストール
if [ -d ".git" ]; then
    echo "Installing pre-commit hooks..."
    uv run pre-commit install
fi

echo "=== Setup Complete ==="

# コンテキスト更新など
if [ -f ".build/update_gemini_context.sh" ]; then
    bash .build/update_gemini_context.sh
fi

source .venv/bin/activate