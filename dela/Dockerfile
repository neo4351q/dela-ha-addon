ARG BUILD_FROM=ghcr.io/olerast67/dela:1.1.9
FROM ${BUILD_FROM}

# Возвращаемся на root для выполнения настроек
USER root

# Копируем скрипт запуска и делаем его исполняемым
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Создаем папку заранее и даем полные права (на всякий случай)
RUN mkdir -p /data/dela && chmod 777 /data/dela

# Запускаем наш скрипт
CMD [ "/run.sh" ]