FROM debian:12

RUN apt update && apt install -y nginx

RUN apt install openssl -y

RUN apt install -y vim

EXPOSE 9000

EXPOSE 443

COPY ./init.sh .

COPY ./default.cnf /etc/nginx/nginx.conf

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
			-keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt \
			-subj "/C=FR/ST=ILE-DE-FRANCE/L=PARIS/O=42/CN=localhost"
RUN chmod 600 /etc/ssl/private/nginx.key

CMD ["nginx", "-g", "daemon off;"]
