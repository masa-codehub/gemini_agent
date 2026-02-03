# 仕様書: Gemini Review Analyzer

## 1. 概要 (Overview)
GitHub Pull Request にレビューコメントが投稿された際、Gemini が自動的に内容を分析し、SSOT (Single Source of Truth) に基づいた適切な対応方針（修正、議論、説明）を提案するワークフロー。

## 2. ワークフロー詳細 (Workflow Details)

### トリガー
- イベント: `pull_request_review_comment`
- タイプ: `created`

### 処理フロー
1.  **環境初期化**: `run.sh` による実行環境（仮想環境、Gemini CLI）のセットアップ。
2.  **データ抽出**: ペイロードから以下の情報を抽出。
    - PR番号、コメントID、投稿者、本文
    - 対象ファイルパス、行番号、Diff Context
3.  **Gemini 分析**:
    - `review-arch/spec/tdd-prompt.md` テンプレートを使用（フェーズに応じて動的に選択）。
    - `gemini_review_analyzer.sh` スクリプト内で環境変数を展開。
    - `gemini-1.5-flash-latest` モデルで分析を実行。
4.  **結果投稿**:
    - 分析レポート（Markdown）を該当PRのコメントとして自動投稿。

## 3. コンポーネント定義 (Components)

### A. Workflow Definition (`.github/workflows/gemini-reviewer.yml`)
- Self-hosted Runner で実行。
- 必要な権限: `pull-requests: write`。

### B. Execution Script (`.github/workflows/script/gemini_review_analyzer.sh`)
- `gemini` CLI のラッパー。
- `mktemp` を用いた一時ファイル管理、`envsubst` による変数展開（ホワイトリスト）、`gh` CLI によるコメント投稿を担当。

### C. Prompt Template (`review-arch/spec/tdd-prompt.md`)
- 各フェーズ（Arch/Spec/TDD）に応じた個別プロンプト。
- Accept/Discuss/Explain の3分類ロジック。
- 出力フォーマット（Markdownレポート）の規定。

## 4. 検証基準 (Verification Criteria)
- **Happy Path:** PRにコメントすると、数分以内に "🤖 Gemini Review Analysis" から始まる返信が付くこと。
- **Error Handling:** 
    - `gemini`, `gh`, `envsubst` コマンド不在時のエラー検知。
    - APIエラーやレート制限時の例外処理。
    - 複数ラベル付与時の排他制御。

## 5. 実装手順と制約 (Implementation Steps & Constraints)
- **制限**: `gemini-reviewer` はPRコメントへの「提案」のみを行い、リポジトリ内のファイルを直接変更してはならない。
- **セキュリティ**: `envsubst` はホワイトリスト化された環境変数のみを展開する。
- **衝突防止**: `mktemp` を使用して、並列実行時のファイル競合を回避する。
