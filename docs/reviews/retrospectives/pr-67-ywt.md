# Retrospective (YWT): PR #67 Review Process

## 1. Y (やったこと - What we did)
- Refined review prompts (`review-*-prompt.md`) to be in English.
- Added explicit `activate_skill` syntax.
- Added a new "Step 3: Record & Finalize" to ensure analysis reports were saved.

## 2. W (わかったこと - What we learned)
- **Redundancy:** The `analyzing-github-reviews` skill already includes a persistence step (`recording-changes`). Adding it to the prompt created a duplicate instruction.
- **Reviewer Accuracy:** The AI reviewer (and potentially human reviewers) correctly identified this redundancy by comparing it with the skill definition (SSOT).
- **Prompt Simplicity:** For agentic workflows, simpler is often better. Over-specifying steps that are already internal to a called skill leads to confusion.

## 3. T (つぎにやること - What we will do next)
- **Immediate:** Remove Step 3 from all three prompt files in PR #67.
- **Process:** When composing prompts that call complex skills, review the skill's internal workflow first to avoid duplicating steps.
