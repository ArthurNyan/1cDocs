// Скрипт для веб-документации

// Мобильное меню
document.addEventListener('DOMContentLoaded', function () {
    // Добавляем кнопку меню для мобильных устройств
    const sidebar = document.querySelector('.sidebar');
    if (sidebar && window.innerWidth <= 768) {
        const menuButton = document.createElement('button');
        menuButton.className = 'menu-toggle';
        menuButton.innerHTML = '<i class="fas fa-bars"></i>';
        menuButton.style.cssText = `
            position: fixed;
            top: 1rem;
            left: 1rem;
            z-index: 1001;
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 0.8rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.2rem;
        `;
        document.body.appendChild(menuButton);

        menuButton.addEventListener('click', function () {
            sidebar.classList.toggle('active');
        });

        // Закрытие меню при клике на ссылку
        const navLinks = sidebar.querySelectorAll('a');
        navLinks.forEach(link => {
            link.addEventListener('click', () => {
                sidebar.classList.remove('active');
            });
        });
    }

    // Плавная прокрутка к якорям
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Подсветка текущего раздела при прокрутке
    const sections = document.querySelectorAll('.markdown-body h2, .markdown-body h3');
    const navLinks = document.querySelectorAll('.nav-section a');

    function highlightNav() {
        let current = '';
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            const scrollPos = window.scrollY + 100;
            if (scrollPos >= sectionTop) {
                current = section.getAttribute('id');
            }
        });

        navLinks.forEach(link => {
            link.classList.remove('current-section');
            if (link.getAttribute('href').includes(current)) {
                link.classList.add('current-section');
            }
        });
    }

    window.addEventListener('scroll', highlightNav);

    // Добавляем ID к заголовкам для якорей
    const headings = document.querySelectorAll('.markdown-body h1, .markdown-body h2, .markdown-body h3');
    headings.forEach((heading, index) => {
        if (!heading.id) {
            heading.id = `section-${index}`;
        }
    });

    // Кнопка "Наверх"
    const scrollToTopBtn = document.createElement('button');
    scrollToTopBtn.innerHTML = '<i class="fas fa-arrow-up"></i>';
    scrollToTopBtn.className = 'scroll-to-top';
    scrollToTopBtn.style.cssText = `
        position: fixed;
        bottom: 2rem;
        right: 2rem;
        background: var(--primary-color);
        color: white;
        border: none;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        cursor: pointer;
        opacity: 0;
        transition: opacity 0.3s;
        z-index: 1000;
        font-size: 1.2rem;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    `;
    document.body.appendChild(scrollToTopBtn);

    window.addEventListener('scroll', () => {
        if (window.scrollY > 300) {
            scrollToTopBtn.style.opacity = '1';
        } else {
            scrollToTopBtn.style.opacity = '0';
        }
    });

    scrollToTopBtn.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });

    // Поиск по документации (простая версия)
    const searchInput = document.createElement('input');
    searchInput.type = 'text';
    searchInput.placeholder = '🔍 Поиск по документу...';
    searchInput.className = 'doc-search';
    searchInput.style.cssText = `
        width: calc(100% - 2rem);
        margin: 1rem;
        padding: 0.8rem;
        border: 1px solid rgba(255,255,255,0.2);
        background: rgba(255,255,255,0.1);
        color: white;
        border-radius: 8px;
        font-size: 0.9rem;
    `;

    if (sidebar) {
        sidebar.insertBefore(searchInput, sidebar.querySelector('.nav-section'));

        searchInput.addEventListener('input', function (e) {
            const searchTerm = e.target.value.toLowerCase();
            const navItems = sidebar.querySelectorAll('.nav-section li');

            navItems.forEach(item => {
                const text = item.textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    }

    // Копирование кода по клику
    const codeBlocks = document.querySelectorAll('pre code');
    codeBlocks.forEach(block => {
        const button = document.createElement('button');
        button.textContent = 'Копировать';
        button.className = 'copy-code-btn';
        button.style.cssText = `
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            padding: 0.3rem 0.8rem;
            background: rgba(255,255,255,0.2);
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
            font-size: 0.8rem;
        `;

        block.parentElement.style.position = 'relative';
        block.parentElement.appendChild(button);

        button.addEventListener('click', () => {
            navigator.clipboard.writeText(block.textContent);
            button.textContent = 'Скопировано!';
            setTimeout(() => {
                button.textContent = 'Копировать';
            }, 2000);
        });
    });

    console.log('📚 Документация загружена успешно!');
});

