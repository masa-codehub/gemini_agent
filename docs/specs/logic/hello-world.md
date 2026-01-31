# say_hello Specification

## Overview
呼び出し側に "Hello, World!" という固定の挨拶文字列を返すシンプルな関数。

## Input
引数なし。

## Output
| Type | Description |
| :--- | :--- |
| `str` | `"Hello, World!"` という固定文字列。 |

## Algorithm / Flow
1.  文字列 `"Hello, World!"` を生成する。
2.  生成した文字列を戻り値として返す。

## Edge Cases
- 特になし。

## TDD Criteria (Verification)
- `say_hello()` を呼び出すと、厳密に `"Hello, World!"` という文字列が返ること。
- 戻り値の型が Python の `str` であること。
