#!/bin/bash

# Define una variable que contiene la ruta del archivo SQL que se utilizará para inicializar la base de datos.
MYSQL_INIT_FILE="/createdb.sql"

# Cambia el propietario del directorio /var/lib/mysql y todos sus archivos y subdirectorios a mysql.
chown -R mysql: /var/lib/mysql
chmod 777 /var/lib/mysql

# Inicializa los archivos de datos de MariaDB si aún no existen. Redirige la salida estándar y de error a /dev/null 
# para suprimir cualquier mensaje.
mysql_install_db >/dev/null 2>&1

# Verifica si no existe un directorio con el nombre de la base de datos especificada. Si no existe, procede a crear e 
# inicializar la base de datos y el usuario.
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    # Elimina el archivo de inicialización SQL si ya existe.
    rm -f "$MYSQL_INIT_FILE"
    # echo ... >> "$MYSQL_INIT_FILE": Añade comandos SQL al archivo de inicialización para crear la base de datos, crear 
    # un usuario con los permisos adecuados y establecer la contraseña del usuario root.
    echo "CREATE DATABASE $MYSQL_DATABASE;" >> "$MYSQL_INIT_FILE"
    echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> "$MYSQL_INIT_FILE"
    echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';" >> "$MYSQL_INIT_FILE"
    echo "ALTER USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" >> "$MYSQL_INIT_FILE"
    echo "FLUSH PRIVILEGES;" >> "$MYSQL_INIT_FILE"
    echo "Starting database..."
    # Inicia el servidor MariaDB en modo seguro y ejecuta los comandos SQL contenidos en el archivo de inicialización. Redirige 
    # la salida estándar y de error a /dev/null para suprimir cualquier mensaje.
    mysqld_safe --init-file=$MYSQL_INIT_FILE >/dev/null 2>&1
else
    echo "Starting database..."
    mysqld_safe >/dev/null 2>&1
fi

# Si el directorio de la base de datos ya existe, inicia el servidor MariaDB en modo seguro. Redirige la salida estándar y de error a 
# /dev/null para suprimir cualquier mensaje.