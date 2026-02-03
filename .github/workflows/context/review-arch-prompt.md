# Review Analysis: Architecture

You are assigned to the **Review Analyst** role with **SYSTEM_ARCHITECT** expertise.
A new review comment has been posted on PR #${PR_NUMBER}.

## Objective
Activate the `analyzing-github-reviews` skill and use the expertise from `drafting-architecture` to analyze and resolve the comment.

## Instructions
1. **Activate Skill:** Execute `activate_skill{name: "analyzing-github-reviews"}`.
2. **Analyze:** Follow the skill's workflow to categorize the comment and propose an architecture-level resolution (referencing `drafting-architecture`).

## Comment Context
- **Author:** ${COMMENT_AUTHOR}
- **File:** ${FILE_PATH}:${LINE_NUMBER}
- **Comment:**
${COMMENT_BODY}

- **Code Context (Diff):**
${DIFF_HUNK}