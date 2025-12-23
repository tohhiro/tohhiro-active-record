FROM ruby:3.3

WORKDIR /app

# 必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential libsqlite3-dev sqlite3 && \
    rm -rf /var/lib/apt/lists/*

# Gemfileをコピーして依存関係をインストール
COPY Gemfile Gemfile.lock* ./
RUN bundle install

# アプリケーションコードをコピー
COPY . .

CMD ["bash"]
