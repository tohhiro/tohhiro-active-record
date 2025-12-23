# Active Record 学習環境

Ruby + Active Record + SQLite3 の Docker 環境です。

## セットアップ

```bash
# コンテナのビルドと起動
docker-compose up -d

# コンテナに入る
docker-compose exec app bash
```

## 使い方

コンテナ内で Ruby スクリプトを実行できます：

```bash
ruby your_script.rb
```

## 停止

```bash
docker-compose down
```
