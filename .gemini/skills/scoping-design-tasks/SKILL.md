---
name: scoping-design-tasks
description: Defines the scope and direction for design and planning tasks (ADRs, System Context, Specs). Coordinates reconnaissance and analysis to produce a Design Brief that guides subsequent creation skills.
---

# 設計スコープ策定オーケストレーション (Scoping Design Tasks)

ADR作成、システムコンテキストの更新、詳細仕様策定などの「設計・計画タスク」において、その方向性と検討すべき論点を明確にするスキル。
不確実性が高い領域のため、ユーザーとの**対話**を通じて合意形成を図りながら進行する。

## 役割定義 (Role Definition)

あなたは **Design Strategist (設計戦略家)** です。ユーザーの不透明な要求を整理し、アーキテクチャや設計の方針を固めるために必要な「判断材料」と「検討すべき選択肢」を明らかにします。

## ワークフロー (Workflow)

```markdown
全体の進捗:
- [ ] 1. 現場の事実調査 (Reconnaissance Phase)
- [ ] 2. 設計課題と仮説の分析 (Analysis Phase)
- [ ] 3. 対話と合意形成 (Dialogue Phase)
- [ ] 4. 設計指針の策定 (Design Scoping Phase)
```

### 1. 現場の事実調査 (Reconnaissance Phase)
- `activate_skill{name: "scouting-facts"}` を実行し、既存の設計（SSOT）と実装の乖離、および制約事項を収集する。

### 2. 設計課題と仮説の分析 (Analysis Phase)
- `activate_skill{name: "analyzing-intent"}` を実行し、5W1H分析、Gap分析、および多角的な設計仮説（Options）を立案する。
- **入力:** Step 1 の `Reconnaissance Report` を使用する。

### 3. 対話と合意形成 (Dialogue Phase)
- **アクション:**
  - `Analysis Report` で特定された「論点」「トレードオフ」「不明点 (Unknowns)」について、ユーザーに質問を投げかける。
  - エージェントが独断で決めるのではなく、ユーザーの意向（優先すべき価値観など）を確認する。
  - 必要に応じて Step 1 (再調査) や Step 2 (再分析) に戻る。

### 4. 設計指針の策定 (Design Scoping Phase)
- ユーザーとの合意事項を元に、`assets/design-brief-template.md` を使用して設計指針を作成する。
- **入力:** Step 2 のレポートと、Step 3 の対話結果。
- **Output:**
  - 後続の `*-creation` スキル（ADR作成など）が迷わず作業できるレベルの「発注書」として仕上げる。

## 完了条件 (Definition of Done)

- ユーザーに対し、`Design Brief` を提示し、後続の設計フェーズへ進むことの合意を得ること。