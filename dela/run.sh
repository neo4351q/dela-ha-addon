#!/bin/sh
# run.sh - точка входа аддона Dela для Home Assistant.
set -e

# Жёстко заданный email администратора (первый аккаунт регистрируется именно с ним).
DELA_ADMIN_EMAIL="neo4351@gmail.com"
export DELA_ADMIN_EMAIL

# public_url читаем из конфигурации (опционально, нужен для passkey).
# reset_db — одноразовый сброс базы при следующем запуске (для чистого старта).
if [ -f /data/options.json ]; then
    DELA_PUBLIC_URL="$(node -e 'console.log(require("/data/options.json").public_url || "")')"
    RESET_DB="$(node -e 'console.log(require("/data/options.json").reset_db ? "1" : "")')"
else
    DELA_PUBLIC_URL=""
    RESET_DB=""
fi
export DELA_PUBLIC_URL

# Папка данных. /data — стандартная постоянная папка аддона Home Assistant:
# её монтирует HA, она доступна для записи (аддон работает от root) и попадает в бэкапы.
DELA_DATA_DIR="/data"
export DELA_DATA_DIR

# Диагностика (видна в логе аддона).
echo "Dela: admin_email='${DELA_ADMIN_EMAIL}' public_url='${DELA_PUBLIC_URL}' data_dir='${DELA_DATA_DIR}'"

# Создаём папку на случай, если её ещё нет.
mkdir -p "${DELA_DATA_DIR}"

# Одноразовый сброс базы данных (reset_db=true в настройках аддона).
if [ "${RESET_DB}" = "1" ]; then
    echo "Dela: сброс базы данных"
    rm -f "${DELA_DATA_DIR}/dela.sqlite" "${DELA_DATA_DIR}/dela.sqlite-wal" "${DELA_DATA_DIR}/dela.sqlite-shm"
fi

# Запускаем сервер Dela той же командой, что и оригинальный образ.
cd /app
exec node --disable-warning=ExperimentalWarning apps/server/src/main.ts