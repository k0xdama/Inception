#!/bin/bash

if [[ ! -d "/var/run/mysqld" ]]; then
	mysql_install_db --user=mysql
	echo -e "init.sh has been runned :)"
	service mariadb start || {
		echo "Impossible de démarrer MARIA-DB !"
		exit 1
	}
	sleep 2
	mysql -e "CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};" || {
		echo "Impossible de créer une base de données !"
       		exit 1 
	}
	mysql -e "CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED by '${MARIADB_ROOT_PASSWORD}';" || {
		echo "Impossible de créer un utilisateur root pour 'localhost' !"
		exit 1
	}
	mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' with GRANT OPTION;" || {
		echo "Impossible d'attribuer tout les droits à l'utilisateur root de 'localhost' !"
		exit 1
	}
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';" || {
		echo "Impossible de définir un mot de passe pour ROOT !"
       		exit 1
	}
	mysql -u root -p"hoothoot" -e "CREATE USER IF NOT EXISTS ${MARIADB_USER}@'%' IDENTIFIED BY '${MARIADB_USER_PASSWORD}';" || {
		echo "Impossible de créer l'utilisateur BIRD !"
       		exit 1
	}

	mysql -u root -p"hoothoot" -e "GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO ${MARIADB_USER}@'%' IDENTIFIED BY '${MARIADB_USER_PASSWORD}';" || {
		echo "Impossible de donner les privilèges sur la base de données MARIADB à BIRD !"
		exit 1 
	}
	mysqladmin -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown
fi
exec mysqld_safe
