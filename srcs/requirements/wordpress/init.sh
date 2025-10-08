#!/bin/bash

echo  "init.sh has been runned :)"

wp config create --allow-root --path=/var/www/html/wordpress --dbname=wordpress --dbuser=canary --dbpass=cuicui \
	--dbhost=mariadb:3306 --dbprefix=wp_ || {

	echo "Impossible de configurer wordpress !"
	exit 1
}

wp core install --allow-root --url=pmateo.42.fr --title=Pmateo_Website --admin_user=pmateo \
	--admin_password =imyummyotp --admin_email=pmateo@student.42paris.fr || {
	
	echo "Impossible de paramétrer le site web !"
	exit 1
}

echo "Wordpress has been succesfully installed !"

exec /bin/bash
