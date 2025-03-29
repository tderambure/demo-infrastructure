.PHONY: help init clone traefik-init up down restart build logs shell wp-shell wp-install theme-build-assets plugin-build-assets demo-build-assets demo-install

help: ## List available commands
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*?## "}; /^[a-zA-Z0-9_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: clone traefik-init up wp-install ## Clone, setup Traefik, launch and install WordPress

clone: ## Clone all required repositories
	rm -rf ./apps
	cp .env.demo .env
	@git clone $(WORDPRESS_REPO) apps/wordpress_${WORDPRESS_INSTANCE_0}
	cp apps/wordpress_${WORDPRESS_INSTANCE_0}/.env.demo apps/wordpress_${WORDPRESS_INSTANCE_0}/.env
	@git clone $(THEME_REPO) apps/themes/demo-theme
	@git clone $(PLUGIN_REPO) apps/plugins/demo-plugin

traefik-init: ## Create acme.json with proper permissions
	@mkdir -p docker/traefik
	@if [ ! -f docker/traefik/acme.json ]; then \
		touch docker/traefik/acme.json && chmod 600 docker/traefik/acme.json; \
	fi

up: ## Start all containers
	docker compose up -d

down: ## Stop all containers
	docker compose down

restart: ## Restart all containers
	docker compose down
	docker compose up -d

build: ## Build all containers
	docker compose build

logs: ## Show logs
	docker compose logs -f

php-shell: ## Open shell in PHP container
	docker compose exec php_basket bash

wp-shell: ## Open WP-CLI shell
	docker compose exec php wp shell

node-shell: ## Build
	@docker compose run --rm node bash

plugin-build-assets: ## Build plugin assets
	@docker compose run --rm node bash -c "cd /app/demo-plugin && npm run build"

theme-build-assets: ## Build plugin assets
	@docker compose run --rm node bash -c "cd /app/demo-theme && npm run build"

demo-build-assets: theme-build-assets plugin-build-assets ## Build demo assets

demo-install: ## Install demo deps
	@docker compose run --rm node npm install --workspace /app/themes/demo-theme
	@docker compose run --rm node npm install --workspace /app/plugins/demo-plugins

wp-install: ## Install WordPress via WP-CLI if not already installed
	@docker compose exec -u www-data php_${INSTANCE} bash -c "composer install --no-dev --optimize-autoloader"
	@docker compose exec -u www-data php_${INSTANCE} wp core is-installed >/dev/null 2>&1 || \
	docker compose exec -u www-data php_${INSTANCE} wp core install \
		--url="http://wp-${INSTANCE}.localhost" \
		--title="Demo WordPress" \
		--admin_user=admin \
		--admin_password=admin \
		--admin_email=demo@example.com
	@docker compose exec -u www-data php_${INSTANCE} bash -c "cd web/app/themes/demo-theme && composer install --no-dev --optimize-autoloader"
	@docker compose exec -u www-data php_${INSTANCE} wp theme activate demo-theme
	@docker compose exec -u www-data php_${INSTANCE} wp plugin activate demo-plugin

INSTANCE ?= basket

GIT_ORG=tderambure
REPO_WORDPRESS=demo-wordpress
REPO_THEME=demo-theme
REPO_PLUGIN=demo-plugin

WORDPRESS_INSTANCE_0=basket
WORDPRESS_REPO=git@github.com:$(GIT_ORG)/$(REPO_WORDPRESS).git
THEME_REPO=git@github.com:$(GIT_ORG)/$(REPO_THEME).git
PLUGIN_REPO=git@github.com:$(GIT_ORG)/$(REPO_PLUGIN).git

.DEFAULT_GOAL := help
