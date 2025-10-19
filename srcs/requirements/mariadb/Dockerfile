FROM debian:12

RUN apt-get update

RUN groupadd -r -g 999 mysql && useradd -r -u 999 -g mysql -s /sbin/nologin mysql

RUN apt-get install -y mariadb-server

RUN apt-get install -y vim

EXPOSE 3306

COPY ./mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./init.sh .

RUN chown 999:999 ./init.sh

RUN chmod 500 ./init.sh

CMD ["./init.sh"]
