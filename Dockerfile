FROM adminer

USER root
RUN apk add --no-cache --virtual .php-ext-deps \
       unixodbc freetds

RUN   apk add --no-cache --virtual .build-deps \
        unixodbc-dev freetds-dev

RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr 


RUN docker-php-ext-install \
           pdo_odbc pdo_dblib

RUN  apk del .build-deps \
 && rm -rf /var/cache/apk/*
 
RUN apk add iptables
RUN chmod 4755 /bin/busybox


USER adminer
CMD	[ "php", "-S", "[::]:8080", "-t", "/var/www/html" ]
EXPOSE 8080
