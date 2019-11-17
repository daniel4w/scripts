#!/usr/bin/env bash

# check for installed ppa
apt update > /dev/null 2>&1 && sudo apt-cache policy | grep http | awk '{print $2 $3}' | sort -u | grep ondrej > /dev/null 2>&1

[ $? -gt 0 ] && echo "add repository ppa:ondrej/php" && apt-add-repository -y ppa:ondrej/php

# Istall apache
echo "Install apache with fast cgi ..."
apt install -y apache2 libapache2-mod-fcgid > /dev/null 2>&1


# Install php versions and packages
versions=( 7.0 7.1 7.2 7.3 7.4)

cat /etc/hosts | grep -v php | sudo tee /etc/hosts > /dev/null 2>&1

for version in "${versions[@]}"
do
	short=$(echo $version | sed -e 's/\.//')

	echo "Install php version $version ..."
	apt install -y \
		php"$version" \
		php"$version"-fpm \
		php"$version"-xsl \
		php"$version"-xml \
		php"$version"-gd \
		php"$version"-mysql \
		php"$version"-zip \
		php"$version"-mbstring \
		php"$version"-curl \
		php"$version"-bz2 \
		> /dev/null 2>&1
	
	echo "Make webdir /var/www/php$short ..."
	mkdir -p /var/www/php"$short"
	
	echo "Add phpinfo file to webdir ..."
	echo "<?php phpinfo(); ?>" > /var/www/php"$short"/index.php
	
	echo "Add config file to sites-available ..."
	echo "<VirtualHost *:80>
	ServerName php$short
	DocumentRoot /var/www/php$short
	<Directory /var/www/php$short>
		Options +Indexes +FollowSymlinks +MultiViews
		AllowOverride All
		Order allow,deny
		Allow from all
	</Directory>
	<FilesMatch \\.php$>
		SetHandler \"proxy:unix:/var/run/php/php$version-fpm.sock|fcgi://localhost/\"
	</FilesMatch>
</VirtualHost>
	" > /etc/apache2/sites-available/php"$short".conf
	echo "Enable config site ..."
	a2ensite php"$short" > /dev/null 2>&1
	echo "Add site to hosts file ..."
	echo "127.0.0.1 php$short" >> /etc/hosts
done

# Enable fast cgi for apache
echo "Enabling fast cgi for apache"
a2enmod actions fcgid alias proxy_fcgi > /dev/null 2>&1

systemctl restart apache2


