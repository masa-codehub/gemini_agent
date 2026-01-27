---
name: github-branch-strategy
description: Replaces the work of prescribing and adhering to branch definitions and operational rules (Git Flow) in the project. Typical use cases: (1) Identifying and updating the Base Branch that serves as the development starting point, (2) Creating new feature branches using naming conventions (type/subject), (3) Enforcing branch protection rules such as prohibiting direct commits to the main branch.
---

# GitHub Branch Strategy

プロジェクトにおけるブランチの定義と運用ルール（Git Flow）を規定する。
他のGit関連スキル（checkout, commit, pull-request）はこの戦略に従う。

## ブランチの定義 (Definitions)

### 1. Base Branch (統合元/マージ先)

- **役割:** 開発の起点となり、最終的な統合先となるブランチ。
- **決定ロジック:**
  1. **明示的な指定:** ユーザーが指定した場合はそのブランチ。
  2. **デフォルト:** 指定がない場合、`main` または `master`。

### 2. Feature Branch (作業ブランチ)

- **役割:** 特定のタスク、機能追加、バグ修正を行うための短命なブランチ。
- **決定ロジック:**
  1. **明示的な指定:** ユーザーが指定した場合はそのブランチ。
  2. **自動生成:** 指定がない場合、以下の命名規則で新規作成する。
     - 規則: `<type>/<subject>`
     - **Type の例:**
       - `feat`: 新機能の追加
       - `fix`: バグ修正
       - `docs`: ドキュメントの変更
       - `refactor`: リファクタリング
       - `chore`: その他保守
     - **Subject の例:** (英語推奨、ハイフン繋ぎ)
       - `add-user-registration`
       - `fix-login-auth-bug`
       - `update-readme`
     - **例:** `feat/add-user-registration`

## 作業手順 (Procedure)

1. **ベースブランチの最新化 (Sync Base Branch):**
   - 開発の起点となるベースブランチ（通常は `main` または `master`）に切り替え、リモートの最新状態を同期する。
   - コマンド: `git checkout <base_branch> && git pull origin <base_branch>`

2. **ベースブランチの統合 (Integrate Base into Feature):**
   - 既存の `Feature Branch` で作業を再開する場合は、ベースブランチの最新変更をそのブランチに取り込む（マージまたはリベース）。
   - コマンド例: `git merge <base_branch>` または `git rebase <base_branch>`

3. **作業ブランチへの切り替え (Switch to Feature Branch):**
   - 新規作成、または既存の作業ブランチに切り替える。
   - 新規作成時の命名規則: `<type>/issue-<Issue番号>-<subject>`
   - コマンド: `git checkout -b <feature_branch>` または `git checkout <feature_branch>`

## 運用ルール (Rules)

1. **保護 (Protection):**
   `Base Branch` (main/master) への直接コミットは禁止。必ず `Feature Branch` を介する。
