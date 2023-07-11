FROM debian:buster

# Mise a jour et installation des dependances
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install wget
RUN apt-get -y install php7.3 php-fpm php-mysql default-mysql-client mariadb-client

# Installation d'une interface de ligne de commande pour wordpress + permission + deplacer dans les binaires
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Exposition du port 9000
EXPOSE 9000

# Copie du script a l'interieur du conteneur + modification des permissions
COPY ./tools/wpscript.sh ./
RUN chmod +x ./wpscript.sh

# Copie du fichier de conf de WP dans le conteneur
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Lancement d'un bash ainsi que du script au demarrage du conteneur
ENTRYPOINT ["bash", "./wpscript.sh"]