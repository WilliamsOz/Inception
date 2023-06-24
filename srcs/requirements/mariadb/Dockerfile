FROM debian:buster

# Mise a jour et installation des dependances
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y mariadb-server
RUN apt-get install -y mariadb-client
RUN apt-get install -y procps

# Copie le fichier de configuration a l'interieur du conteneur
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Creation des repo de mysql
RUN mkdir -p /var/run/mysqld
RUN mkdir -p /var/lib/mysql

# Mise a jour des permission des dossiers de mysql
RUN chown mysql:mysql /var/run/mysqld/
RUN chmod -R 755 /var/run/mysqld/
RUN chown mysql:mysql /var/lib/mysql/
RUN chmod -R 755 /var/lib/mysql/

# Exposition du port 3306 du conteneur
EXPOSE 3306

# Copie du script a l'interieur du conteneur
COPY ./tools/dbscript.sh ./

# Modification des droits du script
RUN chmod +x ./dbscript.sh

# Lancement d'un bash ainsi que du script au demarrage du conteneur
ENTRYPOINT ["bash", "./dbscript.sh"]