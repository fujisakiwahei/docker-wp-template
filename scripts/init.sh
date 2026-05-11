#!/bin/bash
set -e
cd /var/www/html

# WordPress未インストールなら初期化
if ! wp core is-installed --allow-root; then
  wp core install \
    --url="http://localhost:8080" \
    --title="WP Template" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --allow-root
fi

# 日本語化
wp language core install ja --activate --allow-root

# タイムゾーン
wp option update timezone_string "Asia/Tokyo" --allow-root

# テーマ有効化
wp theme activate "$THEME_NAME" --allow-root

# ホーム固定ページ
HOME_ID=$(wp post list \
  --post_type=page \
  --name=home \
  --field=ID \
  --format=ids \
  --allow-root)

if [ -z "$HOME_ID" ]; then
  HOME_ID=$(wp post create \
    --post_type=page \
    --post_title='ホーム' \
    --post_status=publish \
    --post_name='home' \
    --porcelain \
    --allow-root)
fi

# ホームページ設定
wp option update show_on_front page --allow-root
wp option update page_on_front "$HOME_ID" --allow-root

# パーマリンク
wp option update permalink_structure '/%postname%/' --allow-root
wp rewrite flush --allow-root

# noindex
wp option update blog_public 0 --allow-root

# uploads ディレクトリ作成
mkdir -p /var/www/html/wp-content/uploads

# 権限修正
chown -R www-data:www-data /var/www/html/wp-content
chmod -R 755 /var/www/html/wp-content
