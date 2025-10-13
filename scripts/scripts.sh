#!/bin/bash

# Скрипты для работы с проектом документации "1Стиль"

set -e  # Остановка при ошибке

echo "=== Рабочие скрипты проекта 1Стиль ==="
echo ""

# Функция для распаковки конфигурации
unpack_config() {
    local cf_file=$1
    local output_dir=${2:-unpacked_config}
    
    if [ ! -f "$cf_file" ]; then
        echo "Ошибка: Файл $cf_file не найден"
        return 1
    fi
    
    echo "Распаковка конфигурации $cf_file в $output_dir..."
    v8unpack -E "$cf_file" "$output_dir/"
    echo "✅ Конфигурация распакована"
}

# Функция для генерации PDF
generate_pdf() {
    local md_file=$1
    local output_file=${2:-"${md_file%.md}.pdf"}
    local css_file=${3:-pdf-style.css}
    
    if [ ! -f "$md_file" ]; then
        echo "Ошибка: Файл $md_file не найден"
        return 1
    fi
    
    echo "Генерация PDF из $md_file..."
    pandoc "$md_file" -o "$output_file" \
        --pdf-engine=weasyprint \
        --css="$css_file" \
        --toc \
        --toc-depth=3 \
        --metadata author="Магазин 1Стиль" \
        --metadata date="$(date +%Y-%m-%d)"
    
    echo "✅ PDF создан: $output_file"
}

# Функция для генерации HTML
generate_html() {
    local md_file=$1
    local output_file=${2:-"${md_file%.md}.html"}
    local css_file=${3:-simple-style.css}
    
    if [ ! -f "$md_file" ]; then
        echo "Ошибка: Файл $md_file не найден"
        return 1
    fi
    
    echo "Генерация HTML из $md_file..."
    pandoc "$md_file" -o "$output_file" \
        --standalone \
        --css="$css_file" \
        --toc \
        --toc-depth=3
    echo "✅ HTML создан: $output_file"
}

# Проверка зависимостей
check_dependencies() {
    echo "Проверка зависимостей..."
    
    local missing_deps=()
    
    if ! command -v v8unpack &> /dev/null; then
        missing_deps+=("v8unpack")
    fi
    
    if ! command -v pandoc &> /dev/null; then
        missing_deps+=("pandoc")
    fi
    
    if ! command -v weasyprint &> /dev/null; then
        missing_deps+=("weasyprint")
    fi
    
    if [ ${#missing_deps[@]} -eq 0 ]; then
        echo "✅ Все зависимости установлены"
    else
        echo "❌ Отсутствуют зависимости:"
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        echo ""
        echo "Установите их с помощью:"
        echo "brew install ${missing_deps[*]}"
        return 1
    fi
}

# Быстрая генерация всей документации
build_all_docs() {
    echo "Генерация всей документации..."
    
    generate_pdf "ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md" "Инструкция_Пользователь_Final.pdf"
    generate_pdf "ТЗ.md" "Техническое_Задание.pdf"
    
    generate_html "ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md" "Инструкция_Пользователь.html"
    generate_html "ТЗ.md" "ТЗ.html"
    
    echo "✅ Вся документация сгенерирована"
}

# Показать справку
show_help() {
    echo "Использование: $0 [команда]"
    echo ""
    echo "Доступные команды:"
    echo "  check          - Проверить зависимости"
    echo "  unpack [file]  - Распаковать CF конфигурацию"
    echo "  pdf [file]     - Создать PDF из Markdown"
    echo "  html [file]    - Создать HTML из Markdown"
    echo "  build          - Создать всю документацию"
    echo "  help           - Показать эту справку"
    echo ""
    echo "Примеры:"
    echo "  $0 check"
    echo "  $0 unpack config.cf"
    echo "  $0 pdf ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md"
    echo "  $0 build"
}

# Основная логика
main() {
    case "${1:-help}" in
        "check")
            check_dependencies
            ;;
        "unpack")
            if [ -z "$2" ]; then
                echo "Ошибка: Укажите файл CF для распаковки"
                echo "Пример: $0 unpack config.cf"
                exit 1
            fi
            unpack_config "$2"
            ;;
        "pdf")
            if [ -z "$2" ]; then
                echo "Ошибка: Укажите файл Markdown"
                echo "Пример: $0 pdf ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md"
                exit 1
            fi
            generate_pdf "$2"
            ;;
        "html")
            if [ -z "$2" ]; then
                echo "Ошибка: Укажите файл Markdown"
                echo "Пример: $0 html ТЗ.md"
                exit 1
            fi
            generate_html "$2"
            ;;
        "build")
            check_dependencies || exit 1
            build_all_docs
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Запуск
main "$@"
