#!/bin/bash

set -e

cd /var/www/html

# 未インストールならインストール＆有効化。入っているが無効なら有効化。
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

# デフォルトプラグイン削除（存在するときだけ）
for slug in akismet hello; do
  if wp plugin is-installed "$slug" --allow-root; then
    wp plugin deactivate "$slug" --allow-root || true
    wp plugin delete "$slug" --allow-root || true
  fi
done
