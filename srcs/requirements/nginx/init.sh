#!/bin/bash

set -e

if [ "$(id -u)" = "0" ];then
	echo "init.sh running as root..."

	if [ ! -f /etc/ssl/certs/nginx.crt ]; then
		openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
			-keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt \
			-subj "/C=FR/ST=ILE-DE-FRANCE/L=PARIS/O=42/CN=localhost"
		chmod 600 /etc/ssl/private/nginx.key
	fi
fi

echo "Starting nginx..."
nginx -g "daemon off;" || {
	echo "Impossible de passer nginx au premier plan !"
	exit 1
}
	
