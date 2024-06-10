#!/bin/bash

# Crear el directorio /var/www/html si no existe
mkdir -p /var/www/html

# Descargar y configurar WordPress si no está ya configurado
if [ ! -f /var/www/html/wp-config.php ]; then
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz
    rm latest.tar.gz
    cp -r wordpress/* /var/www/html/
    rm -rf wordpress
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html

    # Descargar WP-CLI
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    # Crear el archivo wp-config.php
    wp config create --path=/var/www/html --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root

    # Instalar WordPress
    wp core install --path=/var/www/html --url=$DOMAIN_NAME --title="WordPress Site" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --skip-email --allow-root

    # Crear un usuario adicional
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=editor --user_pass=$WORDPRESS_USER_PASSWORD --allow-root
fi

exec "$@"