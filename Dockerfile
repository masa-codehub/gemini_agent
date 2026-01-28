# --- ステージ1: Node.js公式イメージ (バイナリ取得用) ---
FROM node:20-slim AS node-source

# --- ステージ2: ランナーのダウンロードステージ ---
FROM debian:bookworm-slim AS runner-builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    tar \
    ca-certificates \
    jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /actions-runner
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | sed 's/^v//') \
    && RUNNER_ARCH="x64" \
    && curl -o actions-runner.tar.gz -L "https://github.com/actions/runner/releases/download/v${LATEST_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${LATEST_VERSION}.tar.gz" \
    && tar xzf ./actions-runner.tar.gz \
    && rm ./actions-runner.tar.gz

# --- ステージ3: 最終的な実行イメージ (Python公式イメージをベースに据える) ---
FROM python:3.13-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive

# 必要なツールと、CI/ランナーに必要な依存関係をインストール
# Python環境はベースイメージに含まれているため、SSLの問題は解消される
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        curl \
        jq \
        sudo \
        gnupg \
        ca-certificates \
        lsb-release \
        procps \
        tmux \
        libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# GitHub CLI のインストール
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# Google Cloud CLI (gcloud) のインストール
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-cloud-cli \
    && rm -rf /var/lib/apt/lists/*

# node-sourceステージから、ビルド済みのnode.jsをコピー (同じDebianベースなので安全)
COPY --from=node-source /usr/local /usr/local

# ライブラリの更新通知
RUN ldconfig

# Gemini CLIのインストール
RUN npm install -g @google/gemini-cli@preview \
    && gemini extensions install https://github.com/github/github-mcp-server --consent

# ランナー用のユーザー作成
RUN useradd -m runner \
    && usermod -aG sudo runner \
    && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# スクリプト類をコピー
WORKDIR /home/runner
# runner-builderステージからランナーのファイルをコピー
COPY --from=runner-builder --chown=runner:runner /actions-runner .
# エントリーポイントスクリプトをコピーして実行権限を付与
COPY --chown=runner:runner .build/entrypoint.sh .
RUN chmod u+x entrypoint.sh

# 公式スクリプトを使って依存関係をインストール
RUN sudo ./bin/installdependencies.sh

USER runner

ENTRYPOINT ["/home/runner/entrypoint.sh"]