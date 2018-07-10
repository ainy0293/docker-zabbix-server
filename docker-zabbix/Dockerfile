FROM centos:7
ADD localtime /etc/localtime
ADD zabbix_install.sh /root
# COPY zabbix-3.4.11.tar.gz /root

RUN /root/zabbix_install.sh
# RUN yum -y install sudo

EXPOSE 3306
# CMD ["sudo", "-u", "zabbix", "/usr/local/zabbix/sbin/zabbix_server", "-c",  "/usr/local/zabbix/etc/zabbix_server.conf", "-f"]
CMD ["/usr/share/zabbix.server.startup.sh"]

