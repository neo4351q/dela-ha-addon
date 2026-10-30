#!/bin/sh
# run.sh - точка входа аддона Dela для Home Assistant.
set -e

# Получаем admin_email из конфигурации Home Assistant (/data/options.json).
if [ -f /data/options.json ]; then
    DELA_ADMIN_EMAIL="$(node -e 'console.log(require("/data/options.json").admin_email || "")')"
else
    DELA_ADMIN_EMAIL=""
fi
export DELA_ADMIN_EMAIL

# Папка данных. /data — стандартная постоянная папка аддона Home Assistant:
# её монтирует HA, она доступна для записи (аддон работает от root) и попадает в бэкапы.
DELA_DATA_DIR="/data"
export DELA_DATA_DIR

# Создаём папку на случай, если её ещё нет.
mkdir -p "${DELA_DATA_DIR}"

# Запускаем сервер Dela той же командой, что и оригинальный образ.
cd /app
exec node --disable-warning=ExperimentalWarning apps/server/src/main.ts