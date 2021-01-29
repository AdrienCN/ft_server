#!/bin/bash

if [ $AUTOINDEX = 'off' ]
then
	sed -i 's/autoindex on;/autoindex off;/g' /etc/nginx/sites-available/ft_server
fi
