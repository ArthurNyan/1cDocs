# 🐳 Docker Setup

Этот проект использует Docker для обеспечения одинакового окружения сборки везде.

## 📋 Требования

- Docker Desktop (или Docker Engine + Docker Compose)
- Make (опционально, для удобных команд)

## 🚀 Быстрый старт

### Вариант 1: NPM скрипты

```bash
# Сборка веб-документации
npm run build

# Запуск локального сервера
npm run dev

# Генерация PDF
npm run pdf
```

### Вариант 2: Make команды

```bash
# Показать все доступные команды
make help

# Сборка в Docker
make docker-build

# Запуск сервера в Docker
make docker-serve

# Генерация PDF в Docker
make docker-pdf

# Полная сборка (HTML + PDF + сервер)
make docker-all
```

### Вариант 3: Docker Compose напрямую

```bash
# Сборка веб-документации
docker-compose run --rm build

# Запуск веб-сервера
docker-compose up web

# Генерация PDF
docker-compose run --rm pdf

# Остановка и очистка
docker-compose down
```

## 📂 Структура Docker

### `Dockerfile`
**Назначение:** Сборка HTML документации

**Базовый образ:** `pandoc/core:3.1.8`

**Что включает:**
- Pandoc 3.1.8
- Bash
- Python 3

**Использование:**
```bash
docker build -t 1c-docs-builder .
docker run -v $(pwd)/dist:/app/dist 1c-docs-builder
```

### `Dockerfile.pdf`
**Назначение:** Генерация PDF документов

**Базовый образ:** `pandoc/latex:3.1.8`

**Что включает:**
- Pandoc 3.1.8
- LaTeX
- WeasyPrint
- Python 3

**Использование:**
```bash
docker build -f Dockerfile.pdf -t 1c-docs-pdf .
docker run -v $(pwd)/docs:/app/docs 1c-docs-pdf
```

### `docker-compose.yml`
**Назначение:** Оркестрация всех сервисов

**Сервисы:**

1. **build** - Сборка HTML
   - Монтирует: `docs/`, `templates/`, `styles/`, `dist/`
   - Команда: `bash scripts/generate_web_simple.sh`

2. **web** - Веб-сервер
   - Порт: `8000`
   - Монтирует: `dist/` (только чтение)
   - URL: http://localhost:8000

3. **pdf** - Генерация PDF
   - Монтирует: `docs/`, `styles/`
   - Команда: `bash scripts/generate_all_pdfs.sh`

## 🔧 Makefile команды

| Команда | Описание |
|---------|----------|
| `make help` | Показать все команды |
| **Локальные (без Docker)** |
| `make build` | Собрать веб-документацию |
| `make pdf` | Сгенерировать PDF |
| `make serve` | Запустить веб-сервер |
| `make clean` | Очистить `dist/` |
| **Docker команды** |
| `make docker-build` | Собрать в Docker |
| `make docker-pdf` | PDF в Docker |
| `make docker-serve` | Сервер в Docker |
| `make docker-clean` | Очистить Docker |
| **Комплексные** |
| `make all` | Сборка + сервер |
| `make docker-all` | HTML + PDF + сервер (Docker) |

## 📝 NPM скрипты

| Команда | Описание |
|---------|----------|
| `npm run build` | Сборка в Docker |
| `npm run build:local` | Сборка локально (без Docker) |
| `npm run dev` | Сервер в Docker |
| `npm run dev:local` | Сервер локально |
| `npm run pdf` | PDF в Docker |
| `npm run pdf:local` | PDF локально |
| `npm run clean` | Очистить `dist/` |
| `npm run deploy` | Деплой на Vercel |

## 🌐 Vercel Deployment

⚠️ **ВАЖНО:** Vercel **НЕ** поддерживает Docker Compose!

### Для Vercel используется другой подход:

**Локально (разработка):**
```bash
npm run build          # Использует Docker
```

**На Vercel (production):**
```bash
npm run vercel-build   # Использует install-pandoc.sh + bash скрипт
```

### Конфигурация

В `vercel.json` указано:
```json
{
  "buildCommand": "bash install-pandoc.sh && cd scripts && bash generate_web_simple.sh"
}
```

### Как работает сборка на Vercel

1. **Установка Pandoc** через `install-pandoc.sh`:
   - Скачивает Pandoc с GitHub
   - Устанавливает в `./bin/pandoc`
   - Не требует Docker

2. **Генерация HTML** через `generate_web_simple.sh`:
   - Использует локальный Pandoc из `./bin/`
   - Создаёт HTML в `dist/`

3. **Деплой** содержимого `dist/`

📖 **Подробнее:** [VERCEL_DEPLOYMENT.md](VERCEL_DEPLOYMENT.md)

## 🐛 Отладка

### Проблема: Docker не находит pandoc

**Решение:** Используйте официальный образ `pandoc/core`
```bash
docker pull pandoc/core:3.1.8
```

### Проблема: Права доступа к файлам

**Решение:** Docker монтирует volume, права сохраняются
```bash
# Linux/macOS
sudo chown -R $USER:$USER dist/

# Windows (WSL)
# Проблем обычно нет
```

### Проблема: Медленная сборка

**Решение:** Используйте Docker layer caching
```bash
# Пересоберите образ без кэша
docker-compose build --no-cache
```

### Проблема: Порт 8000 занят

**Решение:** Измените порт в `docker-compose.yml`
```yaml
ports:
  - "8080:8000"  # Внешний:Внутренний
```

## 📊 Производительность

| Метод | Время сборки | Размер |
|-------|--------------|--------|
| Локально (bash) | ~1-2 сек | - |
| Docker (первый раз) | ~10-15 сек | ~300 MB |
| Docker (кэш) | ~2-3 сек | ~300 MB |

## 🔍 Логи и отладка

### Просмотр логов сборки
```bash
docker-compose run --rm build 2>&1 | tee build.log
```

### Интерактивный режим
```bash
# Запустить bash в контейнере
docker-compose run --rm build bash

# Внутри контейнера
cd scripts
bash generate_web_simple.sh
```

### Проверка образа
```bash
# Список образов
docker images | grep 1c-docs

# Запустить контейнер
docker run -it 1c-docs-builder bash
```

## 🎯 Best Practices

1. **Используйте Docker для CI/CD** - одинаковое окружение везде
2. **Локально без Docker** - быстрее для разработки (`npm run build:local`)
3. **Docker для production** - гарантия совместимости
4. **Монтируйте только нужные папки** - быстрее сборка
5. **Используйте `.dockerignore`** - меньше контекст сборки

## 📚 Дополнительно

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Pandoc Docker Images](https://hub.docker.com/r/pandoc/core)
- [Vercel Docker Support](https://vercel.com/docs/build-output-api/v3#dockerfile)

---

**Готово!** Теперь у вас есть полноценный Docker setup для проекта! 🎉

