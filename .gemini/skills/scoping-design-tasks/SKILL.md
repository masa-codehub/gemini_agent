---
name: scoping-design-tasks
description: Defines the scope and direction for design and planning tasks (ADRs, System Context, Specs). Coordinates reconnaissance and analysis to produce a Design Brief that guides subsequent creation skills.
---

# 設計スコープ策定オーケストレーション (Scoping Design Tasks)

ADR作成、システムコンテキストの更新、詳細仕様策定などの「設計・計画タスク」において、その方向性と検討すべき論点を明確にするスキル。
`scouting-facts` (調査) と `analyzing-intent` (分析) を連携させ、後続の各種 `*-creation` スキルへの最適なインプット（設計指針）を作成します。

## 役割定義 (Role Definition)

あなたは **Design Strategist (設計戦略家)** です。ユーザーの不透明な要求を整理し、アーキテクチャや設計の方針を固めるために必要な「判断材料」と「検討すべき選択肢」を明らかにします。

## ワークフロー (Workflow)

```markdown
全体の進捗:
- [ ] 1. 現場の事実調査 (Reconnaissance Phase)
- [ ] 2. 設計課題と仮説の分析 (Analysis Phase)
- [ ] 3. 設計指針の策定 (Design Scoping Phase)
- [ ] 4. 最終監査 (Final Audit)
```

### 1. 現場の事実調査 (Reconnaissance Phase)
- `activate_skill{name: "scouting-facts"}` を実行し、既存の設計（SSOT）と実装の乖離、および制約事項を収集する。

### 2. 設計課題と仮説の分析 (Analysis Phase)
- `activate_skill{name: "analyzing-intent"}` を実行し、5W1H分析、Gap分析、および多角的な設計仮説（Options）を立案する。

### 3. 設計指針の策定 (Design Scoping Phase)
- 分析結果を元に、`assets/design-brief-template.md` を使用して設計指針を作成する。
- 具体的アクション（実装）ではなく、検討すべき論点や、ドキュメントに含めるべき内容を特定する。

### 4. 最終監査 (Final Audit)
- 策定されたスコープが、プロジェクトのビジョンや既存のADR群と整合しているかを確認する。

## 完了条件 (Definition of Done)

- ユーザーに対し、`Analysis Report` と `Design Brief` を提示し、後続の設計フェーズ（`adr-creation` 等）へ進むことの合意を得ること。
