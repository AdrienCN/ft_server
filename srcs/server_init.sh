#!/bin/bash

#-----LEMP SETUP------

mkdir /var/www/ft_server

service nginx start

	#---NGINX setup---
		#Deplacement de la config file ft_server
mv /init_c/nginx_config /etc/nginx/sites-available/ft_server
	
		#Liens symbolique s_availble -> sites-enable
ln -s /etc/nginx/sites-available/ft_server /etc/nginx/sites-enabled/

rm /etc/nginx/sites-enabled/default
	#---FIN NGINX---

	#---MYSQL ou MARIADB Database_setup---

service mysql start
echo "CREATE DATABASE wordpress_database;" | mysql -u root                     
echo "GRANT ALL ON wordpress_database.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
	#---FIN MYSQL---

	#---PHP activation---

service php7.3-fpm start
	#---FIN PHP---

#------FIN DU LEMP--------

#-----WORDPRESS DB SETUP------

mkdir /var/www/ft_server/wordpress 

tar -xzf  latest.tar.gz \
	--strip-component 1 \
	-C /var/www/ft_server/wordpress \
	&& rm /latest.tar.gz

mv /init_c/wp-config.php /var/www/ft_server/wordpress

	#OPTION (pour avoir un jolie site a presenter uniquement)

		#Feed mon site tout pret a la database du lemp
mysql -u root < init_c/wordpress_ready_site.sql 

		#Setup du contenu media du site wordpress
mkdir -p /var/www/ft_server/wordpress/wp-content/uploads/2021/01

mv init_c/giphy.gif /var/www/ft_server/wordpress/wp-content/uploads/2021/01/

#------FIN DE WORDPRESS-----

#------PHPMyAdmin SETUP------

mkdir /var/www/ft_server/phpmyadmin

tar -xzf /phpMyAdmin-latest-all-languages.tar.gz --strip-component 1 -C /var/www/ft_server/phpmyadmin

rm /phpMyAdmin-latest-all-languages.tar.gz

mv /init_c/config.inc.php /var/www/ft_server/phpmyadmin

#------PHPMyAdmin FIN------

#-----SSL-----

mkdir -p /etc/nginx/ssl
	#obtention d'un certificat autosigne SSL
openssl req -newkey rsa:4096 -x509 -sha256 \
		-nodes -days 365 \
	   	-keyout /etc/nginx/ssl/ft_server.key -out /etc/nginx/ssl/ft_server.pem \
   	-subj "/C=US/ST=Ilinois/L=Chicago/O=Pineapple_inc/OU=IT/CN=localhost"

#------SSL FIN-----

./init_c/autoindex.sh 

#Reboot nginx with modified configurations
service nginx reload 

#open bash to prevent container from closing
bash
