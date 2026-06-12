#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

# 1. .env（ローカルから手動配置する運用。無ければ必要変数を案内して終了）
if [ ! -f .env ]; then
  cat >&2 <<'EOM'
ERROR: .env がありません。ローカルの雛形をプロジェクトルートに配置してください。
必要な変数: PROJECT_NAME, MYSQL_ROOT_PASSWORD, MYSQL_USER, MYSQL_PASSWORD,
            WP_ADMIN_USER, WP_ADMIN_PASSWORD, WP_ADMIN_EMAIL, THEME_NAME
EOM
  exit 1
fi
set -a; source ./.env; set +a

# 2. ビルド & 起動（再実行時は no-op）
docker compose up -d --build

# 3. MySQL 待機（初期化中はソケットのみ応答するため TCP=127.0.0.1 で確認）
echo "MySQL の起動を待機中..."
db_ready=""
for _ in $(seq 1 60); do
  if docker compose exec -T db mysqladmin ping -h127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" --silent >/dev/null 2>&1; then
    db_ready=1; break
  fi
  sleep 2
done
if [ -z "$db_ready" ]; then
  echo "ERROR: MySQL が 120 秒以内に起動しませんでした。.env の認証情報を変更した場合は 'docker compose down -v' 後に再実行してください。" >&2
  docker compose logs --tail 20 db >&2
  exit 1
fi

# 4. wp-config.php 生成待機（wordpress イメージの entrypoint が生成）
for _ in $(seq 1 30); do
  docker compose exec -T wordpress test -f /var/www/html/wp-config.php && break
  sleep 2
done

# 5. WordPress 初期設定 + プラグイン（どちらも冪等）
docker compose exec -T wordpress bash /scripts/init.sh
docker compose exec -T wordpress bash /scripts/install-plugins.sh

# 6. ホスト側ツール（無ければスキップ）
if command -v composer >/dev/null 2>&1; then
  [ -f composer.json ] || composer require --dev php-stubs/wordpress-stubs
else
  echo "composer 未検出のため wordpress-stubs をスキップ（エディタ補完用・任意）"
fi
if command -v pnpm >/dev/null 2>&1; then
  pnpm install
else
  echo "pnpm 未検出のため依存インストールをスキップ"
fi

echo ""
echo "🎊 Setup complete! → http://localhost:8080 (admin: /wp-admin)"
