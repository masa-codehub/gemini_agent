#!/bin/bash
set -e

# public-repo の中のファイルを一旦空にする（.git履歴は残す）
find public-repo -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# YAMLからリストを抽出し、rsyncのexclude-fromファイルを作成
# grep|sed は脆いため、Python を使用して確実にパースする
python3 - << 'PY'
import sys
import yaml

config_path = "dev-repo/.github/sync-config.yml"
try:
    with open(config_path, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f)
except FileNotFoundError:
    sys.stderr.write(f"Config file not found: {config_path}\n")
    sys.exit(1)

if not isinstance(data, list):
    sys.stderr.write("sync-config.yml must contain a top-level YAML list of exclude patterns.\n")
    sys.exit(1)

with open("exclude.txt", "w", encoding="utf-8") as out:
    for item in data:
        if isinstance(item, str):
            out.write(item + "\n")
PY

# dev-repo から public-repo へ必要なファイルだけコピー
# --filter='dir-merge,- .gitignore' で、各ディレクトリの .gitignore を読み込んで除外します
rsync -av --filter='dir-merge,- .gitignore' --exclude-from=exclude.txt dev-repo/ public-repo/