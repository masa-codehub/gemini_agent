#!/bin/bash
set -e

# ラベル情報の取得 (環境変数 ISSUE_LABELS を使用)
LABELS="${ISSUE_LABELS}"

echo "Processing Issue #${ISSUE_NUMBER}: ${ISSUE_TITLE}"
echo "Labels: ${LABELS}"

# コンテキストファイルの選択
CONTEXT_FILE=""

if [[ "$LABELS" == *"gemini:arch"* ]]; then
  CONTEXT_FILE=".github/workflows/context/arch-prompt.md"
  echo "Selected Skill: Architecture Drafting"
elif [[ "$LABELS" == *"gemini:spec"* ]]; then
  CONTEXT_FILE=".github/workflows/context/spec-prompt.md"
  echo "Selected Skill: Specification Drafting"
elif [[ "$LABELS" == *"gemini:tdd"* ]]; then
  CONTEXT_FILE=".github/workflows/context/tdd-prompt.md"
  echo "Selected Skill: TDD Implementation"
else
  echo "No matching gemini label found. Skipping execution."
  exit 0
fi

# 環境変数のエクスポート（envsubst用）
export ISSUE_NUMBER
export ISSUE_TITLE
export ISSUE_BODY

# コンテキストの置換と実行
# envsubst でテンプレート内の環境変数を展開して一時ファイルに保存
envsubst < "${CONTEXT_FILE}" > prompt.md

echo "--- Gemini Execution Start ---"
# geminiコマンドにプロンプトを渡し、実行させる
cat prompt.md | gemini --yolo
echo "--- Gemini Execution End ---"