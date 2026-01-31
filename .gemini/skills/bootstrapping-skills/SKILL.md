---
name: bootstrapping-skills
description: Bootstraps new Gemini CLI agent skills by generating standard directory structures and templates based on best practices. Use this when creating new skills or initializing workspace skill environments.
---

# スキル・ブートストラッパー (Skill Bootstrapper)

このスキルは、Gemini CLI 用の新しいエージェントスキルのセットアップ（初期化）を支援します。

## ワークフロー (Workflow)

以下の手順に従って、新しいスキルを作成します。進捗を管理するためにチェックリストを使用してください。

```markdown
スキルの生成状況:

- [ ] 1. 情報収集 (Name, Scope, Complexity, Purpose)
- [ ] 2. パス確定とディレクトリ作成
- [ ] 3. テンプレートの適用とファイル生成
- [ ] 4. 作成後のアドバイス提供
```

### 1. 情報の収集

ユーザーから以下の情報が不足している場合は、質問して収集してください：

1.  **スキル名 (Skill Name)**: `kebab-case` かつ動名詞（例: `analyzing-data`）を推奨。
2.  **スコープ (Scope)**: "Workspace" (`./.gemini/skills/`) のみに限定。
3.  **複雑度 (Complexity)**: "Simple"（単一ファイル）または "Advanced"（`scripts/`, `references/`, `assets/` を含む）。
4.  **目的 (Purpose)**: スキルが何を行うかの簡潔な説明。
    - **英語化を想定した具体化**: YAMLフロントマターの `description` は、最終的に「英語かつ三人称」で記述される必要があります。翻訳した際に意図が曖昧にならないよう、以下の点を確認・深掘りしてください。
      - **具体的な動作**: 「管理する (manage)」のような広範な表現を避け、「作成・更新・削除を行う」のように具体的なアクションを特定する。
      - **トリガー条件**: 「どのような状況やキーワードでこのスキルが選択されるべきか」を明確にする。

### 2. パスとディレクトリの決定

- **バリデーション**: 名前が `google`, `gemini` などの予約語でないことを確認。
- **ターゲット**: プロジェクト相対パス (`./.gemini/skills/<skill-name>/`) を使用。

### 3. スキルの生成

`assets/` ディレクトリにあるテンプレートをベースにファイルを生成します。

- **Simple Skill**: `assets/simple-skill-template.md` を使用。
- **Advanced Skill**: `assets/advanced-skill-template.md` を使用し、以下の構造を作成。
  ```text
  <skill-name>/
  ├── SKILL.md
  ├── assets/
  ├── references/
  └── scripts/
  ```

### 4. 完了後のアクション

ファイルを生成した後、ユーザーに以下のベストプラクティスを伝えてください：

1.  **簡潔さ**: `SKILL.md` は 500 行以内に収め、詳細は `references/` に分けること。
2.  **三人称・英語の説明**: `description` は常に英語かつ三人称で記述すること。
3.  **反映**: `gemini skills reload` を実行して新しいスキルを認識させること。
4.  **詳細**: [references/skills_best_practice.md](references/skills_best_practice.md) を参照すること。
