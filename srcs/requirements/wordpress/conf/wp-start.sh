#!/bin/sh

sleep 9
# Verificar la disponibilidad de MariaDB
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

echo "MariaDB is up and running"

# Comprueba si el archivo wp-config.php ya existe. 
# Esto se usa para determinar si WordPress ya está instalado.
if [ -f ./wp-config.php ]
then
    echo "Wordpress already installed."
else
    echo "Downloading WordPress..."
    # Si wp-config.php no existe, descarga los archivos principales de WordPress.
    wp core download --allow-root

    echo "Creating wp-config.php..."
    # Crea el archivo de configuración wp-config.php para WordPress.
    wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root

    echo "Installing WordPress..."
    # Instala WordPress con la URL, el título del sitio, el nombre de usuario del administrador, 
    # la contraseña del administrador y el correo electrónico del administrador.
    wp core install --url=$DOMAIN_NAME --title="WordPress Site" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --allow-root

    echo "Creating additional user..."
    # Crea un usuario adicional con el rol de editor.
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=editor --user_pass=$WORDPRESS_USER_PASSWORD --allow-root
fi

echo "Starting Wordpress..."

# Inicia PHP-FPM (FastCGI Process Manager) para manejar solicitudes PHP. 
# El parámetro --nodaemonize asegura que PHP-FPM se ejecute en primer plano.
/usr/sbin/php-fpm7.4 --nodaemonize

# --allow-root: Permite que el comando se ejecute como usuario root, lo cual es útil cuando se ejecuta 
#               dentro de contenedores Docker donde el script puede ejecutarse como root.