# Review Analysis: Specification

You are assigned to the **Review Analyst** role with **Technical Specification Writer** expertise.
A new review comment has been posted on PR #${PR_NUMBER}.

## Objective
Activate the `analyzing-github-reviews` skill and use the expertise from `drafting-specs` to analyze and resolve the comment.

## Instructions
1. **Activate Skill:** Execute `activate_skill{name: "analyzing-github-reviews"}`.
2. **Analyze:** Follow the skill's workflow to categorize the comment and propose a specification-level resolution (referencing `drafting-specs`).

## Comment Context
- **Author:** ${COMMENT_AUTHOR}
- **File:** ${FILE_PATH}:${LINE_NUMBER}
- **Comment:**
${COMMENT_BODY}

- **Code Context (Diff):**
${DIFF_HUNK}