#!/bin/bash
set -e

# 仮想環境のアクティベート
if [ -f ".venv/bin/activate" ]; then
  source ".venv/bin/activate"
else
  echo "Warning: .venv/bin/activate not found. Assuming gemini is in PATH."
fi

# gemini コマンドの存在確認
if ! command -v gemini >/dev/null 2>&1; then
  echo "Error: 'gemini' command not found."
  echo "Please install or activate the environment that provides the 'gemini' CLI."
  exit 1
fi

# 環境変数のチェック
if [ -z "$PR_NUMBER" ] || [ -z "$COMMENT_BODY" ]; then
  echo "Error: Required environment variables (PR_NUMBER, COMMENT_BODY) are missing."
  exit 1
fi

CONTEXT_FILE=".github/workflows/context/review-analysis-prompt.md"

# プロンプトファイルの存在確認
if [ ! -f "$CONTEXT_FILE" ]; then
  echo "Error: Context file not found: $CONTEXT_FILE"
  exit 1
fi

# 一時ファイルのクリーンアップ設定
trap 'rm -f prompt.md response.md' EXIT

# プロンプトの生成 (envsubst で変数展開)
# 注意: COMMENT_BODY や DIFF_HUNK には改行や特殊文字が含まれる可能性があるため、
# 厳密にはここでの単純な envsubst はリスクがあるが、今回は簡易実装とする。
# 本番運用ではPythonスクリプト等で安全に置換することを推奨。
envsubst < "${CONTEXT_FILE}" > prompt.md

echo "--- Gemini Analysis Start ---"

# Gemini CLI を実行
# --yolo: ユーザー確認なしで実行 (CI/CD用)
cat prompt.md | gemini --yolo -m "gemini-3-flash-preview" > response.md

echo "--- Gemini Analysis End ---"

# GitHub CLI でコメントを投稿
if [ -f "response.md" ] && [ -s "response.md" ]; then
  echo "Posting comment to PR #${PR_NUMBER}..."
  gh pr comment "$PR_NUMBER" --body-file response.md
else
  echo "Error: Gemini produced empty response."
  exit 1
fi
