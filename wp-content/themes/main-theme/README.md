# 📘 WordPress Theme Template

---

## 🚀 セットアップ手順

### 1️⃣ GitHubでテンプレートからリポジトリを作成

1. テンプレートリポジトリのページで「Use this template」→「Create a new repository」をクリック
2. リポジトリ名を入力（例：`my-wordpress-theme`）、Public/Private を選択
3. 「Create repository」をクリック

---

### 2️⃣ Localで新規サイトを作成

1. Local を起動し、新規サイトを作成（サイト名・PHPバージョン・WPバージョンを設定）
2. サイトが起動したら「Open site folder」をクリック

---

### 3️⃣ テーマディレクトリにリポジトリをクローンし、依存関係をインストール

```bash
# themesディレクトリに移動
cd app/public/wp-content/themes/

# リポジトリをクローン
git clone <GitHubのURL>

# テーマディレクトリに移動
cd <テーマ名>

# stagingブランチに切り替え
`git checkout -b staging`

# package.json の生成・SCSSビルド設定の初期化
node init-package.js

# 依存関係をインストール
npm install
```

このタイミングで、`.claude/CLAUDE.md` と `.cursor/rules/coding-standards.mdc` に固有の事項を書いておくとよい。

---

### 4️⃣ WordPress 初期設定

**Local > サイトを右クリック > Site shell** でCLIを起動し、以下を一括実行する。

```bash
# 日本語化
wp language core install ja &&
wp site switch-language ja &&

# タイムゾーン
wp option update timezone_string "Asia/Tokyo" &&

# テーマをアクティブ化（作業ディレクトリ名をテーマ名として取得）
wp theme activate $(basename $(pwd)) &&

# ホームページ用の固定ページを作成
wp post create --post_type=page --post_title='ホーム' --post_status=publish --post_name='home' &&

# ホームページの表示設定
wp option update show_on_front page &&
wp option update page_on_front $(wp post list --post_type=page --name=home --field=ID --format=ids)

# パーマリンクを「投稿名」に変更
wp option update permalink_structure '/%postname%/' &&
wp rewrite flush &&

# テスト環境用 noindex（検索エンジンにインデックスさせない）
wp option update blog_public 0
```

#### プラグインを WP-CLI で一括インストール

```bash
# 一括インストール＆有効化
wp plugin install advanced-custom-fields all-in-one-seo-pack all-in-one-wp-migration contact-form-7 custom-post-type-ui w3-total-cache duplicate-post --activate &&

# SiteGuard はログインURLが変わるためインストールのみ（後で手動で有効化）
wp plugin install siteguard
```

| プラグイン | 用途 |
|----------|------|
| Advanced Custom Fields | カスタムフィールド管理 |
| All in One SEO | SEO最適化 |
| All-in-One WP Migration and Backup | バックアップ・移行 |
| Contact Form 7 | お問い合わせフォーム |
| Custom Post Type UI | カスタム投稿タイプ作成 |
| W3 Total Cache | キャッシュ・パフォーマンス最適化 |
| Yoast Duplicate Post | 投稿の複製機能 |
| SiteGuard WP Plugin | セキュリティ強化（⚠️ 手動で有効化） |

---

### 5️⃣ Figmaを確認し、コンポーネント・デザイントークンを洗い出す

**人が行う作業。** Figmaを開き、以下を整理してからAIに渡す。

- **デザイントークン：** カラー・フォント（種類・サイズ・行間・文字間）・シャドウ
- **コンポーネント一覧：** サイト全体で再利用するパーツ（例：ボタン・カード・ヘッダー・フッターなど）
- **ページ一覧（サイトマップ）：** 次ステップで使用

整理した内容をもとに、`assets/scss/abstract/` 配下の各ファイルに**人が直接記述する**。

---

**💡 Figma MCPが使える場合のみ：** 上記の手動作業を以下のプロンプトで代替できる。使えない・使いたくない場合はスキップ。

```prompt
Figma MCPを使って以下のFigmaファイルからデザイントークンを取得し、対応するSCSSファイルに記述してください。

取得対象：カラーコード・フォント（種類・サイズ・行間・文字間）・シャドウ
出力先：`assets/scss/abstract/` 配下の各ファイル（_colors.scss / _fonts.scss / _shadows.scss など）
ルール：letter-spacing は em を使用

変数定義後、`assets/scss/mixins/_mixins.scss` にテキストスタイルのミックスインも定義してください。

## コンポーネント一覧
（ここに洗い出したコンポーネントを記入）

{FigmaのURL}
```

