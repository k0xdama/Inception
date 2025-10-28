#!/bin/bash

#MARIADB_DATABASE=wordpress
#MARIADB_USER=bird
#MARIADB_PASSWORD=cuicui
#WP_ADM=pmateo
#WP_ADM_PASSWORD=imyummyotp
#WP_ADM_EMAIL=pmateo@student.42paris.fr

echo  "init.sh has been runned :)"

if [ ! -f "/var/www/html/wordpress/index.php" ]; then
	wp core download --path=/var/www/html/wordpress
fi

if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
	wp config create --path=/var/www/html/wordpress --dbname=${MARIADB_DATABASE} --dbuser=${MARIADB_USER} \
		--dbpass=${MARIADB_USER_PASSWORD} --dbhost=mariadb:3306 --dbprefix=wp_ --dbcharset=utf8
	echo "Wordpress database has been configured !"
fi

if ! wp core is-installed --path=/var/www/html/wordpress 2>/dev/null; then
	wp core install --path=/var/www/html/wordpress --url=pmateo.42.fr --title=Pmateo_Website --admin_user=${WP_ADM} \
		--admin_password=${WP_ADM_PASSWORD} --admin_email=${WP_ADM_EMAIL}
	echo "Wordpress has been installed !"
fi

echo "Wordpress is set up and ready !"
exec php-fpm8.2 -F
