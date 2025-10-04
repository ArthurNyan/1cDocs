# Проект документации магазина одежды "1Стиль"

Этот проект содержит документацию для информационной системы магазина одежды "1Стиль", включая техническое задание, инструкции пользователя и структуру конфигурации 1С.

## Структура проекта

- `ТЗ.md` - техническое задание на систему лояльности
- `ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md` - подробная инструкция пользователя
- `Инструкция_Пользователя.pdf` - PDF версия инструкции
- `УСТАНОВКА.md` - подробная инструкция по установке инструментов
- `scripts.sh` - скрипт автоматизации работы с проектом
- `unpacked_config/` - распакованная конфигурация 1С
- `configuration/` - изображения для документации
- Стили CSS для формирования PDF (`pdf-style.css`, `simple-style.css`)

## Быстрый старт

1. **Установить зависимости** (см. `УСТАНОВКА.md`)
2. **Проверить готовность**: `./scripts.sh check`
3. **Начать работу**: выбрать нужную команду из раздела "Автоматизация работы"

## Конвертация конфигурации CF в unpacked_config

Для работы с конфигурацией 1С необходимо распаковать файл `.cf`:

```bash
# Установка v8unpack (если не установлен)
# Для macOS:
brew install v8unpack

# Для Ubuntu/Debian:
sudo apt-get install v8unpack

# Для Windows - скачать с GitHub: https://github.com/1C-Company/v8unpack

# Распаковка конфигурации
v8unpack -E config.cf unpacked_config/
```

Где:

- `config.cf` - файл конфигурации 1С
- `unpacked_config/` - директория с распакованными файлами

## Работа с Pandoc

### Установка Pandoc

```bash
# macOS
brew install pandoc

# Ubuntu/Debian
sudo apt-get install pandoc

# Windows - скачать с официального сайта: https://pandoc.org/installing.html
```

### Основные команды конвертации

```bash
# Markdown в PDF с кастомным стилем
pandoc ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md -o "Инструкция_Пользователя.pdf" --pdf-engine=weasyprint --css=pdf-style.css

# Markdown в HTML
pandoc ТЗ.md -o "ТЗ.html" --standalone --css=simple-style.css

# Markdown в Word
pandoc ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md -o "Инструкция_Пользователя.docx"
```

### Необходимые дополнительные компоненты

Для корректной работы с PDF через pandoc могут потребоваться:

```bash
# Для macOS
brew install weasyprint

# Для Ubuntu/Debian
sudo apt-get install python3-weasyprint

# Альтернативные PDF движки
brew install wkhtmltopdf  # или sudo apt-get install wkhtmltopdf
brew install prince        # платная лицензия
```

### Полезные параметры pandoc

```bash
# Добавление оглавления
pandoc document.md -o output.pdf --toc --toc-depth=3

# С сохранением метаданных
pandoc document.md -o output.pdf --pdf-engine=weasyprint --css=style.css --metadata author="Автор" --metadata date="2025-01-15"

# С настройкой полей страницы в CSS
pandoc document.md -o output.pdf --pdf-engine=weasyprint --css=pdf-style.css -V geometry:margin=1in
```

### Стили CSS

Проект содержит готовые CSS стили:

- `pdf-style.css` - для генерации PDF документов
- `simple-style.css` - для простого HTML документооборота

## Разработка конфигурации 1С

### Основные объекты системы

Конфигурация включает:

- **Справочники**: Контрагенты, Номенклатура, Организации
- **Документы**: ПоставкаТовара, РеализацияТовара
- **Регистры**: ОстаткиНоменклатуры, СуммаВыкупаКлиента
- **Отчеты**: ОтчетОстаткиНоменклатуры, СуммаВыкупа
- **Подсистемы**: Продажи, Поставки, Отчёты, СправочнаяИнформация

### Система лояльности

Реализована накопительная система лояльности:

- **Базовый клиент** (< 15 тыс. руб.) - без скидки
- **Премиальный клиент** (15-30 тыс. руб.) - скидка 5%
- **VIP клиент** (> 30 тыс. руб.) - скидка 10%

## Автоматизация работы

Для удобства работы с проектом создан скрипт `scripts.sh` с командами:

### Основные команды скрипта

```bash
# Проверить зависимости
./scripts.sh check

# Распаковать конфигурацию CF
./scripts.sh unpack config.cf

# Создать PDF из Markdown
./scripts.sh pdf ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md

# Создать HTML из Markdown  
./scripts.sh html ТЗ.md

# Создать всю документацию
./scripts.sh build

# Показать справку
./scripts.sh help
```

### Ручные команды

```bash
# Распаковка новой конфигурации
v8unpack -E новая_конфигурация.cf unpacked_config/

# Генерация PDF документации
pandoc ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md -o "Инструкция_Пользователя.pdf" --pdf-engine=weasyprint --css=pdf-style.css --toc --toc-depth=3

# Создание документации для всех markdown файлов
for file in *.md; do
  pandoc "$file" -o "${file%.md}.html" --standalone --css=simple-style.css
done
```

## Устранение проблем

### Ошибки с v8unpack

```bash
# Если v8unpack не найден, установите его:
brew install v8unpack  # macOS
sudo apt-get install v8unpack  # Ubuntu/Debian
```

### Ошибки с PDF генерацией

```bash
# Установка WeasyPrint для корректной работы с PDF
brew install weasyprint  # macOS
sudo apt-get install python3-weasyprint  # Ubuntu/Debian

# Альтернатива - использование wkhtmltopdf
brew install wkhtmltopdf
pandoc document.md -o output.pdf --pdf-engine=wkhtmltopdf --css=pdf-style.css
```
