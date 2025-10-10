#!/bin/bash

echo  "init.sh has been runned :)"

wp config create --allow-root --path=/var/www/html/wordpress --dbname=${MARIADB_DATABASE} --dbuser=${MARIADB_USER} \ 
	--dbpass=${MARIADB_PASSWORD} --dbhost=mariadb:3306 --dbprefix=wp_ || {

	echo "Impossible de configurer wordpress !"
	exit 1
}

wp core install --allow-root --url=pmateo.42.fr --title=Pmateo_Website --admin_user=${WP_ADM} \
	--admin_password =${WP_ADM_PASSWORD} --admin_email=${WP_ADM_EMAIL} || {
	
	echo "Impossible de paramétrer le site web !"
	exit 1
}

echo "Wordpress has been succesfully installed !"
