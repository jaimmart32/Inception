# Usar la imagen base de Debian
FROM debian:bullseye

# Actualiza los paquetes e instala las dependencias necesarias para ejecutar WordPress y PHP
RUN apt-get update && apt-get install -y curl \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-common \
    mariadb-client \
    sendmail \
    wget

# Instalar WP-CLI, la herramienta de línea de comandos para WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar --silent
RUN chmod +x wp-cli.phar
# Mueve el archivo WP-CLI phar al directorio /usr/local/bin y lo renombra a wp para que sea fácil de usar(Un archivo .phar 
# (PHP Archive) es un archivo empaquetado que contiene todo el código y las dependencias necesarias para ejecutar una app PHP.).
RUN mv wp-cli.phar /usr/local/bin/wp

# Crear el directorio de WordPress y ajustar permisos
RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html
# Cambia los permisos del directorio /var/www/html para que el propietario tenga permisos de lectura, escritura y ejecución, 
# y otros usuarios tengan permisos de lectura y ejecución.
RUN chmod -R 755 /var/www/html

# Copiar el archivo de configuración de PHP-FPM al directorio de configuración de PHP-FPM.
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copia el script de inicializaión de wpress al directorio /var/www y lo renombra a init-wordpress.sh.
COPY conf/wp-start.sh /var/www/init-wordpress.sh

RUN chmod +x /var/www/init-wordpress.sh

# Crear el directorio /run/php si no existe para que PHP-FPM pueda funcionar correctamente
RUN mkdir -p /run/php

# Establece el directorio de trabajo actual a /var/www/html, donde se ejecutarán los comandos subsiguientes.
WORKDIR /var/www/html

# Define el comando por defecto para ejecutar el script de inicialización de WordPress cuando se inicie el contenedor.
CMD ["/var/www/init-wordpress.sh"]

# RUN apt-get update: Actualiza la lista de paquetes disponibles.
# && apt-get install -y: Instala los siguientes paquetes sin pedir confirmación.
# curl: Herramienta para transferir datos desde o hacia un servidor.
# php7.4: Instala PHP 7.4.
# php7.4-fpm: Instala PHP-FPM 7.4, un administrador de procesos FastCGI para manejar solicitudes PHP.
# php7.4-mysql: Instala la extensión de PHP para trabajar con MySQL.
# php7.4-common: Instala archivos comunes de PHP.
# mariadb-client: Instala el cliente de MariaDB para conectarse a la base de datos.
# sendmail: Instala Sendmail, un agente de transferencia de correo.(Aunque WordPress puede funcionar sin sendmail, tenerlo 
#           instalado asegura que cualquier funcionalidad que dependa del envío de correos electrónicos funcione correctamente.)
# wget: Herramienta para descargar archivos desde la web.
#
# RUN 5
# mkdir -p /var/www/html: Crea el directorio /var/www/html si no existe.
# chown -R www-data:www-data /var/www/html: Cambia el propietario del directorio /var/www/html a www-data, que es el usuario utilizado por el servidor web.