#!/bin/bash
set -e

echo "Inicio del script de entrada de WordPress..."

# Crear el directorio /var/www/html si no existe
mkdir -p /var/www/html

# Función para verificar si el archivo wp-config.php está vacío
is_wp_config_empty() {
    if [ ! -s /var/www/html/wp-config.php ]; then
        return 0
    else
        return 1
    fi
}

# Descargar y configurar WordPress si no está ya configurado
if [ ! -f /var/www/html/wp-config.php ] || is_wp_config_empty; then
    echo "Descargando y configurando WordPress..."
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz
    rm latest.tar.gz
    cp -r wordpress/* /var/www/html/
    rm -rf wordpress
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html

    # Eliminar wp-config.php si está vacío
    if is_wp_config_empty; then
        if [ -f /var/www/html/wp-config.php ]; then
            rm /var/www/html/wp-config.php
        fi
    fi

    # Descargar y extraer WP-CLI
    echo "Descargando WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    # Esperar a que MariaDB esté listo
    echo "Esperando a que MariaDB esté listo..."
    while ! mysql -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e "status" >/dev/null 2>&1; do
        echo "Esperando a MariaDB..."
        sleep 2
    done

    # Crear el archivo wp-config.php
    echo "Creando wp-config.php..."
    wp config create --path=/var/www/html --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root

    if [ -s /var/www/html/wp-config.php ]; then
        echo "wp-config.php creado correctamente."
    else
        echo "Error: El archivo wp-config.php no se ha creado."
        exit 1
    fi

    # Mostrar contenido de wp-config.php para depuración
    cat /var/www/html/wp-config.php

    # Instalar WordPress
    echo "Instalando WordPress..."
    wp core install --path=/var/www/html --url=$DOMAIN_NAME --title="WordPress Site" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --skip-email --allow-root

    # Crear un usuario adicional
    echo "Creando usuario adicional..."
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=editor --user_pass=$WORDPRESS_USER_PASSWORD --allow-root
else
    echo "WordPress ya está configurado."
fi

exec "$@"

