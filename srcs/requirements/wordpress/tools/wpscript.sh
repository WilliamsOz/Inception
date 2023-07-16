#!/bin/bash

if [ -f /var/www/html/wordpress/wp-config.php ]

then
	echo "Wordpress is already installed."

else
	cd /var/www/html/wordpress

	# Telechargement && Installation de wordpress
	wp core download --locale=fr_FR --allow-root
	echo "Installation of Wordpress..."
	# Si le fichier de configuration de wordpress n'existe pas alors on le creer
	wp config create	--allow-root \
				--dbname=${SQL_DATABASE} \
				--dbuser=${SQL_USER} \
				--dbpass=${SQL_PASSWORD} \
				--dbhost=${SQL_HOST} \
				--url=https://${DOMAIN_NAME};

	# Configuration du premiere utilisateur
	wp core install	--allow-root \
				--url=https://${DOMAIN_NAME} \
				--title=${SITE_TITLE} \
				--admin_user=${ADMIN_USER} \
				--admin_password=${ADMIN_PASSWORD} \
				--admin_email=${ADMIN_EMAIL} \
				--skip-email;

	# Ajout d'un autre utilisateur
	wp user create		--allow-root \
				${USER1_LOGIN} ${USER1_MAIL} \
				--role=author \
				--user_pass=${USER1_PASS} ;

fi

# Creation du dossier php si non existant
if [ ! -d /run/php ]; then
	mkdir /run/php;
fi

# Attribution des droits a l'utilisateur pour le contenu du dossier /var/www/
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

# Demarrage du gestionnaire de processus php fastcgi pour la version 7.3 de php au premier plan
exec /usr/sbin/php-fpm7.3 -F -R