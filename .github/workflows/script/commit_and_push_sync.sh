#!/bin/bash
set -e

DEST_DIR="${SYNC_DEST_DIR:-public-repo}"
cd "$DEST_DIR"

git config user.name "${GITHUB_USER:-github-actions[bot]}"
git config user.email "${GITHUB_EMAIL:-github-actions[bot]@users.noreply.github.com}"

git add .

# PRタイトルやブランチ名に送信元を含めるための変数
SOURCE_REPO="${GITHUB_REPOSITORY}"
SAFE_REPO_NAME=$(echo "${SOURCE_REPO}" | tr '/' '-')

if ! git diff --staged --quiet; then
  # テンプレート同期などの場合、他のリポジトリとの名前衝突を避けるためにプレフィックスをつける
  BRANCH_NAME="sync-${SAFE_REPO_NAME}-${RELEASE_TAG_NAME}"
  
  git checkout -b "$BRANCH_NAME"
  git commit -m "chore: sync release ${RELEASE_TAG_NAME} from ${SOURCE_REPO}"
  git push origin "$BRANCH_NAME"
  
  # GitHub CLIを使用してPRを作成
  gh pr create \
    --title "chore: sync release ${RELEASE_TAG_NAME} from ${SOURCE_REPO}" \
    --body "Automated synchronization of release ${RELEASE_TAG_NAME} from the development repository (${SOURCE_REPO})." \
    --head "$BRANCH_NAME" \
    --base main
fi

# SKIP_TAGが 'true' でない場合のみタグを打つ
if [ "${SKIP_TAG}" != "true" ]; then
  # タグの作成とプッシュは、安全のため main ブランチ上でのみ実施する
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  if [ "${CURRENT_BRANCH}" = "main" ]; then
    # 既存のタグを上書きしないように -f は使用しない
    if git rev-parse "${RELEASE_TAG_NAME}" >/dev/null 2>&1; then
      echo "Tag '${RELEASE_TAG_NAME}' already exists. Skipping tag creation."
    else
      git tag "${RELEASE_TAG_NAME}"
      git push origin "${RELEASE_TAG_NAME}"
    fi
  else
    echo "Current branch is '${CURRENT_BRANCH}', not 'main'. Skipping tag creation and push for ${RELEASE_TAG_NAME}."
  fi
else
  echo "SKIP_TAG is set to true. Skipping tag creation for this repository."
fi