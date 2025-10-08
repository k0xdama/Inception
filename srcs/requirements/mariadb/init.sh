#!/bin/bash

echo -e "init.sh has been runned :)"
service mariadb start || {
	echo "Impossible de démarrer MARIA-DB !"
	exit 1
}

sleep 2

mysql -e "CREATE DATABASE IF NOT EXISTS wordpress;" || {
	echo "Impossible de créer une base de données !"
       	exit 1 
}

mysql -e "CREATE USER IF NOT EXISTS 'root'@'172.17.0.1' IDENTIFIED by 'hoothoot';" || {
	echo "Impossible de créer un utilisateur root pour l'hôte !"
	exit 1
}

mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'172.17.0.1' with GRANT OPTION;" || {
	echo "Impossible d'attribuer tout les droits à l'utilisateur root de l'hôte !"
	exit 1
}

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'hoothoot';" || {
	echo "Impossible de définir un mot de passe pour ROOT !"
       	exit 1 
}

mysql -u root -p"hoothoot" -e "CREATE USER IF NOT EXISTS 'bird'@'localhost' IDENTIFIED BY 'cuicui';" || {
	echo "Impossible de créer l'utilisateur BIRD !"
       	exit 1 
}

mysql -u root -p"hoothoot" -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'bird'@'localhost' IDENTIFIED BY 'cuicui';" || {
	echo "Impossible de donner les privilèges sur la base de données MARIADB à BIRD !"
	exit 1 
}

mysqladmin -u root -p"hoothoot" shutdown
exec mysqld_safe
