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
  if ! wp plugin is-installed "$slug"; then
    wp plugin install "$slug" --activate
  elif ! wp plugin is-active "$slug"; then
    wp plugin activate "$slug"
  fi
done

# SiteGuard はログインURLが変わるためインストールのみ
if ! wp plugin is-installed siteguard; then
  wp plugin install siteguard
fi

# デフォルトプラグイン削除
for slug in akismet hello; do
  if wp plugin is-installed "$slug"; then
    wp plugin deactivate "$slug" || true
    wp plugin delete "$slug" || true
  fi
done
