#!bin/bash

# Demarre mysql
service mysql start;

# Creer la table si non existante au nom de la variable d'environnement
# SQL_DATABASE, indique dans le fichier .env qui sera envoyer par le
# docker-compose.yml
mysql -u root -p${SQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"


# Creer un utilisateur pouvant manipuler la table
mysql -u root -p${SQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"

# Attribution des droits a cet utilisateur
mysql -u root -p${SQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Attribution du mot de passe a root
mysql -u root -p${SQL_ROOT_PASSWORD} -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Rafraichir pour que myqsl le prenne en compte 
mysql -u root -p${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Arret de mysql
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

# Demarrage securise du server mysql, cette commande ajoute des fonctionnalites
# de securite comme le redemarrage du serveur lorsqu'une erreur a lieu.
# De plus elle permet la journalisation des informations d'execution dans
# un journal des erreurs
exec mysqld_safe

#print status
echo "MariaDB database and user were created successfully! "