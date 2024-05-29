# Plantilla basica temporal para el makefile que ejecutara los comandos de Docker-compose.

build:
	docker-compose build

up:
	docker-compose up -d

down:
	docker-compose down

restart:
	docker-compose down
	docker-compose up -d

logs:
	docker-compose logs -f

.PHONY: build up down restart logs
