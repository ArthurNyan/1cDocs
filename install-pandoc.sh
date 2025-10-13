#!/bin/bash

# Скрипт установки Pandoc для Vercel
# Быстрая установка без sudo

set -e

echo "🔧 Установка Pandoc для Vercel..."

# Определяем архитектуру
ARCH=$(uname -m)
echo "   Архитектура: $ARCH"

# Версия Pandoc
PANDOC_VERSION="3.1.8"

# Определяем URL для скачивания
if [ "$ARCH" = "x86_64" ]; then
    PANDOC_URL="https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz"
elif [ "$ARCH" = "aarch64" ]; then
    PANDOC_URL="https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-arm64.tar.gz"
else
    echo "❌ Неподдерживаемая архитектура: $ARCH"
    exit 1
fi

echo "   URL: $PANDOC_URL"

# Создаем временную директорию
TMP_DIR=$(mktemp -d)
echo "   Временная папка: $TMP_DIR"

# Скачиваем и распаковываем Pandoc
echo "   Скачивание Pandoc..."
curl -L "$PANDOC_URL" -o "$TMP_DIR/pandoc.tar.gz"

echo "   Распаковка..."
tar -xzf "$TMP_DIR/pandoc.tar.gz" -C "$TMP_DIR"

# Копируем pandoc в локальную директорию проекта
echo "   Установка в ./bin/..."
mkdir -p ./bin
cp "$TMP_DIR/pandoc-${PANDOC_VERSION}/bin/pandoc" ./bin/

# Делаем исполняемым
chmod +x ./bin/pandoc

# Добавляем в PATH
export PATH="$(pwd)/bin:$PATH"

# Очищаем временные файлы
rm -rf "$TMP_DIR"

# Проверяем установку
if ./bin/pandoc --version >/dev/null 2>&1; then
    echo "✅ Pandoc успешно установлен!"
    ./bin/pandoc --version | head -1
else
    echo "❌ Ошибка установки Pandoc"
    exit 1
fi

echo ""
echo "📝 Pandoc готов к использованию!"
echo "   Путь: $(pwd)/bin/pandoc"

