#!bin/bash
# -e : Quitte immediatement si une commande existe avec un etat != 0
# -u : Traite les variables non definies comme une erreur lors de la substitution
# -x : Affiche les commandes et leurs arguments au fur et a mesure de leurs execution
#set -eux

# Demarre mysql
service mysql start;

# Creer la table si non existante au nom de la variable d'environnement
# SQL_DATABASE, indique dans le fichier .env qui sera envoyer par le
# docker-compose.yml
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Creer un utilisateur pouvant manipuler la table
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"

# Attribution des droits a cet utilisateur
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Modifier l'utilsateur root pour chager les droit avec le mot de passe
# SQL_ROOT_PASSWORD
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Rafraichir pour que myqsl le prenne en compte 
mysql -e "FLUSH PRIVILEGES;"

# Arret de mysql
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown
# Demarrage securise du server mysql, cette commande ajoute des fonctionnalites
# de securite comme le redemarrage du serveur lorsqu'une erreur a lieu.
# De plus elle permet la journalisation des informations d'execution dans
# un journal des erreurs
exec mysqld_safe