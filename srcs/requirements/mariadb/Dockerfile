FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./conf/db-start.sh /db-start.sh

RUN mkdir /run/mysql

RUN chmod +x /db-start.sh

CMD ["/db-start.sh"]
