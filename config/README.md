# ⚙️ Конфигурационные файлы

Эта папка содержит конфигурацию для деплоя и Git.

## 📁 Файлы

### `vercel.json`
**Назначение:** Конфигурация для Vercel (хостинг)

**Содержимое:**
```json
{
  "buildCommand": "cd scripts && bash generate_web_simple.sh",
  "outputDirectory": "dist",
  "cleanUrls": true
}
```

**Параметры:**
- `buildCommand` - команда сборки проекта
- `outputDirectory` - папка с готовым сайтом
- `cleanUrls` - URL без `.html` расширения
- `trailingSlash` - без слеша в конце URL

**Симлинк:**
Файл доступен из корня через симлинк: `../vercel.json → config/vercel.json`

---

### `.gitignore`
**Назначение:** Игнорирование файлов в Git

**Что игнорируется:**
- `node_modules/` - зависимости NPM
- `dist/*.html` - сгенерированные HTML (кроме index.html)
- `.DS_Store` - системные файлы macOS
- `.vercel/` - кэш Vercel
- `*.log` - логи

**Симлинк:**
Файл доступен из корня через симлинк: `../.gitignore → config/.gitignore`

---

### `.vercelignore`
**Назначение:** Файлы, не загружаемые на Vercel

**Что не загружается:**
- `node_modules/` - зависимости
- `docs/**/*.pdf` - PDF файлы (большие)
- `.git/` - история Git
- `*.log` - логи

**Симлинк:**
Файл доступен из корня через симлинк: `../.vercelignore → config/.vercelignore`

---

## 🔗 Симлинки

Vercel требует конфигурационные файлы в корне проекта. Мы используем симлинки:

```bash
# Создание симлинков
ln -sf config/vercel.json vercel.json
ln -sf config/.gitignore .gitignore
ln -sf config/.vercelignore .vercelignore
```

**Преимущества:**
- Конфиги в одной папке
- Чистый корень проекта
- Vercel видит файлы в корне

## 🛠️ Редактирование

### Изменить команду сборки
```json
{
  "buildCommand": "your-custom-command"
}
```

### Добавить переменные окружения
```json
{
  "env": {
    "NODE_ENV": "production"
  }
}
```

### Настроить редиректы
```json
{
  "redirects": [
    {
      "source": "/old-path",
      "destination": "/new-path",
      "permanent": true
    }
  ]
}
```

## 📚 Документация

- [Vercel Configuration](https://vercel.com/docs/configuration)
- [Git Ignore Patterns](https://git-scm.com/docs/gitignore)

---

**Последнее обновление:** Октябрь 2025

