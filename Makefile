# Plantilla basica temporal para el makefile que ejecutara los comandos de Docker-compose.

all: build

build:
	@docker-compose -f srcs/docker-compose.yml build

up:
	@docker-compose -f srcs/docker-compose.yml up -d

down:
	docker-compose -f srcs/docker-compose.yml down

re: down up

logs:
	docker-compose logs -f

.PHONY: build up down re logs
