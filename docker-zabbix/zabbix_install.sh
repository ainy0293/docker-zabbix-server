#!/bin/bash

if [ $(id -u) != "0" ]; then
	echo "Error: You must be root to run this script, please use root to install mysql! "
	echo "or use sudo command! "
	exit 1
fi
cd /root
# install path
install_path=/usr/local/zabbix

yum clean all
yum -y install epel-release
sleep 1
yum -y install gcc gcc-c++ net-snmp-devel libxml2-devel libcurl-devel mysql++-devel libevent-devel make wget sudo
if [ ! -f zabbix-3.4.11.tar.gz ]; then
	echo "File zabbix-3.4.11.tar.gz don't exist, download now."
	wget -c http://ocwljlzzv.bkt.clouddn.com/soft/zabbix-3.4.11.tar.gz
fi
sleep 1
tar -zxvf /root/zabbix-3.4.11.tar.gz -C /usr/local/src

cd /usr/local/src/zabbix-3.4.11
./configure --prefix=${install_path} --enable-server --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2
make -j $(grep processor /proc/cpuinfo | wc -l)
make -j $(grep processor /proc/cpuinfo | wc -l) install

useradd -s /sbin/nologin zabbix

sed -i '/^\# DBHost/c DBHost=mysql\-server' ${install_path}/etc/zabbix_server.conf
sed -i '/^DBUser/c DBUser=root' ${install_path}/etc/zabbix_server.conf
sed -i '/^\# DBPassword/c DBPassword=123456' ${install_path}/etc/zabbix_server.conf
sed -i '/^\# DBPort/c DBPort=3306' ${install_path}/etc/zabbix_server.conf

yum clean all
#yum autoremove

rm -rf /usr/local/src/zabbix*
rm -f /root/zabbix*

cat > /usr/share/zabbix.server.startup.sh << EOF
#!/bin/bash

lock_file=/usr/local/zabbix/etc/zabbix.lock

if [ ! -f \${lock_file} ]; then
	echo 'ZABBIX is waiting for the database server to initialize the database for 30 seconds.'
	sleep 30
	# start zabbix service
	touch \${lock_file}
	sudo -u zabbix /usr/local/zabbix/sbin/zabbix_server -c /usr/local/zabbix/etc/zabbix_server.conf -f
else
	sudo -u zabbix /usr/local/zabbix/sbin/zabbix_server -c /usr/local/zabbix/etc/zabbix_server.conf -f
fi
EOF

chmod +x /usr/share/zabbix.server.startup.sh
