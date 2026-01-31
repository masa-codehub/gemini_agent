---
name: tdd-python-drafting
description: Executes the complete TDD cycle (Red/Green/Refactor) for Python projects. Handles test creation, implementation, and code quality assurance (linting, type checking, refactoring) in a single integrated workflow.
---

# Python TDD Implementation (Red/Green/Refactor)

このスキルは、詳細仕様書（Spec）と実装計画（Plan）に基づき、**Red/Green/Refactor の完全なTDDサイクル**を実行します。
実装（Drafting）だけでなく、品質検証（Verification）とリファクタリング（Refactoring）を統合し、コミット可能な高品質コードを生成します。

## ワークフロー (Workflow)

以下のチェックリストに従って、品質の高いPythonコードを実装してください。

```markdown
TDDサイクル進捗:

- [ ] 1. 準備 (Preparation & Context Load)
- [ ] 2. Red: テストの作成と失敗確認 (Write Fail Test)
- [ ] 3. Green: 最小限の実装とパス確認 (Make it Work)
- [ ] 4. Refactor: 品質向上と静的解析 (Make it Right)
- [ ] 5. 最終検証と納品 (Final Audit & Deliver)
```

### 1. 準備 (Preparation & Context Load)

**目的:** 実装に必要なコンテキストをロードし、方針を明確にする。

- **Action:**
  - 関連する仕様書 (`docs/specs/*.md`) と実装計画 (`docs/implementation/plans/*.md`) を読み込む。
  - **Mocking Strategy:** `unittest.mock` や `pytest-mock` の使用方針を確認する。
  - **Type Definitions:** 使用すべき共通型 (`typing`, `pydantic` 等) を確認する。

### 2. Red: テストの作成と失敗確認 (Write Fail Test)

**目的:** 要求仕様を検証可能なテストコードとして定義する。

- **Action:**
  - `tests/` 配下に適切なテストファイルを作成/更新する。
  - **Happy Path (正常系)** と **Edge Cases (異常系)** のテストケースを記述する。
  - **検証:** `pytest` を実行し、**期待通りに失敗（Red）** することを確認する。
    - コマンド: `run_shell_command{command: "pytest <test_file_path>"}`

### 3. Green: 最小限の実装とパス確認 (Make it Work)

**目的:** テストをパスさせるための「動くコード」を最短で作る。

- **Action:**
  - `src/` 配下にプロダクトコードを作成/更新する。
  - **型ヒント（Type Hints）** を必須とし、ロジックを実装する。
  - **検証:** `pytest` を実行し、**全てパス（Green）** することを確認する。
    - コマンド: `run_shell_command{command: "pytest <test_file_path>"}`

### 4. Refactor: 構造改善と静的解析 (Make it Right)

**目的:** 「動くコード」を「標準に準拠したコード」へ整理する。

- **Action:**
  - **Static Analysis:** `pre-commit run --all-files` を実行し、自動修正を適用する。
  - **Cleanup:** 不要なコメントやデバッグコードを削除し、型ヒントを整理する。
  - **再検証:** 修正後もテストがGreenであることを確認する。
    - テスト失敗時は `references/debugging-workflow.md` を参照して修正する。

### 5. 品質アセスメントと改善提案 (Quality Assessment & Proposals)

**目的:** 実装結果を深く分析し、さらなる品質向上案を提示する。

- **Action:**
  - **分析:** `assets/refactoring-analysis-template.md` を使用して、実装されたコードを多角的に分析する（Pythonicさ、設計の整合性、複雑度等）。
  - **提案:** 分析結果に基づき、さらなる改善点や将来的なリファクタリング案を列挙する。
  - **出力:** 分析と提案の結果を必ず標準出力に表示する。指定があればファイルに保存する。
  - **完了:** 自己レビュー項目を全てパスし、納品可能な品質であることを確認してタスク完了とする。

## リファレンス

- **Linter設定:** `pyproject.toml` または `ruff.toml` を参照。
- **型チェック:** `mypy.ini` または `pyproject.toml` を参照。
- **コーディング規約:** `docs/guides/coding-guidelines.md` (存在する場合)
