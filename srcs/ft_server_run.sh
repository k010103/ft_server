#!/bin/bash

# 권한설정
chmod 775 /run.sh
chown -R www-data:www-data /var/www/
chmod -R 755 /var/www/

# ssl
openssl req -x509 -newkey rsa:4096 -nodes -sha256 -keyout ft_server.key -out ft_server.crt -days 365 -subj "/C=KR/ST=SEOUL/L=SEOUL/O=42Seoul/OU=gun/CN=localhost"
mkdir /etc/nginx/ssl
mv ft_server.key /etc/nginx/ssl/
mv ft_server.crt /etc/nginx/ssl/
chmod 600 etc/nginx/ssl/*

# nginx default
cp -rp /tmp/default /etc/nginx/sites-available/

# wordpress
wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mv wordpress/ var/www/html/
chown -R www-data:www-data /var/www/html/wordpress
cp -rp ./tmp/wp-config.php /var/www/html/wordpress

# wordpress mysql  
service mysql start
echo "CREATE DATABASE IF NOT EXISTS wordpress;" \
	| mysql -u root --skip-password
echo "CREATE USER IF NOT EXISTS 'junmkang'@'localhost' IDENTIFIED BY 'junmkang';" \
	| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'junmkang'@'localhost' WITH GRANT OPTION;" \
	| mysql -u root --skip-password
	
# phpMyAdmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin /var/www/html/
rm phpMyAdmin-5.0.2-all-languages.tar.gz
cp -rp /tmp/config.inc.php /var/www/html/phpmyadmin/

service nginx start
service php7.3-fpm start
service mysql restart

bash
