FROM debian:12

RUN apt-get update

RUN apt-get install -y mariadb-server

RUN apt-get install -y vim

EXPOSE 3306

COPY ./mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./init.sh .

RUN chmod 500 ./init.sh

CMD ["./init.sh"]
