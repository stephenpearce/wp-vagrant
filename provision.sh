#!/bin/bash

echo "Updating and upgrade..."
sudo apt update
sudo apt upgrade -y

echo "Install Apache..."
sudo apt install -y apache2 --no-install-recommends

echo "Install PHP 8.1 and extensions..."
sudo apt install -y php8.1 php8.1-mysql libapache2-mod-php8.1 php8.1-cli php8.1-cgi php8.1-gd php8.1-xdebug --no-install-recommends

echo "Configure Xdebug..."
cat <<EOT | sudo tee /etc/php/8.1/mods-available/xdebug.ini
zend_extension=xdebug.so
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.client_port=9003
xdebug.client_host=localhost
EOT
sudo phpenmod xdebug

echo "Install MariaDB..."
sudo apt install -y mariadb-server mariadb-client --no-install-recommends

echo "Configure MariaDB..."
sudo mysql_secure_installation <<EOF
y
n
y
y
y
EOF

echo "Create wordpress db and user..."
sudo mysql -u root -e "CREATE DATABASE wordpress;"
sudo mysql -u root -e "CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

echo "Preconfigure PHPMyAdmin..."
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password password" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password password" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password password" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections

echo "Install PHPMyAdmin..."
sudo apt install -y phpmyadmin --no-install-recommends
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# Check if wordpress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Download and configure Wordpress..."
    cd /tmp
    curl -O https://wordpress.org/latest.tar.gz
    tar xzvf latest.tar.gz
    sudo cp -a wordpress/. /var/www/html

    echo "Setting correct permissions for Wordpress..."
    sudo find /var/www/html -type d -exec chmod 755 {} \;
    sudo find /var/www/html -type f -exec chmod 644 {} \;
    sudo chown -R www-data:www-data /var/www/html

    echo "Set wp-config.php..."
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i "s/database_name_here/wordpress/g" /var/www/html/wp-config.php
    sed -i "s/username_here/wp_user/g" /var/www/html/wp-config.php
    sed -i "s/password_here/password/g" /var/www/html/wp-config.php
    sed -i "s/localhost/127.0.0.1/g" /var/www/html/wp-config.php

    echo "Remove unwanted files..."
    rm -f /var/www/html/index.html
    rm -f /var/www/html/readme.html
    rm -f /var/www/html/wp-config-sample.php
else
    echo "Wordpress is already installed. Skipping..."
fi

echo "Configure Apache for Wordpress..."
cat <<EOT | sudo tee /etc/apache2/sites-available/wordpress.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName wordpress.local
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT

sudo a2ensite wordpress
sudo a2enmod rewrite
sudo systemctl restart

echo "Provisioning complete 👍"