RESET		:=	\033[0m
BOLD		:=	\033[1m
ITAL		:=	\033[3m
BLINK		:=	\033[5m

RED		:=	\033[30m
GREEN		:=	\033[32m
YELLOW		:=	\033[33m
BLUE		:=	\033[34m
CYAN		:=	\033[36m
PURPLE		:=	\033[38;2;211;211;255m

NAME = inception

COMPOSE_FILE = srcs/docker-compose.yml

all: up

build:
	@echo "${CYAN}Building...${RESET}"
	docker compose -f ${COMPOSE_FILE} build

up:	build
	docker compose -f ${COMPOSE_FILE} up -d
	@echo "${GREEN}${BOLD}${BLINK}Containers are up !${RESET}"

down:
	docker compose -f ${COMPOSE_FILE} down
	@echo "${YELLOW}${BOLD}Containers has been shutdowned !${RESET}"

down-v:
	docker compose -f ${COMPOSE_FILE} down -v
	rm -rf /srv/data/mariadb/*
	rm -rf /srv/data/wordpress/*
	@echo "${YELLOW}${BOLD}Containers has been shutdowned and volumes has been erased !${RESET}"

logs:
	docker compose -f ${COMPOSE_FILE} logs

logs-rt:
	docker compose -f ${COMPOSE_FILE} logs -f

status:
	docker compose -f ${COMPOSE_FILE} ps -a

restart:
	docker compose -f ${COMPOSE_FILE} restart
	@echo "${PURPLE}${BOLD}${BLINK}All containers has been restarted !${RESET}"

clean:
	docker compose -f ${COMPOSE_FILE} down -v --rmi all
	rm -rf /srv/data/mariadb/*
	rm -rf /srv/data/wordpress/*
	@echo "${YELLOW}${BOLD}Containers shutdowned, volumes and ALL images erased !${RESET}"

fclean:
	docker compose -f ${COMPOSE_FILE} down -v --rmi all
	docker system prune -af --volumes
	@echo "${RED}${BOLD}Full clean-up has been achieved !${RESET}"

re: fclean all

shell-mariadb:
		docker exec -it mariadb:v1 /bin/bash
shell-wordpress:
		docker exec -it wordpress:v1 /bin/bash
shell-nginx:
		docker exec -it nginx:v1 /bin/bash


help:
	@echo "${BLUE}${BOLD}COMMANDS:${RESET}"
	@echo "${PURPLE}${ITAL} make       		- Build and start"
	@echo "${PURPLE}${ITAL} make build      	- Build all project images"
	@echo "${PURPLE}${ITAL} make down     		- Shutdown containers"
	@echo "${PURPLE}${ITAL} make down-v     	- Shutdown containers and erase volumes"
	@echo "${PURPLE}${ITAL} make logs      		- Show logs"
	@echo "${PURPLE}${ITAL} make logs-rt    	- Show logs and wait for others"
	@echo "${PURPLE}${ITAL} make status     	- Show containers status"
	@echo "${PURPLE}${ITAL} make restart    	- Restart containers"
	@echo "${PURPLE}${ITAL} make clean     		- Shutdown containers and erase volumes and all images"
	@echo "${PURPLE}${ITAL} make fclean   		- Make a full clean-up, with a system docker prune"
	@echo "${PURPLE}${ITAL} make re      		- Make a full clean-up, and execute 'ALL' rule"
	@echo "${PURPLE}${ITAL} make shell-mariadb    	- Execute a shell inside mariadb container"
	@echo "${PURPLE}${ITAL} make shell-wordpress    - Execute a shell inside wordpress container"
	@echo "${PURPLE}${ITAL} make shell-nginx      	- Execute a shell inside nginx container"

.PHONY: all up down build clean fclean re
