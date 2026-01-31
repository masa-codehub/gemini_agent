# 共通定義: Hello World Function
作成日: 2026-01-31

## 1. ユビキタス言語 / Ubiquitous Language
| 用語 | 定義 | コード上の表現 |
| :--- | :--- | :--- |
| 挨拶 | "Hello, World!" という固定の文字列 | `"Hello, World!"` |
| 挨拶関数 | 挨拶を返すための関数 | `say_hello` |

## 2. データモデル / Data Models
特になし（基本型 `str` を使用）。

## 3. ドキュメント構成案 / Doc Structure
- **仕様書パス**: `docs/specs/logic/hello-world.md`
- **役割**: `say_hello` 関数の詳細なロジックとテスト条件を記述する。

## 4. 実装者（Implementer）への共通指示
- **対象読者**: 実装担当エージェント。
- **目的**: 迷わずTDD（テスト駆動開発）を回せるようにすること。
- **品質要求**: Ruff（Linter）, Mypy（Type Checker）をパスし、Pytestで検証されていること。
