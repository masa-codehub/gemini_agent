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

### 4. Refactor: 品質向上と静的解析 (Make it Right)

**目的:** 「動くコード」を「維持可能なコード」へ昇華させる。

- **Action:**
  - **現状分析:** `assets/refactoring-analysis-template.md` を使用して、静的解析結果やコードの改善点を分析・列挙する。
    - 分析結果は標準出力に表示し、保存先指定があればファイルに保存する。
  - **改善実行:** 分析に基づき、優先度の高い項目から修正を行う。
    - **Static Analysis:** `pre-commit run --all-files` を実行し、自動修正を適用する。
    - **Structure:** `Type Safety`, `Readability`, `SSOT` の観点で手動リファクタリングを行う。
  - **再検証:** リファクタリング後もテストがGreenであることを確認する。
    - テスト失敗時は `references/debugging-workflow.md` を参照して効率的に修正する。

### 5. 最終検証と納品 (Final Audit & Deliver)

**目的:** 全体への影響がないことを確認し、変更を確定する。

- **Action:**
  - **全テスト実行:** `run_shell_command{command: "pytest"}` で回帰テストを行う。
  - **Pre-commit:** `run_shell_command{command: "pre-commit run --all-files"}` ですべてのフックを通過させる。
  - **完了:** 全てのチェックがGreenであればタスク完了とする。

## リファレンス

- **Linter設定:** `pyproject.toml` または `ruff.toml` を参照。
- **型チェック:** `mypy.ini` または `pyproject.toml` を参照。
- **コーディング規約:** `docs/guides/coding-guidelines.md` (存在する場合)
