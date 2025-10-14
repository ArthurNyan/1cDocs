#!/bin/bash

# Генератор веб-документации из Markdown файлов

DOCS_DIR="docs"
DIST_DIR="dist"

echo "🚀 Генерация веб-документации..."

# Создаем dist директорию
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

# Копируем стили и скрипты
cp web-styles.css "$DIST_DIR/styles.css"
cp web-script.js "$DIST_DIR/script.js"

# Функция для генерации навигации
generate_nav() {
    local current_path="$1"
    cat << 'EOF'
<div class="nav-section">
<h3>🎯 Инициация проекта</h3>
<ul>
<li><a href="/Устав_проекта.html">Устав проекта</a></li>
</ul>
</div>

<div class="nav-section">
<h3>📊 Базовые планы</h3>
<ul>
<li><a href="/Базовый_план_по_содержанию.html">Базовый план по содержанию</a></li>
<li><a href="/Базовое_расписание.html">Базовое расписание</a></li>
<li><a href="/Базовый_план_по_стоимости.html">Базовый план по стоимости</a></li>
</ul>
</div>

<div class="nav-section">
<h3>📋 Планы управления</h3>
<ul>
<li><a href="/План_управления_содержанием.html">План управления содержанием</a></li>
<li><a href="/План_управления_требованиями.html">План управления требованиями</a></li>
<li><a href="/План_управления_расписанием.html">План управления расписанием</a></li>
<li><a href="/План_управления_стоимостью.html">План управления стоимостью</a></li>
<li><a href="/План_управления_качеством.html">План управления качеством</a></li>
<li><a href="/План_совершенствования_процессов.html">План совершенствования процессов</a></li>
<li><a href="/План_управления_человеческими_ресурсами.html">План управления человеческими ресурсами</a></li>
<li><a href="/План_управления_коммуникациями.html">План управления коммуникациями</a></li>
<li><a href="/План_управления_рисками.html">План управления рисками</a></li>
<li><a href="/План_управления_закупками.html">План управления закупками</a></li>
<li><a href="/План_управления_заинтересованными_сторонами.html">План управления заинтересованными сторонами</a></li>
</ul>
</div>

<div class="nav-section">
<h3>📖 Пользовательская документация</h3>
<ul>
<li><a href="/Инструкция_Пользователя.html">Инструкция пользователя</a></li>
</ul>
</div>
EOF
}

# Функция для создания HTML страницы
create_page() {
    local md_file="$1"
    local output_file="$2"
    local title="$3"
    local breadcrumb="$4"
    
    # Конвертируем MD в HTML через pandoc
    local content=$(pandoc "$md_file" -f markdown -t html)
    
    # Создаем полную страницу
    cat > "$output_file" << EOF
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title - Проект 1Стиль</title>
    <link rel="stylesheet" href="/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <nav class="sidebar">
        <div class="sidebar-header">
            <h2>📚 Документация проекта</h2>
            <p class="project-name">Система лояльности 1Стиль</p>
        </div>
        $(generate_nav)
    </nav>
    
    <main class="content">
        <div class="breadcrumb">
            <a href="/index.html">Главная</a> $breadcrumb
        </div>
        <article class="markdown-body">
            $content
        </article>
        <footer class="doc-footer">
            <p>Документация проекта "Реализация системы лояльности на основе суммы выкупа"</p>
            <p>ООО «1Стиль» • PM Book 5-я редакция • 2025</p>
        </footer>
    </main>
    
    <script src="/script.js"></script>
</body>
</html>
EOF
}

