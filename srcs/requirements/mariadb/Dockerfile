FROM debian:bullseye

# Actualizar el índice de paquetes e instalar el servidor MariaDB
RUN apt-get update && apt-get install -y mariadb-server

# Copiar el archivo de configuración personalizado a la ubicación de configuración de MariaDB
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
# Copiar el script de inicialización a la raíz del contenedor
COPY ./conf/db-start.sh /db-start.sh
# Crear el directorio /run/mysql, necesario para que MariaDB pueda iniciar correctamente, ya que 
# lo utiliza para almacenar archivos de proceso y sockets.
RUN mkdir /run/mysql

RUN chmod +x /db-start.sh
# Establecer el comando predeterminado para ejecutar el script de inicialización cuando se inicie el contenedor
CMD ["/db-start.sh"]
