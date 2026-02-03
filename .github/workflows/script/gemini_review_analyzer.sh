#!/bin/bash
set -e

# 環境変数のチェック
if [ -z "$PR_NUMBER" ] || [ -z "$COMMENT_BODY" ]; then
  echo "Error: Required environment variables (PR_NUMBER, COMMENT_BODY) are missing."
  exit 1
fi

# タスクタイプの判定とプロンプトの選択
CONTEXT_FILE=""
if [[ "$PR_LABELS" == *"gemini:arch"* ]]; then
  TASK_TYPE="ARCH"
  CONTEXT_FILE=".github/workflows/context/review-arch-prompt.md"
elif [[ "$PR_LABELS" == *"gemini:spec"* ]]; then
  TASK_TYPE="SPEC"
  CONTEXT_FILE=".github/workflows/context/review-spec-prompt.md"
elif [[ "$PR_LABELS" == *"gemini:tdd"* ]]; then
  TASK_TYPE="TDD"
  CONTEXT_FILE=".github/workflows/context/review-tdd-prompt.md"
else
  echo "No matching gemini label found. Skipping execution."
  exit 0
fi
export TASK_TYPE

echo "Task Type: $TASK_TYPE"
echo "Selected Context: $CONTEXT_FILE"

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
