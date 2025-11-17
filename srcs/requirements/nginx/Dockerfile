FROM debian:12

RUN apt update && apt install -y nginx

RUN apt install openssl -y

RUN apt install -y vim

EXPOSE 9000

EXPOSE 443

COPY ./init.sh .

RUN chmod 500 ./init.sh

COPY ./default.cnf /etc/nginx/nginx.conf

CMD ["./init.sh"]
