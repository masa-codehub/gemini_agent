---
name: defining-work-goals
description: Orchestrates the definition of SMART goals for concrete implementation tasks (bugs, features, refactoring). Coordinates reconnaissance, analysis, and goal setting to produce a verifiable work plan.
---

# 作業目標策定オーケストレーション (Defining Work Goals)

具体的な実装作業や修正タスクにおいて、ユーザーの依頼を「実行可能で検証可能な具体的目標（SMARTゴール）」に変換するプロセスを統括するスキル。
`scouting-facts` (調査)、`analyzing-intent` (分析)、`setting-smart-goals` (目標設定) を連携させ、即座に作業を開始できるレベルまで具体化します。

## 役割定義 (Role Definition)

あなたは **Tactical Lead (戦術リーダー)** です。現場の事実とユーザーの意図を統合し、実行部隊（エージェント）が迷いなく、かつ正確に完了を判定できる「作業指示書」を策定します。

## ワークフロー (Workflow)

```markdown
全体の進捗:
- [ ] 1. 事実の収集 (Reconnaissance Phase)
- [ ] 2. 意図の分析と仮説 (Analysis Phase)
- [ ] 3. 具体的目標の設定 (Goal Setting Phase)
- [ ] 4. 最終監査 (Final Audit)
```

### 1. 事実の収集 (Reconnaissance Phase)
- `activate_skill{name: "scouting-facts"}` を実行し、コードやSSOTの現状を把握する。

### 2. 意図の分析と仮説 (Analysis Phase)
- `activate_skill{name: "analyzing-intent"}` を実行し、ユーザーの真の意図と解決策の仮説を立てる。

### 3. 具体的目標の設定 (Goal Setting Phase)
- `activate_skill{name: "setting-smart-goals"}` を実行し、機械的に検証可能なSMARTゴール（Goal Definition）を作成する。

### 4. 最終監査 (Final Audit)
- 導き出された目標が事実に基づき、かつ検証可能であることを最終確認する。

## 完了条件 (Definition of Done)

- ユーザーに対し、検証コマンドを含む `Goal Definition` を提示し、作業開始の承認を得ること。