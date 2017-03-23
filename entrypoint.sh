#!/bin/bash

set -e

cd /var/www/html

if [ -d "prestashop" ]; then

  echo "/prestashop dir exists, just start apache and mysql"

  /etc/init.d/mysql start

else

  ## Change this if you want to use a different PS version
  PS_VERSION=prestashop_1.6.1.11.zip
  SITE_NAME=new.centroprofessionaleaudio.dev

  ## Apache
  a2enmod rewrite

  ## MySQL
  sed -Ei 's/bind-address\s+=\s+127.0.0.1/bind-address=0.0.0.0\nskip_name_resolve=ON/g' /etc/mysql/mysql.conf.d/mysqld.cnf && \
  /etc/init.d/mysql restart

  if [ "$1" = '--no_install' ]; then
    ## Using existing files
    echo 'skipping fresh installation..'
    mkdir -p prestashop
  else
    echo 'install a fresh PrestaShop instance'
    ## Download Prestashop
    wget http://www.prestashop.com/download/old/$PS_VERSION
    unzip -o $PS_VERSION
    sudo rm ./$PS_VERSION
  fi

  ## Set user:group to Apache www-data
  chown -R www-data:www-data /var/www/html/prestashop/
  ## The following is necessary for working with the volume
  cd /var/www/html/ && usermod -u 1000 www-data

  VHOST_DIR_CONFIG="\n\
  \t<Directory \/var\/www\/html\/prestashop\/>\n\
  \t  Options Indexes FollowSymLinks\n\
  \t  AllowOverride All\n\
  \t  Require all granted\n\
  \t<\/Directory>\n"

  ## Set up virtual host
  cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/${SITE_NAME}.conf && \
  sed -Ei "s/#ServerName\swww.example.com/ServerName $SITE_NAME/g" /etc/apache2/sites-available/$SITE_NAME.conf && \
  sed -Ei "s/DocumentRoot\s\/var\/www\/html/DocumentRoot \/var\/www\/html\/prestashop/g" /etc/apache2/sites-available/$SITE_NAME.conf && \
  sed -Ei "s/<\/VirtualHost>/$VHOST_DIR_CONFIG<\/VirtualHost>/g" /etc/apache2/sites-available/$SITE_NAME.conf && \
  sudo a2ensite $SITE_NAME.conf

  ## Create a database
  MYSQL_INIT="\
    CREATE DATABASE IF NOT EXISTS prestashop; \
    CREATE USER IF NOT EXISTS 'prestashop'@'localhost' IDENTIFIED BY 'prestashop'; \
    CREATE USER IF NOT EXISTS 'prestashop'@'%' IDENTIFIED BY 'prestashop'; \
    GRANT ALL PRIVILEGES ON prestashop.* TO 'prestashop'@'localhost'; \
    GRANT ALL ON prestashop.* TO 'prestashop'@'%'; \
    FLUSH PRIVILEGES;"
  mysql -uroot -pabc123 -e "${MYSQL_INIT}"

fi

exec apache2ctl -D FOREGROUND
