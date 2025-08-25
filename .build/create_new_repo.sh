#!/bin/bash

# エラーが発生した時点でスクリプトを停止する
set -e

# --- 1. 前提条件のチェック ---
if ! command -v git &> /dev/null; then
    echo "❌ エラー: gitがインストールされていません。"
    exit 1
fi

if ! command -v gh &> /dev/null; then
    echo "❌ エラー: GitHub CLI (gh) がインストールされていません。"
    echo "インストールしてください: https://cli.github.com/"
    exit 1
fi

# GitHub CLIの認証状態を確認し、必要であればログインを促す
echo "ℹ️ GitHub CLIの認証状態を確認しています..."
if ! gh auth status &> /dev/null; then
    echo "⚠️ GitHub CLIにログインしていません。ログインプロセスを開始します。"
    # 対話的なログインフローを開始
    if ! gh auth login; then
        echo "❌ エラー: GitHub CLIのログインに失敗しました。スクリプトを終了します。"
        exit 1
    fi
    echo "✅ GitHubへのログインに成功しました。"
fi

if [ ! -d ".git" ]; then
    echo "❌ エラー: このスクリプトはGitリポジトリのルートディレクトリで実行してください。"
    exit 1
fi

echo "✅ 前提条件のチェック完了"
echo "---"

# --- 2. リポジトリ名の検証 ---
echo "ℹ️ 環境変数と現在のリポジトリ設定を検証します..."

# 環境変数 REPO_NAME の存在チェック
if [ -z "$REPO_NAME" ]; then
    echo "❌ エラー: 環境変数 REPO_NAME が設定されていません。"
    echo "   例: export REPO_NAME=\"new-repository-name\""
    exit 1
fi
echo "  - 使用するリポジトリ名 (環境変数): $REPO_NAME"

# 現在のリポジトリ名を取得
CURRENT_REPO_URL=$(git remote get-url origin)
CURRENT_REPO_NAME=$(basename -s .git "$CURRENT_REPO_URL")
echo "  - 現在のリポジトリ名: $CURRENT_REPO_NAME"

# 現在のリポジトリ名と新しいリポジトリ名が同じ場合は終了
if [ "$CURRENT_REPO_NAME" == "$REPO_NAME" ]; then
    echo "✅ 現在のリポジトリ名は既に '$REPO_NAME' です。処理は不要なため正常に終了します。"
    exit 0
fi

echo "✅ 検証完了。リポジトリの作成処理を続行します。"

# --- 3. ユーザーからの情報入力 (公開設定) ---
read -p "リポジトリを公開しますか？ (public / private) [デフォルト: private]: " VISIBILITY
if [[ "$VISIBILITY" != "public" ]]; then
    VISIBILITY="private"
fi

echo "---"
echo "リポジトリ名: $REPO_NAME"
echo "公開設定: $VISIBILITY"
echo "---"


# --- 3. GitHub上でリポジトリを作成 ---
echo "⚙️  GitHubに新しいリポジトリ '$REPO_NAME' を作成しています..."
# gh repo createコマンドでリポジトリを作成
gh repo create "$REPO_NAME" --$VISIBILITY --description "ローカルリポジトリからクローンされました"

# 作成したリポジトリのSSH URLを取得
GITHUB_USER=$(gh api user --jq .login)
REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"
echo "✅ リポジトリを作成しました: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "---"

# --- 4. ローカルリポジトリの接続先を変更 ---
echo "↔️  ローカルリポジトリの接続先を新しいURLに変更しています..."
git remote set-url origin "$REPO_URL"
echo "✅ リモートURLを '$REPO_URL' に設定しました。"
echo "---"

# --- 5. 新しいリポジトリへプッシュ ---
echo "🚀 全てのブランチとタグを新しいリポジトリにプッシュしています...（--mirror）"
git push --mirror origin
echo "---"

echo "🎉🎉🎉 完了！ 🎉🎉🎉"
echo "新しいリポジトリに全てのデータが正常にプッシュされました。"
echo "ブラウザで確認してください: https://github.com/$GITHUB_USER/$REPO_NAME"