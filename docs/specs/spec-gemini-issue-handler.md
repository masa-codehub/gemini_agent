# 仕様書: Gemini Issue Handler

## 1. 概要 (Overview)
GitHub Issue の作成またはラベル付与をトリガーとして、適切なエージェント・役割を割り当て、`gemini` CLI を通じて自動的に設計や実装のタスクを開始する自動化ロジック。

## 2. インプット (Input)
| 名前 | 型 | 説明 |
| :--- | :--- | :--- |
| `github.event.issue.labels` | List[String] | 付与されたラベルのリスト。 |
| `ISSUE_NUMBER` | Integer | 対象のIssue番号。 |
| `ISSUE_TITLE` | String | Issueのタイトル。 |
| `ISSUE_BODY` | String | Issueの本文。 |

## 3. アウトプット (Output)
| 型 | 説明 |
| :--- | :--- |
| `ExecutionResult` | Geminiエージェントによる成果物（コメント投稿、ファイル作成、またはPR作成）。 |

## 4. ロジック / フロー (Logic / Flow)

### 4.1 役割の決定 (Role Selection)
GitHub Actions (`gemini-handler.yml`) 内で、以下のラベルに基づいて `AGENT_ROLE` を決定する。

| ラベル | AGENT_ROLE | 優先度 |
| :--- | :--- | :--- |
| `gemini:arch` | `SYSTEM_ARCHITECT` | 1 |
| `gemini:spec` | `TECHNICAL_DESIGNER` | 2 |
| `gemini:tdd` | `BACKENDCODER` | 3 |

※ 複数ラベルが存在する場合の挙動は `gemini_implementer.sh` で制御される。

### 4.2 スキルの選択 (Skill Routing)
`gemini_implementer.sh` 内で、ラベルに応じてコンテキスト（プロンプトテンプレート）を選択する。

1.  ラベルを走査し、一致するスキルを特定する。
2.  一致したスキルが1つの場合: 該当するテンプレート（`context/*.md`）をロードする。
3.  一致したスキルが複数の場合: エラーを出力し終了する（排他制御）。
4.  一致するスキルがない場合: スキップして終了する。

### 4.3 プロンプトの生成と実行
1.  `envsubst` を用いて、テンプレート内の変数（`${ISSUE_NUMBER}`, `${ISSUE_TITLE}`, `${ISSUE_BODY}`）を実際の値で置換する。
2.  置換後のプロンプトを一時ファイル `prompt.md` に保存する。
3.  `gemini` CLI を呼び出し、`prompt.md` を標準入力から渡す。
    - 使用モデル: `gemini-3-flash-preview`
    - モード: `--yolo` (非対話自動実行)

## 5. エッジケースとエラーハンドリング (Edge Cases)
- **複数ラベル付与:** `MATCH_COUNT > 1` の場合、エラーメッセージを表示して非ゼロで終了する。
- **テンプレート不在:** 指定された `CONTEXT_FILE` が存在しない場合、エラーを表示して非ゼロで終了する。
- **環境未整備:** `.venv/bin/activate` が不在、または `gemini` コマンドが `PATH` にない場合、エラーを出力する。
- **空の本文:** Issueの本文が空であっても、`envsubst` は空文字として処理し、実行を継続する。

## 6. 検証基準 (Verification Criteria)
- **Happy Path:** `gemini:spec` ラベルを付けてIssueを開くと、`Selected Skill: Specification Drafting` がログに出力され、Geminiが起動すること。
- **Exclusion Path:** `gemini:arch` と `gemini:spec` を同時に付与すると、`Error: Multiple gemini labels detected.` で終了すること。
