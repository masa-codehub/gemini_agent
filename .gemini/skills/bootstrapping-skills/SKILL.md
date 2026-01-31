---
name: bootstrapping-skills
description: 新しい Gemini CLI エージェントスキルの雛形を作成します。スキルの新規作成、テンプレートの初期化、または新しい機能の構築を開始する際に使用します。命名規則やフォルダ構造のベストプラクティスを適用します。
---

# スキル・ブートストラッパー (Skill Bootstrapper)

このスキルは、正しいディレクトリ構造とテンプレートファイルを生成することにより、Gemini CLI 用の新しいエージェントスキルのセットアップ（初期化）を支援します。

## ワークフロー (Workflow)

以下の手順に従って、新しいスキルを作成します。

### 1. 情報の収集

ユーザーから以下の情報が提供されていない場合は、質問して収集してください：

1.  **スキル名 (Skill Name)**: `kebab-case` を使用する必要があります。名詞（例: `pdf-tool`）よりも動名詞（例: `processing-pdfs`）を優先してください。
2.  **スコープ (Scope)**: "User" (`~/.gemini/skills/`) または "Workspace" (現在のプロジェクトの `.gemini/skills/`)。
3. **複雑度 (Complexity)**: "Simple"（単一ファイル）または "Advanced"（`scripts/` や `references/` フォルダを含む）。
4.  **目的 (Purpose)**: スキルが何を行うかの簡潔な説明（YAML フロントマター用）。

### 2. バリデーションとパスの決定

- **名前のチェック**: 小文字、数字、ハイフンのみが含まれていることを確認してください。予約語（`gemini`, `google`）は使用できません。
- **ターゲットディレクトリの決定**:
  - スコープが **User** の場合: `~/.gemini/skills/<skill-name>/`
  - スコープが **Workspace** の場合: `./.gemini/skills/<skill-name>/`

### 3. スキルの生成

以下のテンプレートを使用して、ディレクトリと `SKILL.md` ファイルを作成します。

#### テンプレート A: シンプルなスキル (Simple Skill)

テキストベースの直接的な指示に適しています。

```markdown
---
name: <skill-name>
description: <purpose> (三人称で記述します。例: "ログを分析し..."。 "私は分析します" は避けてください)
---

# <スキル タイトル>

## 概要

<スキルの機能に関する簡潔な説明>

## 指示 (Instructions)

1. ステップ 1
2. ステップ 2
```

#### テンプレート B: 高度なスキル (Advanced Skill)

スクリプトや広範なドキュメントを必要とするスキルに適しています。

##### 作成するディレクトリ構造:

```planetext
<skill-name>/
├── SKILL.md
├── assets/          # テンプレートや静的ファイル
├── references/      # 詳細な仕様やドキュメント
└── scripts/         # 実行スクリプト
```

##### SKILL.md の内容:

```markdown
---
name: <skill-name>
description: <purpose> (特定のキーワード + 三人称での記述)
---

# <スキル タイトル>

## クイックスタート

分析スクリプトの実行:
\`\`\`bash
python scripts/analyze.py --input <file>
\`\`\`

## 高度な使い方

**リファレンス**: 詳細については [references/api.md](references/api.md) を参照してください。
**ワークフロー**: 複雑な手順については [workflows.md](workflows.md) を参照してください。

## ユーティリティスクリプト

- \`scripts/analyze.py\`: <説明>
- \`scripts/validate.py\`: <説明>
```

### 4. 作成後のアドバイス

ファイルを生成した後、ユーザーに以下のベストプラクティスを伝えてください：

1. **簡潔さ**: `SKILL.md` は 500 行以内に収めるようにします。詳細は `references/` に逃がします。
2. **三人称での説明**: 説明文はスキルの発見において極めて重要です。
3. **リファレンスの活用**: 詳細なガイドラインについては [references/skills_best_practice.md](references/skills_best_practice.md) を参照してください。
4. **反映**: 新しいスキルを反映させるために `gemini skills reload` を実行することを勧めてください。
