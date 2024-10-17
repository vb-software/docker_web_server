# Makefile

# Default environment
ENV ?= production

# Docker Compose files
DC_FILES := -f docker-compose.yml -f docker-compose.$(ENV).yml

# Docker Compose command
DC := docker compose --env-file .env.$(ENV) $(DC_FILES)

# Default service (empty means all services)
SERVICE ?=

# Commands
up:
	$(DC) up -d $(SERVICE)

down:
	$(DC) down $(SERVICE)

logs:
	$(DC) logs -f $(SERVICE)

build:
	$(DC) build $(SERVICE)

restart:
	$(DC) restart $(SERVICE)

ps:
	$(DC) ps $(SERVICE)

# Add more commands as needed

.PHONY: up down logs build restart ps