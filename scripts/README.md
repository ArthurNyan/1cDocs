# 📜 Скрипты сборки и генерации

Эта папка содержит все скрипты для автоматизации процессов сборки документации.

## 📁 Файлы

### `generate_web_simple.sh`
**Назначение:** Генерация веб-документации (HTML)

**Использование:**
```bash
cd scripts
bash generate_web_simple.sh
```

**Что делает:**
- Конвертирует Markdown → HTML
- Копирует стили и скрипты в `dist/`
- Создает навигацию и структуру сайта
- Генерирует 17 HTML страниц документов

**Требует:**
- Pandoc
- Markdown файлы в `docs/`
- Стили в `styles/`

---

### `generate_all_pdfs.sh`
**Назначение:** Генерация PDF документов

**Использование:**
```bash
cd scripts
bash generate_all_pdfs.sh
```

**Что делает:**
- Находит все `.md` файлы в `docs/`
- Конвертирует Markdown → PDF
- Применяет стили из `styles/pdf-style.css`
- Создает оглавление (TOC)

**Требует:**
- Pandoc
- WeasyPrint (PDF engine)
- CSS стили для PDF

---

### `scripts.sh`
**Назначение:** Вспомогательные скрипты для работы с 1C

**Использование:**
```bash
cd scripts
bash scripts.sh
```

**Что делает:**
- Распаковка/упаковка 1C конфигураций
- Утилиты для работы с v8unpack

---

## 🔧 NPM интеграция

Все скрипты интегрированы в `package.json`:

```json
{
  "scripts": {
    "build": "cd scripts && bash generate_web_simple.sh",
    "generate:pdf": "cd scripts && bash generate_all_pdfs.sh"
  }
}
```

Вызывайте через NPM:
```bash
npm run build
npm run generate:pdf
```

## 📝 Переменные окружения

Скрипты используют относительные пути:

- `DOCS_DIR="../docs"` - исходная документация
- `DIST_DIR="../dist"` - веб-версия
- `STYLES_DIR="../styles"` - стили и скрипты

## 🐛 Отладка

Если скрипты не работают:

1. **Проверьте права:**
   ```bash
   chmod +x *.sh
   ```

2. **Проверьте зависимости:**
   ```bash
   which pandoc
   which weasyprint
   ```

3. **Запустите с отладкой:**
   ```bash
   bash -x generate_web_simple.sh
   ```

---

**Последнее обновление:** Октябрь 2025

