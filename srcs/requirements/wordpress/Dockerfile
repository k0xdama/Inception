FROM debian:12

RUN apt update && apt install -y vim wget curl unzip php8.2 php-fpm php-mysql php-xml php-curl php-gd php-mbstring php-zip php-intl php-bcmath mariadb-client

RUN apt purge -y apache2 && apt-get autoremove -y

EXPOSE 9000

EXPOSE 3306 

COPY ./init.sh .

COPY ./php-fpm.conf /etc/php/8.2/fpm/pool.d/zz-custom.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN mkdir /var/www && chown -R 33:33 /var/www && chown 33:33 wp-cli.phar

RUN chmod 500 wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN chown 33:33 init.sh && chmod 500 ./init.sh

CMD ["./init.sh"]
