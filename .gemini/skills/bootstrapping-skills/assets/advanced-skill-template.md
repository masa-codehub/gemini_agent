---
name: <skill-name>
# [命名規則]
# - 小文字、数字、ハイフンのみ (kebab-case)
# - 動名詞推奨 (例: processing-pdfs, analyzing-data)
# - 予約語禁止 (gemini, google)

description: <purpose>
# [説明のベストプラクティス]
# - 常に英語(English)で記述してください
# - 常に三人称で記述してください (例: "Analyzes logs..." OK / "I will help analyze..." NG)
# - スキルが「何をするか」と「いつ使用するか」を含めてください
# - 具体的なキーワードを含めてください (Geminiがスキルを選択するトリガーになります)
---

# <スキル タイトル>

## クイックスタート

<!--
最も一般的なユースケースをすぐに実行できるコマンド例を提供します。
入出力の例があるとGeminiはより正確に理解できます。
-->

分析スクリプトの実行:

```bash
python scripts/analyze.py --input <file>
```

## 高度な使い方

<!--
[段階的開示 (Progressive Disclosure)]
SKILL.mdは500行以内に保ち、詳細は references/ 以下の別ファイルに記述します。
Geminiは必要になった時だけリンク先のファイルを読みに行きます。
-->

**リファレンス**: 詳細については [references/api.md](references/api.md) を参照してください。

<!--
リンクは SKILL.md から1階層深さまで (references/xxx.md) に留めてください。
深くネストされた参照はGeminiが辿れない可能性があります。
-->

**ワークフロー**: 複雑な手順については [references/workflows.md](references/workflows.md) を参照してください。

<!-- 複雑な手順はチェックリスト形式のワークフローファイルに分けるのが効果的です -->

## ユーティリティスクリプト

<!--
Geminiにコードを書かせるのではなく、検証済みのスクリプトを実行させることで信頼性を高めます。
スクリプトは scripts/ ディレクトリに配置してください。
-->

- `scripts/analyze.py`: <説明>
<!-- スクリプト内でエラー処理を行い、Geminiに丸投げしないようにしてください -->

- `scripts/validate.py`: <説明>
<!--
[検証ループ]
実行結果を検証するスクリプトを用意し、「実行→検証→修正」のループを回すと品質が向上します。
-->
