# PR Creation Instructions

あなたは開発担当者です。これまでの作業内容に基づき、変更をブランチに記録した上で Pull Request (PR) を作成してください。

## 指示

1. **ブランチの作成と切り替え (Checkout):**
   Issue番号に基づき、新しい作業ブランチを作成して切り替えてください。
   例: `git checkout -b feature/issue-<Issue番号>`

2. **変更のコミット (Commit):**
   未コミットの変更（作成されたドキュメント等）をすべてステージングし、コミットしてください。
   `git add . && git commit -m "docs: architecture drafting for issue #<Issue番号>"`

3. **Push:**
   作成したブランチをリモートリポジトリへ Push してください。

4. **新規作成 (Creation):**
   `create_pull_request` または `gh pr create` を実行して PR を作成してください。
   **`head` (作業ブランチ) と `base` (ベースブランチ) をIssueから読み取り、必ず明示的に指定すること。**

**PR Title テンプレート:**

```markdown
<type>(<scope>): <subject>
```

**PR Body テンプレート:**

```markdown
## 目的 (Goal)

<!-- なぜこの変更が必要か（背景とアウトカム） -->

## 変更の概要 (Summary)

<!-- 何をどのように変更したか -->

## 関連Issue (References)

Closes #<Issue番号>

## 検証方法 (Verification)

<!-- 実施したテストや動作確認の手順と結果（ログ等） -->

- [ ] Unit Test:
- [ ] Manual Check:
```
