#!/bin/bash

# Crear el directorio /run/mysqld si no existe
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 777 /var/lib/mysql

# Inicializa la base de datos si no está ya inicializada
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Inicializando base de datos..."
    mysqld --initialize-insecure --user=mysql
    echo "Base de datos inicializada."

    # Iniciar el servidor MariaDB en segundo plano
    mysqld_safe --skip-networking &

    # Esperar a que se inicie
    sleep 5

    # Crear la base de datos y el usuario para WordPress
    echo "Creando base de datos y usuario para WordPress..."
    mysql -uroot <<-EOSQL
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL

    echo "Base de datos y usuario creados."
    
    # Detener el servidor MariaDB
    mysqladmin -uroot shutdown
fi

exec "$@"


# Si el directorio de datos de MariaDB no contiene una instalación de MySQL/MariaDB (/var/lib/mysql/mysql), inicializa la base de datos.
# mysqld --initialize-insecure --user=mysql: Inicializa la base de datos sin contraseña para el usuario root.

# mysqld_safe --skip-networking &: Inicia el servidor MariaDB en modo seguro y en segundo plano, deshabilitando la red temporalmente.

# Ejecuta comandos SQL para crear la base de datos wordpress, crear el usuario wordpress_user y otorgar los permisos necesarios.

# exec "$@": Ejecuta el comando pasado como argumento (en este caso, mysqld).
