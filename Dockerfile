# --- 最終的な実行イメージ (Ubuntuベースで一本化) ---
FROM ubuntu:latest

# apt-get実行時にインタラクティブなプロンプトを無効化
ENV DEBIAN_FRONTEND=noninteractive

# 1. 基本ツールと依存関係のインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common \
        curl \
        git \
        jq \
        sudo \
        gnupg \
        ca-certificates \
        lsb-release \
        procps \
        tmux \
        libicu-dev \
        tar \
        build-essential \
        libssl-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Python 3.13 のインストール (deadsnakes PPA を使用)
RUN add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update && apt-get install -y --no-install-recommends \
        python3.13 \
        python3.13-dev \
        python3.13-venv \
        python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.13 1

# 3. Node.js のインストール (NodeSource を使用)
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# 4. GitHub CLI のインストール
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# 5. Google Cloud CLI (gcloud) のインストール
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-cloud-cli \
    && rm -rf /var/lib/apt/lists/*

# 6. Gemini CLI のインストール
RUN npm install -g @google/gemini-cli@preview \
    && gemini extensions install https://github.com/github/github-mcp-server --consent

# 7. GitHub Actions Runner のダウンロードと展開
WORKDIR /home/runner
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | sed 's/^v//') \
    && curl -o actions-runner.tar.gz -L "https://github.com/actions/runner/releases/download/v${LATEST_VERSION}/actions-runner-linux-x64-${LATEST_VERSION}.tar.gz" \
    && tar xzf ./actions-runner.tar.gz \
    && rm actions-runner.tar.gz

# 8. ランナー用のユーザー作成
RUN useradd -m runner \
    && usermod -aG sudo runner \
    && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && chown -R runner:runner /home/runner

# 9. スクリプト類をコピーして権限設定
COPY --chown=runner:runner .build/entrypoint.sh .
RUN chmod u+x entrypoint.sh && sudo ./bin/installdependencies.sh

USER runner

ENTRYPOINT ["/home/runner/entrypoint.sh"]
