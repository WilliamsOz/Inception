FROM debian:buster

# Mise a jour et installation des dependances
RUN apt update -y
RUN apt install nginx -y
RUN apt install vim -y
RUN apt install curl -y

# Creation du dossier de nginx
RUN mkdir -p /var/run/nginx

#SSL
# Creation du dossier contenant le certificat et la cle
RUN mkdir -p /etc/nginx/ssl
# Installation de OpenSSL
RUN apt install openssl -y
# Creation du certificat et de la cle
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=wiozsert.42.fr/UID=wiozsert"

# Copie du fichier de conf de nginx a l'interieur du conteneur
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# S'assurer que nous avons les droits (root principal et utilisateur principal)
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Lancement de NGINX au premier plan pour ne pas que le conteneur se stop
ENTRYPOINT ["nginx", "-g", "daemon off;"]