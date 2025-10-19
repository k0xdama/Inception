#!/bin/bash

#MARIADB_DATABASE=wordpress
#MARIADB_ROOT_PASSWORD=hoothoot
#MARIADB_USER=bird
#MARIADB_PASSWORD=cuicui

if [[ ! -d "/var/run/mysql" ]]; then
	mysql_install_db --user=mysql
fi

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

mysql -e "CREATE USER IF NOT EXISTS 'root'@'172.17.0.1' IDENTIFIED by '${MARIADB_ROOT_PASSWORD}';" || {
	echo "Impossible de créer un utilisateur root pour l'hôte !"
	exit 1
}

mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'172.17.0.1' with GRANT OPTION;" || {
	echo "Impossible d'attribuer tout les droits à l'utilisateur root de l'hôte !"
	exit 1
}

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';" || {
	echo "Impossible de définir un mot de passe pour ROOT !"
       	exit 1 
}

mysql -u root -p"hoothoot" -e "CREATE USER IF NOT EXISTS ${MARIADB_USER}@'172.17.0.1' IDENTIFIED BY '${MARIADB_PASSWORD}';" || {
	echo "Impossible de créer l'utilisateur BIRD !"
       	exit 1 
}

mysql -u root -p"hoothoot" -e "GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO ${MARIADB_USER}@'172.17.0.1' IDENTIFIED BY '${MARIADB_PASSWORD}';" || {
	echo "Impossible de donner les privilèges sur la base de données MARIADB à BIRD !"
	exit 1 
}
mysqladmin -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown
exec mysqld_safe
