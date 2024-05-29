# Especifica la imagen base a partir de la cual se construirá la nueva imagen. Es la primera instrucción en cualquier Dockerfile.
FROM debian:bullseye

# Ejecuta comandos en la imagen durante el proceso de construcción. Estos comandos se ejecutan en una nueva capa encima de la imagen actual y el resultado se guarda como la siguiente capa de la imagen.
RUN apt-get update && apt-get install -y nginx

# Copia archivos o directorios desde el sistema de archivos del host al sistema de archivos del contenedor.
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Informa a Docker que el contenedor escucha en puertos de red específicos en tiempo de ejecución.
EXPOSE 443

# Proporciona un comando por defecto para ejecutar cuando un contenedor se inicia a partir de la imagen. Solo puede haber una instrucción CMD en un Dockerfile. Si hay múltiples, solo la última se usa. Es el PID 1.
CMD [ "nginx", "-g", "daemon off;"]



# RUN -> La flag -y en apt-get install es una opción que significa --yes. Su función es automática y significa "responder 'yes' a todas las preguntas".
# CMD -> Dentro del contenedor ejecutamos la función -g para utilizar "daemon off", ya que si estuviera en on no detectaria el proceso principal y se cerraria al instante.