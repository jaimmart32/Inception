# Usar la imagen base de Debian
FROM debian:bullseye

# Instalar dependencias necesarias, PHP y extensiones de PHP para WordPress
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    curl \
    wget \
    unzip \
    iputils-ping \
    mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html /run/php

# Copiar el script de entrada
COPY ./conf/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Configurar PHP-FPM
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Exponer el puerto en el que PHP-FPM escucha, 9000 es el puerto predeterminado donde PHP-FPM escucha las solicitudes FastCGI
EXPOSE 9000

# Usar el script de entrada
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]

# Comando para iniciar PHP-FPM, -F indica a PHP-FPM que se ejecute en primer plano(no daemon) para que el proceso permanezca activo
CMD ["php-fpm7.4", "-F"]

# RUN -> "php-fpm" : PHP FastCGI Process Manager, necesario para ejecutar PHP con NGINX
#        "php-mysql" : Extension de PHP para conectarse a bases de datos MySQL/MariaDB
#        "curl" : Herramienta de línea de comandos para transferir datos con URL
#        "wget" : Herramienta de línea de comandos para descargar archivos de la web
#        "unzip" : Utilidad para descomprimir archivos ZIP
#        "apt-get clean" : Limpia la caché local de apt para reducir el tamaño de la imagen
#        "rm -rf /var/lib/apt/lists/*" : Elimina los archivos de listas de paquetes para liberar espacio

# RUN2 -> "curl -O https://wordpress.org/latest.tar.gz" : Descarga la última versión de WordPress en un archivo tarball comprimido
#         "tar -xzvf latest.tar.gz" : Descomprime el archivo tarball descargado
#         "rm latest.tar.gz" : Elimina el archivo tarball comprimido para limpiar espacio
#         "mv wordpress /var/www/html" : Mueve el directorio  descomprimido de WordPress a /var/www/html
#         "chown -R www-data:www-data /var/www/html" : Cambia la propiedad del directorio de WordPress y su contenido al usuario y grupo www-data, que es el usuario predeterminado bajo el cual se ejecuta NGINX y PHP-FPM en muchos sistemas

# COPY -> Copia el archivo de configuración www.conf desde el sistema de archivos del host al container, en la ubicacion especifica
#         donde PHP-FPM busca sus configuraciones de pool. Este archivo configurará cómo PHP-FPM manejará las solicitudes de PHP
