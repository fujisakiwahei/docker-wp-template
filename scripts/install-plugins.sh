#!/bin/bash

set -e

cd /var/www/html

required_plugins=(
  advanced-custom-fields
  all-in-one-seo-pack
  all-in-one-wp-migration
  contact-form-7
  custom-post-type-ui
  w3-total-cache
  duplicate-post
)

for slug in "${required_plugins[@]}"; do
  if ! wp plugin is-installed "$slug" --allow-root; then
    wp plugin install "$slug" --activate --allow-root
  elif ! wp plugin is-active "$slug" --allow-root; then
    wp plugin activate "$slug" --allow-root
  fi
done

# SiteGuard はログインURLが変わるためインストールのみ
if ! wp plugin is-installed siteguard --allow-root; then
  wp plugin install siteguard --allow-root
fi

# デフォルトプラグイン削除
for slug in akismet hello; do
  if wp plugin is-installed "$slug" --allow-root; then
    wp plugin deactivate "$slug" --allow-root || true
    wp plugin delete "$slug" --allow-root || true
  fi
done

# WordPress がプラグイン更新・一時展開・バックアップを書き込めるようにする
AI1WM_BACKUP_DIR="/var/www/html/wp-content/ai1wm-backups"
AI1WM_STORAGE_DIR="/var/www/html/wp-content/plugins/all-in-one-wp-migration/storage"
WP_UPGRADE_DIR="/var/www/html/wp-content/upgrade"

mkdir -p "$AI1WM_BACKUP_DIR" "$AI1WM_STORAGE_DIR" "$WP_UPGRADE_DIR"

chown -R www-data:www-data \
  /var/www/html/wp-content/plugins \
  "$WP_UPGRADE_DIR" \
  "$AI1WM_BACKUP_DIR"

chmod 755 "$WP_UPGRADE_DIR" "$AI1WM_BACKUP_DIR" "$AI1WM_STORAGE_DIR"
