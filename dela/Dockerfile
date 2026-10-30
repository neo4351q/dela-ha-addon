ARG BUILD_FROM=ghcr.io/olerast67/dela:1.1.9
FROM ${BUILD_FROM}

# Переключаемся на root для выполнения настроек.
USER root

# Копируем скрипт запуска в контейнер и делаем его исполняемым.
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Создаём постоянную папку для базы данных и отдаём её пользователю node.
RUN mkdir -p /addon_configs/dela && chown -R node:node /addon_configs/dela

# Возвращаемся к пользователю node для запуска сервера.
USER node

# Запускаем аддон через наш скрипт.
CMD ["/run.sh"]