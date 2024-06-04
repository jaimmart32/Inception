FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#COPY ./conf/my.conf /etc/mysql/my.conf

VOLUME /var/lib/mysql

EXPOSE 3306

COPY ./conf/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "mysqld" ]