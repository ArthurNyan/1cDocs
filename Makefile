.PHONY: help build pdf serve clean docker-build docker-pdf docker-serve docker-clean

# Цвета для вывода
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

help: ## Показать это сообщение
	@echo "$(GREEN)Доступные команды:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(RESET) %s\n", $$1, $$2}'

# Локальные команды (без Docker)
build: ## Собрать веб-документацию
	@echo "$(GREEN)🚀 Сборка веб-документации...$(RESET)"
	cd scripts && bash generate_web_simple.sh

pdf: ## Сгенерировать PDF документы
	@echo "$(GREEN)📄 Генерация PDF...$(RESET)"
	cd scripts && bash generate_all_pdfs.sh

serve: ## Запустить локальный веб-сервер
	@echo "$(GREEN)🌐 Запуск сервера на http://localhost:8000$(RESET)"
	python3 -m http.server 8000 --directory dist

clean: ## Очистить собранные файлы
	@echo "$(YELLOW)🧹 Очистка...$(RESET)"
	rm -rf dist/*

# Docker команды
docker-build: ## Собрать веб-документацию в Docker
	@echo "$(GREEN)🐳 Сборка в Docker...$(RESET)"
	docker-compose run --rm build

docker-pdf: ## Сгенерировать PDF в Docker
	@echo "$(GREEN)🐳 Генерация PDF в Docker...$(RESET)"
	docker-compose run --rm pdf

docker-serve: ## Запустить веб-сервер в Docker
	@echo "$(GREEN)🐳 Запуск сервера в Docker на http://localhost:8000$(RESET)"
	docker-compose up web

docker-clean: ## Остановить и удалить Docker контейнеры
	@echo "$(YELLOW)🐳 Очистка Docker...$(RESET)"
	docker-compose down -v
	docker-compose rm -f

# Комплексные команды
all: clean docker-build docker-serve ## Полная сборка и запуск
	@echo "$(GREEN)✅ Готово!$(RESET)"

docker-all: clean docker-build docker-pdf docker-serve ## Docker: сборка HTML + PDF + запуск сервера
	@echo "$(GREEN)✅ Все готово!$(RESET)"

