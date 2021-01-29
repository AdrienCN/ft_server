FROM debian:buster

RUN apt-get update && apt-get install -y \
	mariadb-server \
	nginx \
	openssl \
	php-curl \
	php-gd \
	php-intl \
	php-mbstring \
	php-soap \
	php-xml \
	php-xmlrpc \
	php-zip \
	php-fpm \
	php-mysql \ 
	wget 

RUN wget https://wordpress.org/latest.tar.gz

RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz

ADD srcs/ init_c/ 

ENV AUTOINDEX=on;

CMD ./init_c/server_init.sh
