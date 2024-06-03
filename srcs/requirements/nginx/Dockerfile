# Especifica la imagen base a partir de la cual se construirá la nueva imagen. Es la primera instrucción en cualquier Dockerfile.
FROM debian:bullseye

# Ejecuta comandos en la imagen durante el proceso de construcción. Estos comandos se ejecutan en una nueva capa encima de la imagen actual y el resultado se guarda como la siguiente capa de la imagen.
RUN apt-get update && apt-get install -y nginx openssl

# Crea los directorios para los certificados SSL
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Genera un certificado SSL auto-firmado y una clave privada
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/jaimmart.42.fr.key \
    -out /etc/ssl/certs/jaimmart.42.fr.crt \
    -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=jaimmart.42.fr"

# Copia archivos o directorios desde el sistema de archivos del host al sistema de archivos del contenedor.
COPY ./conf/nginx.conf /etc/nginx/conf.d/nginx.conf

# Informa a Docker que el contenedor escucha en puertos de red específicos en tiempo de ejecución.
EXPOSE 443

# Proporciona un comando por defecto para ejecutar cuando un contenedor se inicia a partir de la imagen. Solo puede haber una instrucción CMD en un Dockerfile. Si hay múltiples, solo la última se usa. Es el PID 1.
CMD [ "nginx", "-g", "daemon off;"]



# RUN -> La flag -y en apt-get install es una opción que significa --yes. Su función es automática y significa "responder 'yes' a todas las preguntas".
# RUN2 -> La bandera -p en el comando mkdir significa "parents". Esta opción se utiliza para crear directorios de manera recursiva, es decir, crea no solo el directorio especificado, sino también cualquier directorio padre necesario que no exista ya.
# RUN3 -> "openssl" : Es el comando principal para invocar la herramienta OpenSSL, que es una implementación de código abierto de los protocolos SSL y TLS.
#          "req" : subcomando que se utiliza para generar una solicitud de firma de certificado (CSR) o, en este caso, un certificado auto-firmado.
#          "-x509" : Especifica que queremos crear un certificado auto-firmado en lugar de una solicitud de firma de certificado (CSR). X.509 es el formato estándar para los certificados SSL.
#          "-nodes" : Significa "no DES" (Data Encryption Standard). Esta opción indica que la clave privada no debe ser cifrada. Es decir, no se protege con una contraseña. Esto es útil para evitar tener que proporcionar una contraseña cada vez que se carga el certificado.
#          "-days 365" : Especifica la validez del certificado en días. En este caso, el certificado será válido por 365 días.
#          "newkey" : Genera una nueva clave privada y una solicitud de certificado.
#          "rsa:2048" : Indica que la nueva clave privada debe ser un par de claves RSA de 2048 bits. RSA es un algoritmo de cifrado muy común utilizado en la generación de claves y certificados.
#          "-keyout /etc/ssl/private/jaimmart.42.fr.key" : Especifica la ruta donde se guardará la clave privada generada.
#          "-out /etc/ssl/certs/jaimmart.42.fr.crt" : Especifica la ruta donde se guardará el certificado auto-firmado generado.
#          -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=jaimmart.42.fr": Proporciona la información del sujeto del certificado en una sola línea para evitar la interacción durante la generación del certificado. Esta información incluye:

#           /C=XX: El código de dos letras del país (Country).
#           /ST=XX: El estado o provincia (State).
#           /L=XX: La localidad o ciudad (Locality).
#           /O=XX: El nombre de la organización (Organization).
#           /OU=XX: La unidad organizativa (Organizational Unit).
#           /CN=jaimmart.42.fr: El nombre común (Common Name), que generalmente es el nombre del dominio"
#           No es necesario utilizar información real en los campos del certificado SSL para fines de desarrollo y pruebas
# CMD -> Dentro del contenedor ejecutamos la función -g para utilizar "daemon off", ya que si estuviera en on no detectaria el proceso principal y se cerraria al instante.