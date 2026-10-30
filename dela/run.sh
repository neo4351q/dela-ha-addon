#!/bin/sh
# run.sh - точка входа аддона Dela для Home Assistant.

# Получаем admin_email из конфигурации HA
if [ -f /data/options.json ]; then
    DELA_ADMIN_EMAIL="$(node -e 'console.log(require("/data/options.json").admin_email || "")')"
else
    DELA_ADMIN_EMAIL=""
fi
export DELA_ADMIN_EMAIL

# Указываем Dela использовать папку /data (она всегда доступна для записи в HA).
# Пробуем все возможные имена переменных, которые может читать config.ts.
export DATA_DIR="/data"
export DELA_DATA_DIR="/data"
export DB_PATH="/data/dela.db"
export DELA_DB_PATH="/data/dela.db"

# На всякий случай создаем папку (хотя она уже создана в Dockerfile)
mkdir -p /data

# Запускаем сервер
cd /app || exit 1
exec node --disable-warning=ExperimentalWarning apps/server/src/main.ts