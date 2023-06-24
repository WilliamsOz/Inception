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

# -P permet de specifier dans quel dossier on veut dl le fichier
RUN wget https://wordpress.org/wordpress-6.1.1.tar.gz -P /var/www/html
# Extraction + suppression du .tar.gz
RUN cd /var/www && tar -xzf wordpress.org/wordpress-6.1.1.tar.gz && rm wordpress.org/wordpress-6.1.1.tar.gz

# Mise a jour des droit pour s'assurer que le serveur Web (nginx) dispose
# des autorisations necessaires pour lire et executer les fichiers
# dans le repertoire racine Web 
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*

# Exposition du port 9000
EXPOSE 9000

# Copie du script a l'interieur du conteneur + modification des permissions
COPY ./tools/wpscript.sh ./
RUN chmod +x ./wpscript.sh

# Copie du fichier de conf de WP dans le conteneur
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Lancement d'un bash ainsi que du script au demarrage du conteneur
ENTRYPOINT ["bash", "./wpscript.sh"]