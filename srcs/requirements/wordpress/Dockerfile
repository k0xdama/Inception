FROM debian:12

RUN apt update && apt install -y vim wget curl unzip php8.2 php-fpm php-mysql php-xml php-curl php-gd php-mbstring php-zip php-intl php-bcmath mariadb-client

COPY ./init.sh .

RUN wget https://wordpress.org/latest.zip -P /var/www/html

RUN unzip /var/www/html/latest.zip -d /var/www/html && rm /var/www/html/latest.zip && chown -R www-data:www-data /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod 500 wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

#COPY ./my-wp-config.php /var/www/html/wordpress/wp-config.php

RUN chmod 500 ./init.sh

CMD ["./init.sh"]
