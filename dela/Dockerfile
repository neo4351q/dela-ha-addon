ARG BUILD_FROM=ghcr.io/olerast67/dela:1.1.9
FROM ${BUILD_FROM}

# Запускаем от root: в Home Assistant папка /data монтируется от root,
# а базовый образ Dela работает от пользователя node и не смог бы туда писать.
USER root

# Копируем скрипт запуска и делаем его исполняемым.
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Запускаем аддон через наш скрипт.
CMD ["/run.sh"]