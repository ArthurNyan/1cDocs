#!/bin/bash

# Скрипт для генерации всех PDF документов проекта

echo "=== Генерация PDF документов проекта ==="
echo ""

# Переход в директорию docs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../docs"

# Поиск всех .md файлов и генерация PDF
find . -name "*.md" -type f | while read -r mdfile; do
    # Получаем директорию и имя файла
    dir=$(dirname "$mdfile")
    filename=$(basename "$mdfile" .md)
    
    # Путь к выходному PDF
    pdffile="$dir/${filename}.pdf"
    
    echo "Генерация: $mdfile -> $pdffile"
    
    # Генерация PDF
    pandoc "$mdfile" \
        -o "$pdffile" \
        --pdf-engine=weasyprint \
        --css="$SCRIPT_DIR/../styles/pdf-style.css" \
        --toc \
        --toc-depth=3 \
        2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✓ Успешно создан: $pdffile"
    else
        echo "✗ Ошибка при создании: $pdffile"
    fi
    echo ""
done

echo "=== Генерация завершена ==="
echo ""
echo "Создан список документов:"
find . -name "*.pdf" -type f | sort

