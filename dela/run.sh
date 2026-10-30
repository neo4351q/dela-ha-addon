#!/bin/sh
# run.sh - точка входа аддона Dela для Home Assistant.

# Получаем admin_email из конфигурации Home Assistant (/data/options.json).
if [ -f /data/options.json ]; then
    DELA_ADMIN_EMAIL="$(node -e 'console.log(require("/data/options.json").admin_email || "")')"
else
    DELA_ADMIN_EMAIL=""
fi
export DELA_ADMIN_EMAIL

# Постоянная папка для базы данных (хранится в /addon_configs и попадает в бэкапы HA).
DELA_DATA_DIR="/config"
export DELA_DATA_DIR
chmod 777 /config 2>/dev/null || true

# Убеждаемся, что папка для данных существует.
mkdir -p "${DELA_DATA_DIR}"

# Запускаем сервер Dela той же командой, что и оригинальный образ (от пользователя node).
cd /app || exit 1
exec node --disable-warning=ExperimentalWarning apps/server/src/main.ts
