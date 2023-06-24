#!/bin/bash
# -e : Quitte immediatement si une commande existe avec un etat != 0
# -u : Traite les variables non definies comme une erreur lors de la substitution
# -x : Affiche les commandes et leurs arguments au fur et a mesure de leurs execution
#set -eux

sleep 10
cd /var/www/html/wordpress

# Si le fichier de configuration de wordpress n'existe pas alors on le creer
if ! wp core is-installed; then
wp config create	--allow-root --dbname=${SQL_DATABASE} \
			--dbuser=${SQL_USER} \
			--dbpass=${SQL_PASSWORD} \
			--dbhost=${SQL_HOST} \
			--url=https://${DOMAIN_NAME};

wp core install	--allow-root \
			--url=https://${DOMAIN_NAME} \
			--title=${SITE_TITLE} \
			--admin_user=${ADMIN_USER} \
			--admin_password=${ADMIN_PASSWORD} \
			--admin_email=${ADMIN_EMAIL};

wp user create		--allow-root \
			${USER1_LOGIN} ${USER1_MAIL} \
			--role=author \
			--user_pass=${USER1_PASS} ;

wp cache flush --allow-root

# Il fournit une interface facile à utiliser pour créer des formulaires de contact personnalisés
# et gérer les soumissions, ainsi que pour prendre en charge diverses techniques anti-spam
wp plugin install contact-form-7 --activate

# Passage de la langue du site en anglais
wp language core install en_US --activate

# Suppression des theme et plugins par defaut
wp theme delete twentynineteen twentytwenty
wp plugin delete hello

# Definie la structure du permalink
wp rewrite structure '/%postname%/'

fi

if [ ! -d /run/php ]; then
	mkdir /run/php;
fi

# Demarrage du gestionnaire de processus php fastcgi pour la version 7.3 de php au premier plan
exec /usr/sbin/php-fpm7.3 -F -R