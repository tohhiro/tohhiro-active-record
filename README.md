# Active Record 学習環境

Ruby + Active Record + SQLite3 の Docker 環境です。

## セットアップ

```bash
# コンテナのビルドと起動
docker compose up -d

# コンテナに入る
docker compose exec app bash
```

## 使い方

コンテナ内で Ruby スクリプトを実行できます：

```bash
ruby your_script.rb
```

## 停止

```bash
docker compose down
```

# db の操作

## スキーマのインポート

docker compose exec -T app sqlite3 myapp.db < import.sql

## インポート後、テーブルが作成されたか

docker compose exec app sqlite3 myapp.db ".tables"

## スキーマの確認

docker compose exec app sqlite3 myapp.db ".schema user"

## ファイルに書かれたものの実行

docker compose exec app ruby main.rb

## SELECT 文で確認

docker compose exec app sqlite3 myapp.db -header -column "SELECT \* FROM user;"
