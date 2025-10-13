#!/usr/bin/env python3
"""
Генератор веб-документации из Markdown файлов
"""

import os
import shutil
import markdown
from pathlib import Path
import json

# Конфигурация
DOCS_DIR = "docs"
DIST_DIR = "dist"
TEMPLATE_DIR = "web_templates"

# Структура документации
DOCS_STRUCTURE = [
    {
        "title": "Инициация проекта",
        "icon": "🎯",
        "docs": [
            {"path": "Устав_проекта", "title": "Устав проекта"}
        ]
    },
    {
        "title": "Базовые планы",
        "icon": "📊",
        "docs": [
            {"path": "Базовый_план_по_содержанию", "title": "Базовый план по содержанию"},
            {"path": "Базовое_расписание", "title": "Базовое расписание"},
            {"path": "Базовый_план_по_стоимости", "title": "Базовый план по стоимости"}
        ]
    },
    {
        "title": "Планы управления",
        "icon": "📋",
        "docs": [
            {"path": "План_управления_проектом", "title": "План управления проектом"},
            {"path": "План_управления_содержанием", "title": "План управления содержанием"},
            {"path": "План_управления_требованиями", "title": "План управления требованиями"},
            {"path": "План_управления_расписанием", "title": "План управления расписанием"},
            {"path": "План_управления_стоимостью", "title": "План управления стоимостью"},
            {"path": "План_управления_качеством", "title": "План управления качеством"},
            {"path": "План_совершенствования_процессов", "title": "План совершенствования процессов"},
            {"path": "План_управления_человеческими_ресурсами", "title": "План управления человеческими ресурсами"},
            {"path": "План_управления_коммуникациями", "title": "План управления коммуникациями"},
            {"path": "План_управления_рисками", "title": "План управления рисками"},
            {"path": "План_управления_закупками", "title": "План управления закупками"},
            {"path": "План_управления_заинтересованными_сторонами", "title": "План управления заинтересованными сторонами"}
        ]
    },
    {
        "title": "Пользовательская документация",
        "icon": "📖",
        "docs": [
            {"path": "Инструкция_Пользователя", "title": "Инструкция пользователя", "file": "ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md"}
        ]
    }
]

def create_html_template():
    """Создает HTML шаблон"""
    return '''<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title} - Проект 1Стиль</title>
    <link rel="stylesheet" href="/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <nav class="sidebar">
        <div class="sidebar-header">
            <h2>📚 Документация проекта</h2>
            <p class="project-name">Система лояльности 1Стиль</p>
        </div>
        {navigation}
    </nav>
    
    <main class="content">
        <div class="breadcrumb">
            <a href="/index.html">Главная</a> {breadcrumb}
        </div>
        <article class="markdown-body">
            {content}
        </article>
        <footer class="doc-footer">
            <p>Документация проекта "Реализация системы лояльности на основе суммы выкупа"</p>
            <p>ООО «1Стиль» • PM Book 5-я редакция • 2025</p>
        </footer>
    </main>
    
    <script src="/script.js"></script>
</body>
</html>'''

def create_index_template():
    """Создает шаблон главной страницы"""
    return '''<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Документация проекта 1Стиль</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="landing-page">
        <header class="landing-header">
            <h1>📚 Документация проекта</h1>
            <h2>Реализация системы лояльности на основе суммы выкупа</h2>
            <p class="subtitle">Магазин одежды "1Стиль" • PM Book 5-я редакция • 2025</p>
        </header>
        
        <section class="project-info">
            <div class="info-card">
                <i class="fas fa-calendar"></i>
                <h3>Период</h3>
                <p>Август - Декабрь 2025</p>
            </div>
            <div class="info-card">
                <i class="fas fa-ruble-sign"></i>
                <h3>Бюджет</h3>
                <p>520,000 ₽ + резерв 80,000 ₽</p>
            </div>
            <div class="info-card">
                <i class="fas fa-users"></i>
                <h3>Команда</h3>
                <p>6-9 специалистов</p>
            </div>
            <div class="info-card">
                <i class="fas fa-clock"></i>
                <h3>Срок</h3>
                <p>133 рабочих дня</p>
            </div>
        </section>
        
        <section class="docs-sections">
            {sections}
        </section>
        
        <footer class="landing-footer">
            <p>Заказчик: ИП Сорокин Г.В. • Исполнитель: ООО «1Стиль»</p>
        </footer>
    </div>
</body>
</html>'''

