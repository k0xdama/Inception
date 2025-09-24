#!/bin/bash

echo -e "init.sh has been runned :)"
service mariadb start || {
	echo "Impossible de démarrer MARIA-DB !"
	exit 1
}


exec /bin/bash
