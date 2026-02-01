# 目標定義書 (Goal Definition)

## 1. 達成すべき状態 (Outcome / SMART Goal)
<!--
【実行へのインプット】
エージェントが目指すべき最終状態。
「何をどうするか」を具体的（Specific）に記述する。
-->
- **ゴール:** (例: 認証トークンの有効期限を24時間に変更し、テストをパスさせる)
- **対象範囲 (Scope):** (変更するファイル、影響範囲)
- **前提条件:** (作業開始前に必要なファイルや権限)

## 2. 具体的なアクションプラン (Action Plan)
<!--
【実行へのインプット】
Time-boxed（1ターン完結）なステップに分解する。
-->
1. **[Step 1]:** (例: `src/config.py` の定数を修正)
2. **[Step 2]:** (例: `tests/test_auth.py` を実行)

## 3. 検証条件 (Definition of Done / Measurable)
<!--
【実行へのインプット】
機械的に判定可能な成功基準。
曖昧な「確認する」ではなく、コマンドと期待値をセットにする。
-->
### A. 自動検証 (Automated Verification)
- **検証コマンド:**
  ```bash
  # (例: pytest tests/unit/test_auth.py::test_token_expiry)
  ```
- **期待される実行結果:** (例: `1 passed` が出力されること)

### B. 手動検証 (Manual Verification / State Check)
- **確認対象:** (例: `src/config.py` の内容)
- **成功条件:** (例: `EXPIRATION = 86400` という文字列が含まれていること)

## 4. 制約事項 (Constraints & Safety)
- **禁止事項:** (例: `domain` 層のコードは変更しないこと)
- **リスク回避:** (例: 本番DBへの接続設定が含まれていないか確認すること)