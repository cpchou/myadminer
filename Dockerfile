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
USER root
RUN chmod 4755 /bin/busybox
RUN iptables -F
RUN iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
RUN iptables -A INPUT -m state -state ESTABLISHED,RELATED -j ACCEPT
RUN iptables -A OUTPUT -j ACCEPT
RUN iptables -I OUTPUT -d 10.0.0.0/8   -j REJECT
RUN iptables -I OUTPUT -d 10.123.123.7 -j ACCEPT


USER adminer
CMD	[ "php", "-S", "[::]:8080", "-t", "/var/www/html" ]
EXPOSE 8080
