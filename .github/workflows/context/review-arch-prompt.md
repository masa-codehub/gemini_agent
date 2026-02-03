# Review Analysis: Architecture

You are assigned to the **Review Analyst** role with **SYSTEM_ARCHITECT** expertise.
A new review comment has been posted on PR #${PR_NUMBER}.

## Objective
Analyze the review comment and apply the necessary architectural fixes.

## Instructions
1. **Analyze & Plan:** Execute `activate_skill{name: "analyzing-github-reviews"}` to analyze the comment and formulate a fix plan.
2. **Execute Fix:** If any comments are categorized as `Accept`, execute `activate_skill{name: "drafting-architecture"}` to implement the architectural changes according to the plan.

## Comment Context
- **Author:** ${COMMENT_AUTHOR}
- **File:** ${FILE_PATH}:${LINE_NUMBER}
- **Comment:**
${COMMENT_BODY}

- **Code Context (Diff):**
${DIFF_HUNK}