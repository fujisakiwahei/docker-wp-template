# このリポジトリの目的

Docker を利用して、WordPress + フロントエンド開発環境をローカルに即座に構築できるようにするためのテンプレートリポジトリです。

以下を目的としています。

- 案件開始時の初期構築コスト削減
- 開発環境差異の排除
- WordPress 初期設定の自動化
- 必須プラグイン導入の標準化
- フロントエンド開発環境の共通化
- 新規案件の高速立ち上げ

---

# 解決する課題

従来の WordPress 案件では、毎回以下のような初期作業が発生していました。

- ローカル環境構築
- PHP / MySQL バージョン差異
- WordPress 手動インストール
- 日本語設定
- タイムゾーン設定
- パーマリンク設定
- noindex 設定
- 必須プラグイン導入
- SCSS / npm 初期化
- 固定ページ作成

本リポジトリでは、これらを Docker + WP-CLI + スクリプトで標準化・自動化しています。

---

# 使用する技術

- Docker
- WordPress
- WP-CLI
- PHP
- MySQL
- Node.js
- npm
- SCSS
- Stylelint（SCSSのプロパティを保存時自動実行で並び替え。並び順は`main-theme` の `stylelint.config.js` で設定）

# セットアップ手順

## 0. 前提として、以下がインストール済み・設定済みであること。
- Git
- Docker Desktop
- Node.js
- npm
- VSCode（Cursorなどフォークでも可）
  - Stylelint拡張機能
- Stylelint の保存時自動実行（settings.jsonで、Stylelint の保存時自動修正を有効化してください。）
```settings.json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.stylelint": "explicit"
  }
}
```

## 1. リポジトリをClone

1. Use this template で新しいリポジトリを複製
2. プロジェクトを配置したいディレクトリで`git clone`

## 2. ローカルでのセットアップ

### 1. `.env` を作成

```bash
cp .env.example .env
```

`.env` を編集。

---

### 2. Docker 起動

```bash
docker compose up -d --build
```

---

### 3. WordPress 初期設定

```bash
docker compose exec wordpress bash /scripts/init.sh
```

実行内容：

- WordPress インストール
- 日本語化
- タイムゾーン設定
- テーマ有効化
- ホーム固定ページ作成
- パーマリンク設定
- noindex 設定

---

### 4. プラグインインストール

```bash
docker compose exec wordpress bash /scripts/install-plugins.sh
```

実行内容：

- デフォルトプラグイン削除
- 必須プラグイン一括インストール
- SiteGuard インストール

---

### 5. テーマディレクトリへ移動

```bash
cd wp-content/themes/main-theme
```

---

### 6. ブランチの初期設定と依存関係インストール（ブランチ戦略はお好みで調整してください）

```bash
# stagingブランチに切り替え
git checkout -b staging

# package.json の生成・SCSSビルド設定の初期化
node init-package.js

# 依存関係をインストール
npm install
```

---

### 7. `page-〇〇.php` と固定ページの作成
この手順では `page-{slug}.php` と、それに対応する固定ページを作成します。

1. 下記プロンプトを AI に渡す
2. 生成された 2 つのコードブロックを確認する（Docker上で実行するWP-CLIと、プロジェクトルートで実行するCLI）
3. 問題なければ、上から順に 1 つずつ実行する

※ AI は間違うことがあります。`slug` やファイル名、ページタイトルが意図通りか実行前に確認してください。

#### AI へのプロンプト

```text
現在のファイル構成を参照して、`page-〇〇.php` ファイル作成コマンドと、対応する固定ページ作成用の Docker 対応 WP-CLI コマンドを生成してください。

コードブロックは 2 つに分けてください。

1つ目：
- `/wp-content/themes/main-theme/` に `page-{slug}.php` を作成するコマンド

2つ目：
- 固定ページを作成する `wp post create` コマンド

wp post create仕様：
- コマンドは `&&` でチェーン
- `docker compose exec wordpress` を使用
- `wp post create` を使用
- `--post_type=page`
- `--post_status=publish`
- `--post_name='slug'`
- `--allow-root`
- `home` は生成しない

---

## 🎊🎊 Setup Complete! 🎊🎊
