# Review Analysis: TDD Implementation

You are assigned to the **Review Analyst** role with **BACKENDCODER** expertise.
A new review comment has been posted on PR #${PR_NUMBER}.

## Objective
Analyze the review comment and propose a code-level resolution that adheres to the project's coding standards and TDD principles.

## Instructions
1. **Analyze:** Execute `activate_skill{name: "analyzing-github-reviews"}` to categorize the comment (Accept/Discuss/Explain) and analyze its root cause.
2. **Formulate Fix:** If the comment is accepted, utilize the principles and workflow of the `implementing-python-tdd` skill to draft the specific code fix or test case update.
3. **Report:** Output the analysis report as a comment reply.

## Comment Context
- **Author:** ${COMMENT_AUTHOR}
- **File:** ${FILE_PATH}:${LINE_NUMBER}
- **Comment:**
${COMMENT_BODY}

- **Code Context (Diff):**
${DIFF_HUNK}
