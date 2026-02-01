---
name: managing-pull-requests
description: Manages the lifecycle of GitHub Pull Requests, including creation with conventional titles and bodies, synchronization with base branches, and conflict resolution. Ensures changes are properly reviewed and verified before merging.
---

# GitHub Pull Request Management

このスキルは、GitHubのプルリクエスト作成からマージ前の検証までのプロセスを管理します。

## ワークフロー (Workflow)

以下の手順に従って、標準化されたプルリクエストを作成・管理します。

```markdown
PR作成進捗:
- [ ] 1. 変更のコミット確認 (Ensure Committed)
- [ ] 2. 既存PRの確認 (Check Duplicates)
- [ ] 3. Baseブランチとの同期 (Sync & Rebase)
- [ ] 4. PRの作成 (Create PR using Template)
```

### 1. 変更のコミット確認 (Ensure Committed)

**目的:** PRに含めるべき変更が確実に記録されていることを保証する。

- **Action:**
  - `git status` で未コミットの変更がないか確認する。
  - ある場合は `activate_skill{name: "github-commit"}` を呼び出してコミットする。

### 2. 既存PRの確認 (Check Duplicates)

**目的:** 重複したPRの作成を防ぐ。

- **Action:**
  - `list_pull_requests` を使用して、同じ目的のPRが既に存在しないか確認する。

### 3. Baseブランチとの同期 (Sync & Rebase)

**目的:** 統合時のコンフリクトを未然に防ぎ、履歴を綺麗に保つ。

- **Action:**
  - マージ先となる `base` ブランチ（通常は `main`）の最新状態を取り込む。
  - `run_shell_command{command: "git pull --rebase origin <base>"}`
  - **コンフリクト時:** 手動で解消し、解決してから次へ進む。

### 4. PRの作成 (Create PR)

**目的:** レビュワーに必要な情報を過不足なく伝えるPRを作成する。

- **Action:**
  - `assets/pull-request-template.md` を参照し、`title` と `body` を作成する。
  - **必須:** `head` (作業ブランチ) と `base` (マージ先) を明示的に指定する。
  - `create_pull_request` ツールを呼び出す。

## テンプレート

PRのタイトルと本文の作成には `assets/pull-request-template.md` を使用してください。
