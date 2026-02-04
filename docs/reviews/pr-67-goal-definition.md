# Goal Definition: Remove Redundant Step 3

## 1. Goal (Objective)
Remove the redundant "Step 3: Record & Finalize" from the review context prompt files to align with the `analyzing-github-reviews` skill's internal workflow.

## 2. SMART Criteria
- **Specific:** Target `.github/workflows/context/review-arch-prompt.md`, `review-spec-prompt.md`, and `review-tdd-prompt.md`. Remove the lines defining Step 3.
- **Measurable:** The files should have only 2 steps (Analyze, Draft).
- **Achievable:** Simple text deletion.
- **Relevant:** Improves clarity and removes conflicting/redundant instructions for the agent.
- **Time-bound:** Immediate (within PR #67).

## 3. DoD (Definition of Done)
- Step 3 is removed from all 3 files.
- No other changes to the file content.
