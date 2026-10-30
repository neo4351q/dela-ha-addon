#!/bin/sh
# run.sh - точка входа аддона Dela для Home Assistant.

# Получаем admin_email из конфигурации Home Assistant (/data/options.json).
if [ -f /data/options.json ]; then
    DELA_ADMIN_EMAIL="$(node -e 'console.log(require("/data/options.json").admin_email || "")')"
else
    DELA_ADMIN_EMAIL=""
fi
export DELA_ADMIN_EMAIL

# Постоянная папка для базы данных (в контейнере это /config).
DELA_DATA_DIR="/config"
export DELA_DATA_DIR

# СНАЧАЛА создаем папку, если её нет.
mkdir -p "${DELA_DATA_DIR}"

# ТЕПЕРЬ выдаем права (так как мы работаем от root, даем полные права).
chmod 777 "${DELA_DATA_DIR}"

# Запускаем сервер Dela.
cd /app || exit 1
exec node --disable-warning=ExperimentalWarning apps/server/src/main.ts