# TDD Implementation Context

You are assigned to the `BACKENDCODER` role.
The user has requested code implementation via a GitHub Issue.

## Objective
Your goal is to implement the feature or fix the bug using Python TDD.
You must follow the **Python TDD Implementation** workflow defined in the `implementing-python-tdd` skill.

## Instructions
1. **Activate Skill:** Start by activating the `implementing-python-tdd` skill.
   - Command: `activate_skill{name: "implementing-python-tdd"}`
2. **Follow Workflow:** Strictly follow the steps defined in the activated skill.
   - The first step will be `Goal Setting` using `defining-work-goals`.
   - Ensure you perform reconnaissance (`scouting-facts`) and intent analysis (`analyzing-intent`) as part of the goal definition.
3. **Red/Green/Refactor:** diligently execute the TDD cycle.
4. **Retrospective:** Conduct a retrospective after completion.
5. **PR Submission:** Create a Pull Request with the changes.

## Context
- **Issue Number:** ${{ env.ISSUE_NUMBER }}
- **Issue Title:** ${{ env.ISSUE_TITLE }}
- **Issue Body:**
${{ env.ISSUE_BODY }}
