# 共通実装計画: Hello World Function
作成日: 2026-01-31

## 1. アーキテクチャ構成 / Architecture Mapping
- **ロジック層**: `src/hello.py`
- **テスト層**: `tests/unit/test_hello.py`

## 2. テスト戦略 / Test Strategy
- **フレームワーク**: `pytest`
- **方針**: モックは不要。関数の戻り値と型を直接検証するユニットテストを行う。

## 3. コーディング規約 / Coding Standards
- **型ヒント**: `say_hello() -> str` のように、戻り値の型ヒントを必須とする。
- **docstring**: 関数の役割を簡潔に記述する。
- **フォーマット**: Ruff による自動フォーマットに準拠する。

## 4. TDDシナリオ概要
1.  **Red**: `say_hello` を呼び出すテストを記述し、失敗（ImportError または NameError）を確認する。
2.  **Green**: `src/hello.py` に `say_hello` を定義し、テストをパスさせる。
3.  **Refactor**: 必要に応じてコードを整理する。
