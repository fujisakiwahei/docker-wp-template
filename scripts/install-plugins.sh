#!/bin/bash

set -e

cd /var/www/html

# デフォルトプラグイン削除
wp plugin deactivate akismet hello --allow-root || true

wp plugin delete akismet hello --allow-root || true

# 一括インストール＆有効化
wp plugin install \
advanced-custom-fields \
all-in-one-seo-pack \
all-in-one-wp-migration \
contact-form-7 \
custom-post-type-ui \
w3-total-cache \
duplicate-post \
--activate \
--allow-root

# SiteGuard はログインURLが変わるためインストールのみ
wp plugin install \
siteguard \
--allow-root