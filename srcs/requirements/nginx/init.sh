#!/bin/bash

echo -e "init.sh has been runned :)"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt \
	-subj "/C=FR/ST=ILE-DE-FRANCE/L=PARIS/O=42/CN=localhost" || {
	
	echo "Impossible de creer le certificat pour pmateo.42.fr !"
	exit 1
}

chmod 600 /etc/ssl/private/nginx.key || {
	echo "Impossible de modifer les droits de nginx.key"
	exit 1
}

service nginx start || {
	echo "Impossible de lancer NGINX !"
	exit 1
}

sleep 2

echo "Initialization done :D"

exec /bin/bash
	
