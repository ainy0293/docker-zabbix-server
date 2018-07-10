FROM ubuntu:14.04
MAINTAINER Ainy Min Email: ifool.me Website: http://ifool.me
ENV REFRESHED_AT 2017-02-12

RUN mkdir /root/fpm
ADD localtime /etc/localtime
ADD timezone /etc/timezone
ADD php_install.sh /root/fpm/
#COPY src.tar.gz /root/fpm
WORKDIR /root/fpm
RUN ./php_install.sh

VOLUME ["/tmp"]
EXPOSE 9000
CMD ["/usr/bin/php-fpm", "-F"]

