#!/bin/bash
set -e

# Inicializa la base de datos si no esta ya inicializada
if [ ! -d "/var/lib/mysql"]; then
    echo "Inicializando base de datos..."
    mysqld --initialize-insecure --user=mysql
    echo "Base de datos inicializada."

    # Iniciar el servidor MariaDB en segundo plano
    mysql_safe --skip-networking &

    # Esperar a que se inicie
    sleep 5

    # Crear la base de datos y el usuario para WordPress
    mysql -uroot <<-EOSQL
        CREATE DATABASE wordpress;
        CREATE USER 'wordpress_user'@'%' IDENTIFIED BY 'wordpress_password';
        GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress_user'@'%';
        FLUSH PRIVILEGES;
EOSQL
    
    # Detener el servidor MariaDB
    mysqladmin -uroot shutdown
fi

exec "$@"

# Si el directorio de datos de MariaDB no contiene una instalación de MySQL/MariaDB (/var/lib/mysql/mysql), inicializa la base de datos.
# mysqld --initialize-insecure --user=mysql: Inicializa la base de datos sin contraseña para el usuario root.

# mysqld_safe --skip-networking &: Inicia el servidor MariaDB en modo seguro y en segundo plano, deshabilitando la red temporalmente.

# Ejecuta comandos SQL para crear la base de datos wordpress, crear el usuario wordpress_user y otorgar los permisos necesarios.

# exec "$@": Ejecuta el comando pasado como argumento (en este caso, mysqld).