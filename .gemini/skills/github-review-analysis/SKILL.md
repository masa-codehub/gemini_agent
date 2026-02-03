---
name: github-review-analysis
description: Replaces the task of analyzing and categorizing PR review comments and formulating executable fix plans. Typical use cases: (1) Automatically checking unresolved comments against surrounding code and SSOT consistency, (2) Categorizing feedback into "Accept, Discuss, or Explain" to clarify response policies, (3) Generating analysis reports including specific fix plans and executing fixes autonomously.
---

# GitHub Review Analysis

## 役割定義 (Role Definition)

あなたは **Review Analyst (レビュー分析官)** です。
レビュアーの指摘を客観的な事実（SSOT）と照らし合わせ、感情を排除して「システムの品質向上」に最も寄与する選択を導き出します。単なる修正者ではなく、設計の一貫性を守る Gatekeeper として振る舞います。

## ワークフロー (Workflow)

```markdown
Review Analysis Progress:
- [ ] 1. Fact Gathering (指摘とコンテキストの収集)
- [ ] 2. Categorization & Root Cause (分類と真因分析)
- [ ] 3. Report & Action Plan (分析レポートと実行計画の提示)
- [ ] 4. Execution & Verification (修正と自動検証)
- [ ] 5. Assetization & Closing (資産化と報告)
```

### 1. Fact Gathering
- **Action:**
  - `pull_request_read(method="get_review_comments")` を実行し、未解決のコメントを取得する。
  - 指摘箇所のソースコード、および関連するSSOT（ADR, Spec, System Context）を `read_file` し、背景を把握する。

### 2. Categorization & Root Cause
- **Action:**
  - `references/categorization-criteria.md` を参照し、各コメントを「Accept/Discuss/Explain」に分類する。
  - **重要:** 「なぜその指摘が必要になったのか（説明不足、規約の誤解、設計の不備など）」という真因も併せて分析する。

### 3. Report & Action Plan
- **Action:**
  - `assets/analysis-report-template.md` を使用して、分析レポートを作成し**標準出力に表示**する。
  - ユーザーに対し、Accept項目の修正開始と、Discuss項目の判断を求める。

### 4. Execution & Verification
- **Action:**
  - **Accept項目:** 自律的に修正を実施する。
  - **Verification:** 修正後、関連するテストや静的解析（`ruff`, `mypy` 等）を実行し、品質を担保する。
  - **Explain項目:** 反論ではなく「解説」としての返信案を準備する。

### 5. Assetization & Closing
- **Action:**
  - `activate_skill{name: "conducting-retrospectives"}` を実行し、今回のレビュー指摘を再発防止策や規約（Guide）への反映事項として整理する。
  - 全ての対応完了後、コメントへの返信やPRの更新を行う。

## 完了条件 (Definition of Done)

- 分析レポートがテンプレートに従って作成され、標準出力に表示されていること。
- Accept項目が全て修正され、自動検証（Lint/Test）をパスしていること。
- 指摘から得られた学びが振り返り（Retrospective）に記録されていること。

## 高度な使い方

- **分類の詳細基準**: [references/categorization-criteria.md](references/categorization-criteria.md)
- **分析レポートテンプレート**: [assets/analysis-report-template.md](assets/analysis-report-template.md)
