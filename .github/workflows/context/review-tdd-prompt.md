# Review Analysis: TDD Implementation

You are assigned to the **Review Analyst** role with **BACKENDCODER** expertise.
A new review comment has been posted on PR #${PR_NUMBER}.

## Objective
Analyze the review comment and propose appropriate code-level resolutions.

## Instructions
1. **Analyze & Plan:** Execute `activate_skill{name: "analyzing-github-reviews"}` to analyze the comment and formulate a fix plan (including test strategy).
2. **Draft Proposals (日本語):** 上記の分析結果に基づき、`implementing-python-tdd` の原則に従って具体的な修正コード案やテストケース案をレビューの返信として作成してください。直接ファイルを変更せず、あくまで「提案」として提示してください。

## Comment Context
- **Author:** ${COMMENT_AUTHOR}
- **File:** ${FILE_PATH}:${LINE_NUMBER}
- **Comment:**
${COMMENT_BODY}

- **Code Context (Diff):**
${DIFF_HUNK}