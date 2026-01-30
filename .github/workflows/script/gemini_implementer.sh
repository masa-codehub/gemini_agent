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
  echo -e "
---
# Current Context
"
  cat current_issue.md
} | gemini --yolo -m "gemini-3-flash-preview" > response.md

# 2回目: 自己修正・改善 (テストのためコメントアウト)
# echo "--- Phase 2: Refinement 1 ---"
# {
#   cat .github/workflows/context/architecture-drafting.md
#   echo -e "
---
# Current Context
"
#   cat current_issue.md
#   echo -e "
---
# Previous Response
"
#   cat response.md
# } | gemini --yolo -m "gemini-3-flash-preview" > response_tmp.md
# mv response_tmp.md response.md

# 3回目: 最終調整 (テストのためコメントアウト)
# echo "--- Phase 3: Final Refinement ---"
# {
#   cat .github/workflows/context/architecture-drafting.md
#   echo -e "
---
# Current Context
"
#   cat current_issue.md
#   echo -e "
---
# Previous Response
"
#   cat response.md
# } | gemini --yolo -m "gemini-3-flash-preview" > response_tmp.md
# mv response_tmp.md response.md

# PR作成指示書とこれまでの履歴を渡して、GeminiにPR作成を任せる
echo "--- Phase 4: PR Creation ---"
{
  cat .github/workflows/context/pr-creation.md
  echo -e "
---
# Original Issue
"
  cat current_issue.md
  echo -e "
---
# Final Implementation Result
"
  cat response.md
} | gemini --yolo -m "gemini-3-flash-preview"
