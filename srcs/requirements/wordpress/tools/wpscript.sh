#!/bin/bash
# -e : Quitte immediatement si une commande echoue.
# -u : Traite les variables non definies comme une erreur lors de la substitution.
# -x : Affiche les commandes et leurs arguments au fur et a mesure de leurs execution.
# set -eux

if [ -f /var/www/html/wordpress/wp-config.php ]

then
	echo "already exist"
else
	cd /var/www/html/wordpress

	# Par precaution on fait un sleep 10 afin d'etre certain que la base de donnees
	# mariadb a eu le temp de se lancer correctement
	# sleep 10

	wp core download --locale=en_US --allow-root
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
				--admin_email=${ADMIN_EMAIL};

	# Ajout d'un autre utilisateur
	wp user create		--allow-root \
				${USER1_LOGIN} ${USER1_MAIL} \
				--role=author \
				--user_pass=${USER1_PASS} ;

	# # Nettoyage du cache wp, --allow-root permet d'autoriser l'execution de la commande en tant que root
	# wp cache flush --allow-root

	# # Il fournit une interface facile à utiliser pour créer des formulaires de contact personnalisés
	# # et gérer les soumissions, ainsi que pour prendre en charge diverses techniques anti-spam
	# wp plugin install contact-form-7 --activate

	# # Passage de la langue du site en anglais
	# wp language core install en_US --activate

	# # Suppression des theme et plugins par defaut
	# wp theme delete twentynineteen twentytwenty
	# wp plugin delete hello

	# # Definie la structure du permalink
	# wp rewrite structure '/%postname%/'

fi

# Creation du dossier php si non existant
if [ ! -d /run/php ]; then
	mkdir /run/php;
fi

chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

# Demarrage du gestionnaire de processus php fastcgi pour la version 7.3 de php au premier plan
exec /usr/sbin/php-fpm7.3 -F -R