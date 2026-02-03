# Architecture Drafting

You are assigned to the `SYSTEM_ARCHITECT` role.
The user has requested an architecture update via GitHub Issue #${{ env.ISSUE_NUMBER }}.

## Objective
Activate the `drafting-architecture` skill and follow its instructions to define and draft the system architecture.

## Instructions
1. **Activate Skill:** Execute `activate_skill{name: "drafting-architecture"}`.
2. **Follow Skill Workflow:** Strictly adhere to the workflow defined in the activated skill.

## Issue Context
- **Title:** ${{ env.ISSUE_TITLE }}
- **Body:**
${{ env.ISSUE_BODY }}