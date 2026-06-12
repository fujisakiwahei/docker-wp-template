#!/bin/bash

set -e

cd /var/www/html

required_plugins=(
  advanced-custom-fields
  all-in-one-seo-pack
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

# All-in-One WP Migration はローカル zip からバージョン固定インストール (issue #1)
LOCAL_PLUGIN_DIR="/plugins-local"
shopt -s nullglob
ai1wm_zips=("$LOCAL_PLUGIN_DIR"/all-in-one-wp-migration*.zip)
shopt -u nullglob
ai1wm_zip="${ai1wm_zips[0]:-}"

if ! wp plugin is-installed all-in-one-wp-migration --allow-root; then
  if [ -n "$ai1wm_zip" ]; then
    wp plugin install "$ai1wm_zip" --activate --allow-root
  else
    echo "WARNING: ${LOCAL_PLUGIN_DIR} に all-in-one-wp-migration*.zip がありません。wp.org 最新版で代替します（バージョン固定されません）" >&2
    wp plugin install all-in-one-wp-migration --activate --allow-root
  fi
elif ! wp plugin is-active all-in-one-wp-migration --allow-root; then
  wp plugin activate all-in-one-wp-migration --allow-root
fi

# 固定バージョン維持のため自動更新を無効化（既に無効の場合はエラーになるため抑制）
wp plugin auto-updates disable all-in-one-wp-migration --allow-root 2>/dev/null || true

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
