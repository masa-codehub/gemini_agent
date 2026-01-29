name: your-skill-name-in-kebab-case description: [VERB] [OBJECT] to [GOAL]. Use when [TRIGGER/CONTEXT].

<!--
【ベストプラクティスガイド】

Naming conventions (命名規則):

"We recommend using gerund form (verb + -ing) for Skill names."
(動名詞形式（動詞 + -ing）の使用を推奨します。例: analyzing-logs, deploying-app)

"Must contain only lowercase letters, numbers, and hyphens."
(小文字、数字、ハイフンのみを使用してください。例: code-reviewer)

Avoid: Vague names (helper, tools, utils), Reserved words.

Writing effective descriptions (効果的な説明):

"The description is critical for skill selection."
(説明はスキルの選択において極めて重要です。)

"Always write in third person."
(常に三人称で記述してください。例: "Extracts text...", NOT "I can extract...")

"Include both what the Skill does and specific triggers/contexts for when to use it."
(「何をするか」と「いつ使うか（トリガー）」の両方を含めてください。)

Core principles (基本原則):

"Concise is key." (簡潔さが鍵です。)

"Default assumption: Claude(Gemini) is already very smart."
(デフォルトの前提: AIはすでに非常に賢いです。基本的な説明は省略してください。)
-->

{Skill Name}

Overview

<!--
【Concise is key / 簡潔さが鍵】

"Only add context Claude doesn't already have."
(AIがまだ持っていないコンテキストのみを追加してください。)

"Does this paragraph justify its token cost?"
(その段落はトークンコストに見合う価値がありますか？)

核心的な機能概要を約50トークン以内で記述します。
-->

{Brief overview of the capability.}

Quick Start

<!--
【Set appropriate degrees of freedom / 適切な自由度の設定】

"Low freedom: Use when operations are fragile and error-prone."
(自由度低: 操作が壊れやすくエラーが発生しやすい場合に使用します。)

最も頻繁に使用されるユースケース（コマンド実行例など）を提示します。
-->

Run the following to {main task}:

# Example command

python scripts/{main_script}.py --input {arg}

Workflows

<!--
【Workflows / ワークフロー】

"Break complex operations into clear, sequential steps."
(複雑な操作を明確で順序だったステップに分解してください。)

"For particularly complex workflows, provide a checklist."
(特に複雑なワークフローの場合、チェックリストを提供してください。)
-->

{Workflow Name}

Step 1: {Action}

Step 2: {Action}

Detail: {Verification step / 検証手順}

References

<!--
【Progressive disclosure / 段階的開示】

"Keep SKILL.md body under 500 lines for optimal performance."
(最適なパフォーマンスのために、SKILL.mdは500行未満に抑えてください。)

"Split content into separate files... Claude reads additional files only as needed."
(コンテンツを別ファイルに分割してください。AIは必要な場合のみ追加ファイルを読み込みます。)
-->

API Reference: See references/api.md for full endpoint details.

Domain Rules: See references/rules.md for business logic.

Troubleshooting: See references/troubleshooting.md.

Utility Scripts

<!--
【Utility scripts / ユーティリティスクリプト】

"Solve, don't punt." (解決する、先送りしない。)

"Use utility scripts: More reliable than generated code."
(ユーティリティスクリプトを使用する: 生成されたコードよりも信頼性が高い。)

AIに複雑なコードを書かせるのではなく、決定論的なスクリプトを提供してください。
-->

scripts/{script_a}.py: {Description of what it does}

scripts/{script_b}.py: {Description of what it does}
