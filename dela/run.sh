#!/bin/sh
# run.sh - точка входа аддона Dela для Home Assistant.

# Получаем admin_email из конфигурации HA
if [ -f /data/options.json ]; then
    DELA_ADMIN_EMAIL="$(node -e 'console.log(require("/data/options.json").admin_email || "")')"
else
    DELA_ADMIN_EMAIL=""
fi
export DELA_ADMIN_EMAIL

# Используем папку /data/dela внутри контейнера. 
# Она всегда доступна для записи, и мы точно избежим проблем с правами.
DELA_DATA_DIR="/data/dela"
export DELA_DATA_DIR

# Создаем папку, если её нет
mkdir -p "${DELA_DATA_DIR}"

# Запускаем сервер
cd /app || exit 1
exec node --disable-warning=ExperimentalWarning apps/server/src/main.ts