---

### 6️⃣ ベーススタイルの記述

**人が行う作業。** `assets/scss/base/` 配下のファイルに直接記述する。

- **`_common.scss`：** `body` / `a` / `img` などのリセット・ベーススタイル
- **`_wrappers.scss`：** `section` と `inner` のサイズ・余白

`assets/scss/abstract/` のデザイントークンと `assets/scss/mixins/` のミックスインを活用すること。

---

### 7️⃣ ページ・コンポーネントファイルの作成とインポート

サイトマップ（ページ一覧）を用意した上で、以下のプロンプトを Cursor に貼り付けて実行する。

```prompt
現在のコードベースを参照して、以下を実行してください。

## サイトマップ
（ここにページ一覧を記入。例↓）
- トップ（/）
- 会社概要（/about）
- サービス（/service）
- お問い合わせ（/contact）

## 実行内容
1. 上記サイトマップをもとに、ページテンプレート（PHP）をテーマルートに作成（例：page-about.php）
2. 再利用コンポーネント（PHP）を `components/` に作成（例：button.php）
3. ページ固有SCSSを `assets/scss/pages/` に作成（例：_page-about.scss）
4. コンポーネントSCSSを `assets/scss/components/` に作成（例：_button.scss）
5. 作成したSCSSファイルをすべて `assets/scss/style.scss` に追記してインポート

`assets/scss/abstract/` のデザイントークンと `assets/scss/mixins/` のミックスインを活用し、既存のコーディング規約に従ってください。
```

#### ブレイクポイント一覧

| キー | 値 |
|-----|---|
| `xs` | 320px |
| `sm` | 576px |
| `md` | 768px |
| `lg` | 992px |
| `xl` | 1200px |
| `xxl` | 1391px |

```scss
// 使用例
@use "../mixins/mixins" as *;

.my-component {
  font-size: 1.5rem;

  @include media(md) {      // max-width: 768px
    font-size: 1.2rem;
  }

  @include media-min(md) {  // min-width: 769px
    font-size: 1.8rem;
  }
}
```

---

### 8️⃣ 固定ページを WP-CLI で一括作成

ステップ7で作成したPHPファイルをもとに、以下のプロンプトを Cursor に貼り付けて生成されたコマンドを Site shell で実行する。

```prompt
現在のファイル構成を参照して、固定ページ作成用のWP-CLIコマンドを生成し、コードブロックで出力してください。`&&` でチェーンにしてください。

仕様：
- `--post_type=page`
- `--post_title='タイトル'`（サイトマップから取得。不明な場合はヒアリングしてください）
- `--post_status=publish`
- `--post_name='slug'`（PHPファイル名から抽出）
```

---

## 🚢 デプロイ

### バックアップ（All-in-One WP Migration）

- **本番公開時に1回だけ** wpファイルをエクスポートして保存する
- 公開後の修正はGitで管理するため、追加バックアップは不要

### ConoHa WINGへの自動デプロイ（GitHub Actions）
[新規プロジェクト用 GitHub Actions デプロイ設定手順.md](https://github.com/fujisakiwahei/wahe-knowledge-base/blob/master/WordPress/Manual/%E6%96%B0%E8%A6%8F%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E7%94%A8%20GitHub%20Actions%20%E3%83%87%E3%83%97%E3%83%AD%E3%82%A4%E8%A8%AD%E5%AE%9A%E6%89%8B%E9%A0%86.md)を参照

---

## 📋 プロジェクト情報

### バックアップ保存先（Drive）

（URLを記入）

---

### バージョン情報

| 項目 | バージョン |
|----|---------|
| WordPress | |
| PHP | |

---

### 環境別アクセス情報

> **共通ルール：** ローカル・テスト・本番の管理画面IDとパスワードはすべて共通でOK。

#### ローカル / テストサーバ（開発環境）

| 項目 | ローカル | テストサーバ |
|----|---------|-----------|
| サイトURL | `http://localhost` | |
| WordPress ログインID | | |
| PASS | `{Bitwardenのエントリ名}` | `{Bitwardenのエントリ名}` |
| FTP ID | — | |
| FTP PASS | — | |
| ログインURL | `/wp-admin` | |

#### 本番サーバ

| 項目 | 値 |
|----|---|
| サイトURL | |
| FTP ID | `{Bitwardenのエントリ名}` |
| FTP PASS | `{Bitwardenのエントリ名}` |
| ログインURL | |
| 管理画面ID | `{Bitwardenのエントリ名}` |
| PASS | `{Bitwardenのエントリ名}` |
