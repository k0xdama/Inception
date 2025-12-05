RESET		:=	\033[0m
BOLD		:=	\033[1m
ITAL		:=	\033[3m
BLINK		:=	\033[5m

RED		:=	\033[30m
GREEN		:=	\033[32m
YELLOW		:=	\033[33m
BLUE		:=	\033[34m
CYAN		:=	\033[36m

NAME = inception

COMPOSE_FILE = srcs/docker-compose.yml

all: setup-docker setup-dirs build up

setup-docker:
	@echo "${CYAN}Configuring Docker usernamespace remapping...${RESET}"
	@if ! id dockermap >/dev/null 2>&1; then \
		echo "${YELLOW}Creating dockermap user...${RESET}"; \
		sudo useradd -r -s /bin/false dockermap; \
		echo "${GREEN}User dockermap has been created !${RESET}"; \
	else \
		echo "${GREEN}User dockermap already exists${RESET}"; \
	fi
	@if ! grep -q "^dockermap" /etc/subuid 2>/dev/null; then \
		echo "${YELLOW}Editing /etc/subuid...${RESET}"; \
		echo "dockermap:100000:65536" | sudo tee -a /etc/subuid > /dev/null; \
		echo "${GREEN}/etc/subuid has been edited !${RESET}"; \
	else \
		echo "${GREEN}/etc/subuid already configured${RESET}"; \
	fi
	@if ! grep -q "^dockermap" /etc/subgid 2>/dev/null; then \
		echo "${YELLOW}Editing /etc/subgid...${RESET}"; \
		echo "dockermap:100000:65536" | sudo tee -a /etc/subgid > /dev/null; \
		echo "${GREEN}/etc/subgid has been edited !${RESET}"; \
	else \
		echo "${GREEN}/etc/subgid already configured${RESET}"; \
	fi
	@if ! grep -q "userns-remap" /etc/docker/daemon.json 2>/dev/null; then \
		echo "${YELLOW}Configuring docker daemon...${RESET}"; \
		if [ ! -f /etc/docker/daemon.json ]; then \
			echo '{"userns-remap": "dockermap"}' | sudo tee /etc/docker/daemon.json > /dev/null; \
			echo "${GREEN}/etc/docker/daemon.json has been created and edited !${RESET}"; \
		else \
			sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.old; \
			sudo jq '. + {"userns-remap": "dockermap"}' /etc/docker/daemon.json.old > /tmp/daemon.json.tmp; \
			sudo mv /tmp/daemon.json.tmp /etc/docker/daemon.json; \
			echo "${GREEN}/etc/docker/daemon.json has been edited !${RESET}"; \
		fi; \
		echo "${YELLOW}Restarting Docker...${RESET}"; \
		sudo systemctl restart docker; \
		sleep 4; \
		echo "${GREEN}/etc/docker/daemon.json has been configured !${RESET}"; \
	else \
		echo "${GREEN}/etc/docker/daemon.json already configured${RESET}"; \
	fi

setup-dirs:
		@echo "${CYAN}Setup data directories...${RESET}"
		@mkdir -p /home/pmateo/data/mariadb /home/pmateo/data/wordpress
		@chown root:root /home/pmateo/data && chmod 755 /home/pmateo/data
		@chown -R 100999:100999 /home/pmateo/data/mariadb && chmod 700 /home/pmateo/data/mariadb
		@chown -R 100033:100033 /home/pmateo/data/wordpress && chmod 700 /home/pmateo/data/wordpress

build:
	@echo "${CYAN}Building...${RESET}"
	docker compose -f ${COMPOSE_FILE} build

up:
	docker compose -f ${COMPOSE_FILE} up -d
	@echo "${GREEN}${BOLD}${BLINK}Containers are up !${RESET}"

down:
	docker compose -f ${COMPOSE_FILE} down
	@echo "${YELLOW}${BOLD}Containers has been shutdowned !${RESET}"

down-v:
	docker compose -f ${COMPOSE_FILE} down
	sudo rm -rf /home/pmateo/data/mariadb/*
	sudo rm -rf /home/pmateo/data/wordpress/*
	@echo "${YELLOW}${BOLD}Containers has been shutdowned and volumes has been erased !${RESET}"

logs:
	docker compose -f ${COMPOSE_FILE} logs

logs-rt:
	docker compose -f ${COMPOSE_FILE} logs -f

status:
	docker compose -f ${COMPOSE_FILE} ps -a

restart:
	docker compose -f ${COMPOSE_FILE} restart
	@echo "${GREEN}${BOLD}${BLINK}All containers has been restarted !${RESET}"

recreate: down up
	@echo "${GREEN}${BOLD}${BLINK}All containers has been recreated !${RESET}"

clean:
	docker compose -f ${COMPOSE_FILE} down --rmi all
	sudo rm -rf /home/pmateo/data/mariadb/*
	sudo rm -rf /home/pmateo/data/wordpress/*
	@echo "${YELLOW}${BOLD}Containers shutdowned, data and ALL images erased !${RESET}"

fclean:
	docker compose -f ${COMPOSE_FILE} down --rmi all
	sudo rm -rf /home/pmateo/data/mariadb
	sudo rm -rf /home/pmateo/data/wordpress
	docker builder prune -af
	@echo "${RED}${BOLD}Full clean-up has been achieved !${RESET}"

re: fclean all

shell-mariadb:
		docker exec -it mariadb /bin/bash
shell-wordpress:
		docker exec -it wordpress /bin/bash
shell-nginx:
		docker exec -it nginx /bin/bash


help:
	@echo "${BLUE}${BOLD}COMMANDS:${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make${RESET}			${CYAN}${ITAL}- Build and start${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make build${RESET}		${CYAN}${ITAL}- Build all project images${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make down${RESET}		${CYAN}${ITAL}- Shutdown containers"
	@echo "${BLUE}${ITAL}${BOLD} make down-v${RESET}		${CYAN}${ITAL}- Shutdown containers and erase volumes${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make logs${RESET}		${CYAN}${ITAL}- Show logs${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make logs-rt${RESET}		${CYAN}${ITAL}- Show logs and wait for others${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make status${RESET}		${CYAN}${ITAL}- Show containers status${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make restart${RESET}		${CYAN}${ITAL}- Restart containers${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make clean${RESET}		${CYAN}${ITAL}- Shutdown containers and erase volumes and all images${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make fclean${RESET}		${CYAN}${ITAL}- Make a full clean-up, with a builder docker prune${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make re${RESET}		${CYAN}${ITAL}- Make a full clean-up, and execute 'ALL' rule${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make shell-mariadb${RESET}	${CYAN}${ITAL}- Execute a shell inside mariadb container${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make shell-wordpress${RESET}	${CYAN}${ITAL}- Execute a shell inside wordpress container${RESET}"
	@echo "${BLUE}${ITAL}${BOLD} make shell-nginx${RESET}	${CYAN}${ITAL}- Execute a shell inside nginx container${RESET}"

.PHONY: all up down build clean fclean re
