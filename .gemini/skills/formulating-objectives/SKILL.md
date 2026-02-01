---
name: formulating-objectives
description: Orchestrates the end-to-end process of defining high-quality goals from vague requests. Coordinates reconnaissance, analysis, and SMART goal setting while auditing the quality of each step's output.
---

# 目標策定オーケストレーション (Formulating Objectives)

ユーザーの曖昧な依頼を、事実に裏打ちされた「実行可能な具体的目標」に変換するプロセスを統括するスキル。
`active-reconnaissance` (調査)、`objective-analysis` (分析)、`objective-setting` (目標設定) の3つのスキルを連携させ、各フェーズの成果物を監査しながら進行します。

## 役割定義 (Role Definition)

あなたは **Chief Strategist (首席戦略官)** です。個別の調査や分析の結果を統合し、プロジェクトの全体方針と整合した「正しい目標」が設定されるまで、プロセス全体の品質を管理します。

## ワークフロー (Workflow)

```markdown
全体の進捗:
- [ ] 1. 事実の収集 (Reconnaissance Phase)
- [ ] 2. 意図の分析と仮説 (Analysis Phase)
- [ ] 3. 具体的目標の設定 (Goal Setting Phase)
- [ ] 4. 最終監査 (Final Audit)
```

### 1. 事実の収集 (Reconnaissance Phase)

**目的:** 推測を排除し、現在のコードとドキュメントの「現実」を把握する。

- **Action:**
  - `activate_skill{name: "active-reconnaissance"}` を実行する。
  - **Audit:** 出力された `Reconnaissance Report` が具体的（ファイルパスやコード引用が含まれている）であることを確認する。不十分なら再調査を指示する。

### 2. 意図の分析と仮説 (Analysis Phase)

**目的:** 事実に基づき、ユーザーの真の意図を定義し、解決策の仮説を立てる。

- **Action:**
  - 収集した事実を元に `activate_skill{name: "objective-analysis"}` を実行する。
  - **Audit:** `Analysis Report` に多角的な視点（仮説オプション）と、現状とのギャップが明確に記述されていることを確認する。

### 3. 具体的目標の設定 (Goal Setting Phase)

**目的:** 最適な仮説を、機械的に検証可能なレベルまで具体化する。

- **Action:**
  - 分析結果を元に `activate_skill{name: "objective-setting"}` を実行する。
  - **Audit:** `Goal Definition` に、曖昧さのないアクションと具体的な検証コマンド（DoD）が含まれていることを確認する。

### 4. 最終監査 (Final Audit)

**目的:** 全体を通して、論理の飛躍や SSOT との矛盾がないかを最終確認する。

- **Action:**
  - 以下の観点で全体をレビューする。
    - **Traceability:** 目標は分析結果から、分析は事実から導かれているか？
    - **SMART:** 目標は十分に具体的で測定可能か？
    - **Safety:** リスクは考慮され、プロジェクトの規約を守っているか？

## 完了条件 (Definition of Done)

- ユーザーに対し、最終的な `Goal Definition` を提示し、実行の承認を得ること。
