FROM debian:12

RUN apt update && apt install -y vim wget curl unzip php8.2 php-fpm php-mysql php-xml php-curl php-gd php-mbstring php-zip php-intl php-bcmath mariadb-client

EXPOSE 9000

EXPOSE 3306 

COPY ./init.sh .

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod 500 wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN chmod 500 ./init.sh

CMD ["./init.sh"]
