#!/bin/sh
# run.sh - точка входа аддона Dela для Home Assistant.
set -e

# Читаем опции из конфигурации Home Assistant (/data/options.json).
if [ -f /data/options.json ]; then
    DELA_ADMIN_EMAIL="$(node -e 'console.log(require("/data/options.json").admin_email || "")')"
    DELA_PUBLIC_URL="$(node -e 'console.log(require("/data/options.json").public_url || "")')"
else
    DELA_ADMIN_EMAIL=""
    DELA_PUBLIC_URL=""
fi
export DELA_ADMIN_EMAIL
export DELA_PUBLIC_URL

# Папка данных. /data — стандартная постоянная папка аддона Home Assistant:
# её монтирует HA, она доступна для записи (аддон работает от root) и попадает в бэкапы.
DELA_DATA_DIR="/data"
export DELA_DATA_DIR

# Диагностика (видна в логе аддона).
echo "Dela: admin_email='${DELA_ADMIN_EMAIL}' public_url='${DELA_PUBLIC_URL}' data_dir='${DELA_DATA_DIR}'"

# Создаём папку на случай, если её ещё нет.
mkdir -p "${DELA_DATA_DIR}"

# Запускаем сервер Dela той же командой, что и оригинальный образ.
cd /app
exec node --disable-warning=ExperimentalWarning apps/server/src/main.ts