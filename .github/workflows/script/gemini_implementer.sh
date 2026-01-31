#!/bin/bash

echo "Processing Issue #${ISSUE_NUMBER}: $ISSUE_TITLE"

# Issueの内容を一時ファイルに保存 (パイプ入力用)
echo -e "# Issue Info

Title: $ISSUE_TITLE

$ISSUE_BODY" > current_issue.md

# 0回目: ブランチ戦略の決定と切り替え
echo "--- Phase 0: Branch Strategy & Checkout ---"
BRANCH_COMMAND=$( {
  cat .github/workflows/context/branch-strategy.md
  cat current_issue.md
  echo "指示の内容を宣言して。"
} | gemini --yolo -m "gemini-3-flash-preview")

# 現在のブランチがmainのままの場合は終了
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" = "main" ]; then
  echo "⚠️ 現在のブランチが 'main' のままです。ブランチ戦略に従って新しいブランチを作成してください。"
  exit 1
fi

# 1回目: 初期実装
echo "--- Phase 1: Initial Implementation ---"
{
  cat .github/workflows/context/architecture-drafting.md
  cat current_issue.md
} | gemini --yolo -m "gemini-3-flash-preview" > response.md

# PR作成指示書とこれまでの履歴を渡して、GeminiにPR作成を任せる
echo "--- Phase 4: PR Creation ---"
{
  cat .github/workflows/context/pr-creation.md
  cat response.md
} | gemini --yolo -m "gemini-3-flash-preview"
