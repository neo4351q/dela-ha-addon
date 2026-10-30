ARG BUILD_FROM=ghcr.io/olerast67/dela:1.1.9
FROM ${BUILD_FROM}

# Копируем скрипт запуска в контейнер и делаем его исполняемым.
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Запускаем аддон через наш скрипт.
CMD ["/run.sh"]