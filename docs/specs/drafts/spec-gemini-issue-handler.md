# 仕様書: Gemini Issue Handler

## 1. 概要 (Overview)
`Gemini Issue Handler` は、GitHub Issue の作成またはラベル付与をトリガーとして、適切な Gemini エージェント（SYSTEM_ARCHITECT, TECHNICAL_DESIGNER, BACKENDCODER）を自動起動し、設計や実装のタスクを自律的に実行させるための自動化コンポーネントである。

## 2. ワークフロー詳細 (Workflow Details)

### トリガー
- イベント: `issues`
- タイプ: `opened`, `labeled`
- 条件: 以下のいずれかのラベルが含まれていること
    - `gemini:arch`
    - `gemini:spec`
    - `gemini:tdd`

### 処理フロー
1.  **環境初期化**: `run.sh` により、プロジェクトが必要とする依存関係および Gemini CLI 環境をセットアップする。
2.  **エージェント・プロンプト選択**: 
    - `gemini:arch` -> Role: `SYSTEM_ARCHITECT`, Template: `arch-prompt.md`
    - `gemini:spec` -> Role: `TECHNICAL_DESIGNER`, Template: `spec-prompt.md`
    - `gemini:tdd` -> Role: `BACKENDCODER`, Template: `tdd-prompt.md`
3.  **変数展開**: `envsubst` を使用し、Issue のタイトル、本文、番号を選択されたテンプレートに埋め込む。
4.  **実行**: `gemini` CLI を `--yolo` モードで実行し、モデル（`gemini-3-flash-preview`）にプロンプトを渡す。

## 3. 入力定義 (Input)
| 名称 | 型 | 内容 |
| :--- | :--- | :--- |
| `ISSUE_NUMBER` | Integer | 対象 Issue の番号 |
| `ISSUE_TITLE` | String | 対象 Issue のタイトル |
| `ISSUE_BODY` | String | 対象 Issue の本文 |
| `ISSUE_LABELS` | String (CSV) | 対象 Issue に付与されている全ラベル名 |

## 4. コンポーネント定義 (Components)

### A. GitHub Actions Workflow (`.github/workflows/gemini-handler.yml`)
- 権限: `contents: write`, `issues: write`, `pull-requests: write`
- 実行環境: `self-hosted`

### B. 実装スクリプト (`.github/workflows/script/gemini_implementer.sh`)
- ラベル判定ロジックと `envsubst` によるプロンプト生成を担当。
- 複数ラベルが付与されている場合は、排他制御によりエラー終了させる。

## 5. 検証基準 (Verification Criteria)
- **Happy Path:**
    - `gemini:spec` ラベルが付与された Issue が作成されると、`TECHNICAL_DESIGNER` ロールのエージェントが起動し、ログに `Selected Skill: Specification Drafting` が出力されること。
- **Error Handling:**
    - `gemini:arch` と `gemini:spec` の両方が付与された場合、"Multiple gemini labels detected" とエラー出力して終了すること。
    - 該当するラベルがない場合、"No matching gemini label found" と出力して正常終了（スキップ）すること。
    - コンテキストファイル（`*-prompt.md`）が存在しない場合、エラー終了すること。

## 6. 実装手順と制約 (Implementation Steps & Constraints)
- **制約**: `gemini` CLI は必ず仮想環境（`.venv`）内または PATH が通った状態で実行される必要がある。
- **セキュリティ**: `envsubst` に渡す変数は `$ISSUE_NUMBER`, `$ISSUE_TITLE`, `$ISSUE_BODY` に限定し、任意の環境変数へのアクセスを制限する。
