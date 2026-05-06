# セットアップ手順

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

### 6. ブランチとフロントの依存関係

```bash
# stagingブランチに切り替え
git checkout -b staging

# package.json の生成・SCSSビルド設定の初期化
node init-package.js

# 依存関係をインストール
npm install
```

---

### 7. 固定ページの WP-CLI 作成（AI 生成コマンドの実行）

1. 下記 **「AI へのプロンプト」** をコピーし、**ファイル構成** に `wp-content/themes/main-theme` の最新の PHP 配置（特に `page-*.php`）を追記して AI に渡す。
2. AI から **2 つの bash コードブロック**（第一：`docker compose exec` と `wp post create` の `&&` チェーン、第二：同様に `page-{slug}.php` 向け）が返ったら、その **順に** プロジェクトルートで実行する。
3. 第一ブロックはサイト共通の固定ページ、第二ブロックは `page-*.php` のスラッグに対応する固定ページ用。**現行テーマに `page-*.php` が無い場合**は第二ブロックが空やコメントのみになることがある（そのときはスキップするか、テンプレ追加後に再実行する）。
4. **手順 3** の `init.sh` で既に `home` 固定ページを作っているため、第一ブロックに **ホーム重複作成** が含まれる場合は、実行前に AI の出力を調整するか、重複に注意する。

#### ファイル構成（例・追記用）

`main-theme` 直下の PHP（現時点）：

- `404.php`
- `footer.php`
- `front-page.php`
- `functions.php`
- `header.php`
- `pages-template.php`
- `components/Button.php`
- `inc/*.php`

※ `page-{slug}.php` 形式のテンプレートは **未配置**。

#### AI へのプロンプト（コピー用）

```text
現在のファイル構成を参照して、固定ページ作成用のDocker対応WP-CLIコマンドと、page-〇〇を作成するCLIコマンドを生成し、別のコードブロックで出力してください。（合計2つ）`&&` でチェーンにしてください。

## ファイル構成（ユーザ入力）

（ここに wp-content/themes/main-theme の tree や page-*.php の一覧を貼る）

## 仕様：
- `docker compose exec wordpress` を使用
- `wp post create` を使用
- `--post_type=page`
- `--post_title='タイトル'`（サイトマップから取得。不明な場合はヒアリングしてください）
- `--post_status=publish`
- `--post_name='slug'`（PHPファイル名から抽出）
- `--allow-root` を付与
- 出力は実行可能なコマンドのみ
```

#### 生成コマンド例（現行リポジトリ・参考）

**第一ブロック（共通固定ページ・`front-page.php` 用にホーム）**

```bash
docker compose exec wordpress wp post create --post_type=page --post_title='ホーム' --post_status=publish --post_name='home' --allow-root
```

**第二ブロック（`page-{slug}.php` 向け）**

現状 `page-*.php` が無いため、**このリポジトリ単体では `wp post create` の第二チェーンは生成しない**。テーマに `page-about.php` などを追加したら、上のプロンプトで AI に再実行させる。

---

## 🎊🎊 Setup Complete! 🎊🎊
