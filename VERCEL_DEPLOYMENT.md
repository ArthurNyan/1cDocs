# 🚀 Vercel Deployment Guide

Подробная инструкция по деплою проекта на Vercel.

## 📋 Оглавление

- [Почему не Docker?](#почему-не-docker)
- [Как работает сборка на Vercel](#как-работает-сборка-на-vercel)
- [Процесс деплоя](#процесс-деплоя)
- [Troubleshooting](#troubleshooting)

---

## ❌ Почему не Docker?

Vercel **НЕ поддерживает** Docker Compose в процессе сборки:
- Команда `docker-compose` недоступна
- Нельзя использовать `Dockerfile` напрямую
- Build Environment имеет ограничения по доступу к Docker

### Решение

Вместо Docker на Vercel используется:
1. **Скрипт установки Pandoc** (`install-pandoc.sh`)
   - Скачивает бинарный файл Pandoc с GitHub
   - Устанавливает его локально в `./bin/pandoc`
   - Не требует sudo прав

2. **Обычная bash сборка** (`generate_web_simple.sh`)
   - Использует локально установленный Pandoc
   - Генерирует HTML в `dist/`

---

## 🔧 Как работает сборка на Vercel

### Шаг 1: Установка зависимостей

```bash
npm install
```

**Результат:** Ничего не устанавливается (зависимостей нет в `package.json`)

### Шаг 2: Build Command

Vercel автоматически запускает команду из `vercel.json`:

```json
{
  "buildCommand": "bash install-pandoc.sh && cd scripts && bash generate_web_simple.sh"
}
```

**Или** из `package.json`:

```json
{
  "scripts": {
    "vercel-build": "bash install-pandoc.sh && cd scripts && bash generate_web_simple.sh"
  }
}
```

### Шаг 3: Установка Pandoc

**Скрипт:** `install-pandoc.sh`

```bash
#!/bin/bash

# 1. Определяет архитектуру (x86_64 или aarch64)
ARCH=$(uname -m)

# 2. Скачивает Pandoc с GitHub
curl -L "https://github.com/jgm/pandoc/releases/download/3.1.8/pandoc-3.1.8-linux-amd64.tar.gz"

# 3. Распаковывает и устанавливает в ./bin/pandoc
tar -xzf pandoc.tar.gz
cp pandoc-3.1.8/bin/pandoc ./bin/

# 4. Делает исполняемым
chmod +x ./bin/pandoc
```

**Результат:** Pandoc установлен в `./bin/pandoc`

### Шаг 4: Генерация HTML

**Скрипт:** `scripts/generate_web_simple.sh`

```bash
#!/bin/bash

# 1. Определяет, какой Pandoc использовать
if [ -x "../bin/pandoc" ]; then
    PANDOC="../bin/pandoc"  # Vercel или локальная установка
else
    PANDOC="pandoc"          # Системный Pandoc
fi

# 2. Копирует шаблон index.html
cp templates/index.html dist/index.html

# 3. Копирует стили и скрипты
cp styles/web-styles.css dist/styles.css
cp styles/web-script.js dist/script.js

# 4. Генерирует HTML для каждого документа
for doc in docs/**/*.md; do
    content=$($PANDOC "$doc" -f markdown -t html)
    # ... создаёт HTML страницу с навигацией
done
```

**Результат:** Веб-документация в `dist/`

### Шаг 5: Деплой

Vercel деплоит содержимое `dist/`:
- `index.html` - главная страница
- `*.html` - страницы документов
- `styles.css` - стили
- `script.js` - JavaScript

---

## 🚀 Процесс деплоя

### Автоматический деплой (GitHub)

1. **Push в GitHub**
   ```bash
   git add .
   git commit -m "Update docs"
   git push origin master
   ```

2. **Vercel автоматически:**
   - Обнаруживает новый коммит
   - Клонирует репозиторий
   - Запускает `npm install` (пустой)
   - Запускает `vercel-build`:
     - `install-pandoc.sh` → устанавливает Pandoc
     - `generate_web_simple.sh` → генерирует HTML
   - Деплоит `dist/` на CDN
   - Создаёт preview URL

3. **Результат:**
   - **Production:** `https://your-project.vercel.app`
   - **Preview:** `https://your-project-git-branch.vercel.app`

### Ручной деплой

```bash
# 1. Установите Vercel CLI (один раз)
npm install -g vercel

# 2. Войдите в аккаунт
vercel login

# 3. Деплой
npm run deploy
# или
vercel --prod
```

---

## 📊 Различия: Docker vs Vercel

| Аспект | Docker (локально) | Vercel |
|--------|------------------|--------|
| **Pandoc** | В Docker образе | Скачивается скриптом |
| **Сборка** | `docker-compose run build` | `bash install-pandoc.sh && ...` |
| **Окружение** | Изолированный контейнер | Build environment Vercel |
| **Время сборки** | ~10-30 сек (после 1-го раза) | ~20-40 сек |
| **Зависимости** | Docker + Docker Compose | Только bash |
| **PDF генерация** | ✅ Поддерживается | ❌ Не поддерживается* |

*PDF можно генерировать локально, а затем коммитить в Git (если нужно)

---

## 🐛 Troubleshooting

### ❌ Error: `docker-compose: command not found`

**Причина:** Vercel пытается использовать Docker

**Решение:** Убедитесь, что `vercel.json` и `package.json` используют правильные команды:

```json
// vercel.json
{
  "buildCommand": "bash install-pandoc.sh && cd scripts && bash generate_web_simple.sh"
}

// package.json
{
  "scripts": {
    "vercel-build": "bash install-pandoc.sh && cd scripts && bash generate_web_simple.sh"
  }
}
```

### ❌ Error: `pandoc: command not found`

**Причина:** Pandoc не установлен или скрипт установки не сработал

**Решение:**
1. Проверьте логи сборки Vercel
2. Убедитесь, что `install-pandoc.sh` исполняемый:
   ```bash
   chmod +x install-pandoc.sh
   git add install-pandoc.sh
   git commit -m "Make install-pandoc.sh executable"
   ```

### ❌ Error: `No such file or directory: temp_content.html`

**Причина:** Старая версия скрипта использует временный файл

**Решение:** Обновите `generate_web_simple.sh`:
```bash
# Старая версия (не работает)
pandoc "$md_file" -f markdown -t html -o "$DIST_DIR/temp_content.html"
cat "$DIST_DIR/temp_content.html"

# Новая версия (работает)
content=$($PANDOC "$md_file" -f markdown -t html)
echo "$content"
```

### ⚠️ Build успешен, но страницы пустые

**Причина:** Markdown файлы не найдены или пути неверные

**Решение:**
1. Проверьте структуру `docs/`:
   ```
   docs/
   ├── Устав_проекта/
   │   └── Устав_проекта.md
   ├── Базовый_план_по_содержанию/
   │   └── Базовый_план_по_содержанию.md
   ...
   ```

2. Проверьте пути в `generate_web_simple.sh`:
   ```bash
   DOCS_DIR="../docs"  # Относительно scripts/
   ```

### 📦 Как проверить сборку локально (симуляция Vercel)

```bash
# 1. Удалите системный Pandoc (временно)
which pandoc
# /usr/local/bin/pandoc

# 2. Запустите сборку как на Vercel
rm -rf ./bin dist/*
bash install-pandoc.sh
cd scripts && bash generate_web_simple.sh

# 3. Проверьте результат
ls -lh dist/
python3 -m http.server 8000 --directory dist
```

---

## 📝 Чеклист перед деплоем

- [ ] `install-pandoc.sh` исполняемый
- [ ] `vercel.json` использует правильную команду (без Docker)
- [ ] `package.json` содержит `vercel-build` скрипт
- [ ] `generate_web_simple.sh` использует `$PANDOC` переменную
- [ ] `templates/index.html` существует
- [ ] Все `.md` файлы на месте в `docs/`
- [ ] Локальная сборка работает: `npm run build:local`

---

## 🎯 Итого

### Для локальной разработки:
```bash
# С Docker (рекомендуется)
npm run build          # docker-compose run --rm build

# Без Docker
npm run build:local    # bash скрипт
```

### Для Vercel:
```bash
# Автоматически при push
git push origin master

# Вручную
npm run deploy
```

**Ключевое отличие:** Docker только для локальной разработки, Vercel использует bash скрипты.

---

## 📚 Ссылки

- [Vercel Documentation](https://vercel.com/docs)
- [Vercel Build Step](https://vercel.com/docs/build-step)
- [Pandoc Releases](https://github.com/jgm/pandoc/releases)
- [Проект на GitHub](https://github.com/ArthurNyan/1cDocs)

