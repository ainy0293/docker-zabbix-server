FROM ubuntu:14.04
MAINTAINER Ainy Min email: ainy@ifool.me website: http://ifool.me
ENV REFRESHED_AT 2017-05-09
ENV PATH $PATH:/usr/local/mysql/bin
ADD localtime /etc/localtime
ADD timezone /etc/timezone
ADD mysql_install.sh /root
ADD sql /root
ADD sources.list.trusty /etc/apt/sources.list
WORKDIR /root
RUN ./mysql_install.sh
ADD mysql.startup.sh /usr/share/
RUN chmod +x /usr/share/mysql.startup.sh
VOLUME ["/usr/local/mysql/data"]
EXPOSE 3306
CMD ["/usr/share/mysql.startup.sh"]