def generate_navigation(current_path=""):
    """Генерирует навигацию"""
    nav_html = ""
    for section in DOCS_STRUCTURE:
        nav_html += f'<div class="nav-section">'
        nav_html += f'<h3>{section["icon"]} {section["title"]}</h3>'
        nav_html += '<ul>'
        for doc in section["docs"]:
            active = "active" if current_path == doc["path"] else ""
            nav_html += f'<li class="{active}"><a href="/{doc["path"]}.html">{doc["title"]}</a></li>'
        nav_html += '</ul></div>'
    return nav_html

def generate_index_sections():
    """Генерирует секции для главной страницы"""
    sections_html = ""
    for section in DOCS_STRUCTURE:
        sections_html += f'''
        <div class="doc-section">
            <h2>{section["icon"]} {section["title"]}</h2>
            <div class="doc-cards">
        '''
        for doc in section["docs"]:
            sections_html += f'''
                <a href="{doc["path"]}.html" class="doc-card">
                    <h3>{doc["title"]}</h3>
                    <p>Перейти к документу →</p>
                </a>
            '''
        sections_html += '</div></div>'
    return sections_html

def convert_md_to_html(md_path):
    """Конвертирует Markdown в HTML"""
    with open(md_path, 'r', encoding='utf-8') as f:
        md_content = f.read()
    
    # Используем markdown с расширениями
    html = markdown.markdown(
        md_content,
        extensions=['tables', 'fenced_code', 'toc', 'attr_list']
    )
    return html

def generate_docs():
    """Генерирует всю документацию"""
    # Создаем dist директорию
    if os.path.exists(DIST_DIR):
        shutil.rmtree(DIST_DIR)
    os.makedirs(DIST_DIR)
    
    print("🚀 Генерация веб-документации...")
    
    # Генерируем главную страницу
    print("📄 Создание главной страницы...")
    index_html = create_index_template().format(
        sections=generate_index_sections()
    )
    with open(f"{DIST_DIR}/index.html", 'w', encoding='utf-8') as f:
        f.write(index_html)
    
    # Генерируем страницы документов
    doc_count = 0
    for section in DOCS_STRUCTURE:
        for doc in section["docs"]:
            doc_path = doc["path"]
            doc_title = doc["title"]
            
            # Определяем имя файла
            md_filename = doc.get("file", f"{doc_path}.md")
            md_file_path = f"{DOCS_DIR}/{doc_path}/{md_filename}"
            
            if not os.path.exists(md_file_path):
                print(f"⚠️  Файл не найден: {md_file_path}")
                continue
            
            print(f"📝 Генерация: {doc_title}...")
            
            # Конвертируем MD в HTML
            content_html = convert_md_to_html(md_file_path)
            
            # Создаем breadcrumb
            breadcrumb = f'<span>→</span> <span>{section["title"]}</span> <span>→</span> <span>{doc_title}</span>'
            
            # Генерируем страницу
            page_html = create_html_template().format(
                title=doc_title,
                navigation=generate_navigation(doc_path),
                breadcrumb=breadcrumb,
                content=content_html
            )
            
            # Сохраняем
            with open(f"{DIST_DIR}/{doc_path}.html", 'w', encoding='utf-8') as f:
                f.write(page_html)
            
            doc_count += 1
    
    print(f"\n✅ Успешно сгенерировано документов: {doc_count + 1}")
    print(f"📁 Документация создана в папке: {DIST_DIR}/")

if __name__ == "__main__":
    generate_docs()

