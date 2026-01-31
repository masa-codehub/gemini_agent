# リファクタリング分析レポート: [Title]

## 1. 現状分析 (Current State Analysis)

### A. Static Analysis Findings
*(Run `pre-commit run --all-files` and paste key errors/warnings here)*
- [ ] Linter (Ruff):
- [ ] Type Checker (Mypy):

### B. Code Smell Detection
*(Identify non-Pythonic patterns, duplication, or complexity)*
- [ ] **Complexity:** (e.g., deeply nested loops, functions > 20 lines)
- [ ] **Duplication:** (e.g., repeated logic in multiple functions)
- [ ] **Naming:** (e.g., unclear variable names, non-standard casing)

### C. Gap Analysis (vs SSOT/Clean Architecture)
- [ ] **Responsibility:** (e.g., UseCase logic leaking into Controller)
- [ ] **Dependency:** (e.g., Domain layer importing Infrastructure)

## 2. 改善提案 (Improvement Proposals)

### Priority 1: Critical (Must Fix)
*(Type safety, bugs, major architectural violations)*
1. Fix: ...
2. Fix: ...

### Priority 2: Quality (Should Fix)
*(Readability, performance, standard compliance)*
1. Refactor: ...
2. Rename: ...

### Priority 3: Polish (Nice to Have)
*(Docstrings, minor stylistic adjustments)*
1. Add: ...

## 3. 自己レビュー (Self-Review Checklist)

- [ ] **Pythonic:** Idiomatic usage (e.g., context managers, generators)?
- [ ] **Type Hints:** Fully typed arguments/returns? (No `Any`)
- [ ] **Docstrings:** Google-style docstrings for public interfaces?
- [ ] **SSOT:** Consistent with design docs and ADRs?
- [ ] **Tests:** All tests passing (Green) after changes?
