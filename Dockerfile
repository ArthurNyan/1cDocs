# Используем образ с Pandoc
FROM pandoc/core:3.1.8

# Устанавливаем необходимые инструменты
RUN apk add --no-cache \
    bash \
    curl \
    python3

# Создаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта
COPY . .

# Делаем скрипты исполняемыми
RUN chmod +x scripts/*.sh

# Команда по умолчанию - сборка проекта
CMD ["bash", "scripts/generate_web_simple.sh"]