# Создаем главную страницу
echo "📄 Создание главной страницы..."
cat > "$DIST_DIR/index.html" << 'EOF'
<!DOCTYPE html>
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
            <div class="doc-section">
                <h2>🎯 Инициация проекта</h2>
                <div class="doc-cards">
                    <a href="Устав_проекта.html" class="doc-card">
                        <h3>Устав проекта</h3>
                        <p>Перейти к документу →</p>
                    </a>
                </div>
            </div>
            
            <div class="doc-section">
                <h2>📊 Базовые планы</h2>
                <div class="doc-cards">
                    <a href="Базовый_план_по_содержанию.html" class="doc-card">
                        <h3>Базовый план по содержанию</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="Базовое_расписание.html" class="doc-card">
                        <h3>Базовое расписание</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="Базовый_план_по_стоимости.html" class="doc-card">
                        <h3>Базовый план по стоимости</h3>
                        <p>Перейти к документу →</p>
                    </a>
                </div>
            </div>
            
            <div class="doc-section">
                <h2>📋 Планы управления</h2>
                <div class="doc-cards">
                    <a href="План_управления_содержанием.html" class="doc-card">
                        <h3>План управления содержанием</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="План_управления_требованиями.html" class="doc-card">
                        <h3>План управления требованиями</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="План_управления_расписанием.html" class="doc-card">
                        <h3>План управления расписанием</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="План_управления_стоимостью.html" class="doc-card">
                        <h3>План управления стоимостью</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="План_управления_качеством.html" class="doc-card">
                        <h3>План управления качеством</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="План_совершенствования_процессов.html" class="doc-card">
                        <h3>План совершенствования процессов</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="План_управления_человеческими_ресурсами.html" class="doc-card">
                        <h3>План управления человеческими ресурсами</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="План_управления_коммуникациями.html" class="doc-card">
                        <h3>План управления коммуникациями</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="План_управления_рисками.html" class="doc-card">
                        <h3>План управления рисками</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="План_управления_закупками.html" class="doc-card">
                        <h3>План управления закупками</h3>
                        <p>Перейти к документу →</p>
                    </a>
                    <a href="План_управления_заинтересованными_сторонами.html" class="doc-card">
                        <h3>План управления заинтересованными сторонами</h3>
                        <p>Перейти к документу →</p>
                    </a>
                </div>
            </div>
            
            <div class="doc-section">
                <h2>📖 Пользовательская документация</h2>
                <div class="doc-cards">
                    <a href="Инструкция_Пользователя.html" class="doc-card">
                        <h3>Инструкция пользователя</h3>
                        <p>Перейти к документу →</p>
                    </a>
                </div>
            </div>
        </section>
        
        <footer class="landing-footer">
            <p>Заказчик: ИП Сорокин Г.В. • Исполнитель: ООО «1Стиль»</p>
        </footer>
    </div>
</body>
</html>
EOF

# Генерируем страницы документов
doc_count=0

# Массив документов для генерации
declare -A docs=(
    ["Устав_проекта"]="Устав проекта|Инициация проекта"
    ["Базовый_план_по_содержанию"]="Базовый план по содержанию|Базовые планы"
    ["Базовое_расписание"]="Базовое расписание|Базовые планы"
    ["Базовый_план_по_стоимости"]="Базовый план по стоимости|Базовые планы"
    ["План_управления_содержанием"]="План управления содержанием|Планы управления"
    ["План_управления_требованиями"]="План управления требованиями|Планы управления"
    ["План_управления_расписанием"]="План управления расписанием|Планы управления"
    ["План_управления_стоимостью"]="План управления стоимостью|Планы управления"
    ["План_управления_качеством"]="План управления качеством|Планы управления"
    ["План_совершенствования_процессов"]="План совершенствования процессов|Планы управления"
    ["План_управления_человеческими_ресурсами"]="План управления человеческими ресурсами|Планы управления"
    ["План_управления_коммуникациями"]="План управления коммуникациями|Планы управления"
    ["План_управления_рисками"]="План управления рисками|Планы управления"
    ["План_управления_закупками"]="План управления закупками|Планы управления"
    ["План_управления_заинтересованными_сторонами"]="План управления заинтересованными сторонами|Планы управления"
)

for doc_path in "${!docs[@]}"; do
    IFS='|' read -r title section <<< "${docs[$doc_path]}"
    
    # Определяем имя MD файла
    if [ "$doc_path" = "Инструкция_Пользователя" ]; then
        md_file="$DOCS_DIR/$doc_path/ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md"
    else
        md_file="$DOCS_DIR/$doc_path/$doc_path.md"
    fi
    
    if [ -f "$md_file" ]; then
        echo "📝 Генерация: $title..."
        breadcrumb="<span>→</span> <span>$section</span> <span>→</span> <span>$title</span>"
        create_page "$md_file" "$DIST_DIR/$doc_path.html" "$title" "$breadcrumb"
        ((doc_count++))
    else
        echo "⚠️  Файл не найден: $md_file"
    fi
done

# Инструкция пользователя
md_file="$DOCS_DIR/Инструкция_Пользователя/ИНСТРУКЦИЯ_ПОЛЬЗОВАТЕЛЯ.md"
if [ -f "$md_file" ]; then
    echo "📝 Генерация: Инструкция пользователя..."
    breadcrumb="<span>→</span> <span>Пользовательская документация</span> <span>→</span> <span>Инструкция пользователя</span>"
    create_page "$md_file" "$DIST_DIR/Инструкция_Пользователя.html" "Инструкция пользователя" "$breadcrumb"
    ((doc_count++))
fi

echo ""
echo "✅ Успешно сгенерировано документов: $((doc_count + 1))"
echo "📁 Документация создана в папке: $DIST_DIR/"
echo ""
echo "🌐 Для просмотра откройте: $DIST_DIR/index.html"

