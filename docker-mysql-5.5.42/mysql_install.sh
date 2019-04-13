#!/bin/bash
#mysql 5.5.42 install script on docker container
#author: ainy min Emai: ainy@ifool.me website: http://ifmx.cc
#date: 2017/07/15
#version: 1.0

#check if user is root
if [ $(id -u) != "0" ]; then
	echo "Error: You must be root to run this script, please use root to install mysql! "
	echo "or use sudo command! "
	exit 1
fi

#install path
install_path=/usr/local/mysql


#uninstall mysql of deb packaget
apt-get -y autoremove
apt-get -y purge mysql-client mysql-server mysql-common mysql-server-core-5.5 mysql-client-5.5
rm -f /etc/my.cnf
rm -rf /etc/mysql
rm -rf /var/lib/mysql
rm -rf /usr/local/mysql


apt-get update
apt-get -y install gcc g++ cmake make openssl libssl-dev libncurses5 libncurses5-dev wget bison

if [ ! -f mysql-5.5.42.tar.gz ]; then
        echo "Error! file mysql-5.7.17.tar.gz Don't exist, download now!"
        sleep 1
        wget -c http://dn.ifmx.cc/soft/mysql-5.5.42.tar.gz
fi

#Extract file
tar -zxvf mysql-5.5.42.tar.gz -C /usr/local/src

#begin
cd /usr/local/src/mysql-5.5.42/
cmake -DCMAKE_INSTALL_PREFIX=${install_path} -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_READLINE=1 -DWITH_SSL=bundled -DWITH_ZLIB=system -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1
make -j $(lscpu | awk '/^CPU\(s\)\:/{print $2}')
make install

#create run mysql database user
groupadd mysql
useradd -s /usr/sbin/nologin -M -g mysql mysql

#my.cnf 
cat > /etc/my.cnf<<EOF
[client]
#password   = your_password
port        = 3306
socket      = /tmp/mysql.sock

[mysqld]
port        = 3306
socket      = /tmp/mysql.sock
datadir = ${install_path}/data
skip-external-locking
key_buffer_size = 16M
max_allowed_packet = 1M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M
thread_cache_size = 8
query_cache_size = 8M
tmp_table_size = 16M

explicit_defaults_for_timestamp = true
#skip-networking
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535

log-bin=mysql-bin
binlog_format=mixed
server-id   = 1
expire_logs_days = 10
early-plugin-load = ""

#loose-innodb-trx=0
#loose-innodb-locks=0
#loose-innodb-lock-waits=0
#loose-innodb-cmp=0
#loose-innodb-cmp-per-index=0
#loose-innodb-cmp-per-index-reset=0
#loose-innodb-cmp-reset=0
#loose-innodb-cmpmem=0
#loose-innodb-cmpmem-reset=0
#loose-innodb-buffer-page=0
#loose-innodb-buffer-page-lru=0
#loose-innodb-buffer-pool-stats=0
#loose-innodb-metrics=0
#loose-innodb-ft-default-stopword=0
#loose-innodb-ft-inserted=0
#loose-innodb-ft-deleted=0
#loose-innodb-ft-being-deleted=0
#loose-innodb-ft-config=0
#loose-innodb-ft-index-cache=0
#loose-innodb-ft-index-table=0
#loose-innodb-sys-tables=0
#loose-innodb-sys-tablestats=0
#loose-innodb-sys-indexes=0
#loose-innodb-sys-columns=0
#loose-innodb-sys-fields=0
#loose-innodb-sys-foreign=0
#loose-innodb-sys-foreign-cols=0

default_storage_engine = InnoDB
#innodb_data_home_dir = ${install_path}/data
#innodb_data_file_path = ibdata1:10M:autoextend
#innodb_log_group_home_dir = ${install_path}/data
#innodb_buffer_pool_size = 16M
#innodb_log_file_size = 5M
#innodb_log_buffer_size = 8M
#innodb_flush_log_at_trx_commit = 1
#innodb_lock_wait_timeout = 50

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF

#enable innodb storage engine
sed -i 's:^#innodb:innodb:g' /etc/my.cnf

#my.cnf configuration file
MemTotal=$(free -m | grep Mem | awk '{print  $2}')

if [[ ${MemTotal} -gt 1024 && ${MemTotal} -lt 2048 ]]; then
		sed -i "s#^key_buffer_size.*#key_buffer_size = 32M#" /etc/my.cnf
		sed -i "s#^table_open_cache.*#table_open_cache = 128#" /etc/my.cnf
		sed -i "s#^sort_buffer_size.*#sort_buffer_size = 768K#" /etc/my.cnf
		sed -i "s#^read_buffer_size.*#read_buffer_size = 768K#" /etc/my.cnf
		sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 8M#" /etc/my.cnf
		sed -i "s#^thread_cache_size.*#thread_cache_size = 16#" /etc/my.cnf
		sed -i "s#^query_cache_size.*#query_cache_size = 16M#" /etc/my.cnf
		sed -i "s#^tmp_table_size.*#tmp_table_size = 32M#" /etc/my.cnf
		sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 128M#" /etc/my.cnf
		sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 32M#" /etc/my.cnf
	elif [[ ${MemTotal} -ge 2048 && ${MemTotal} -lt 4096 ]]; then
		sed -i "s#^key_buffer_size.*#key_buffer_size = 64M#" /etc/my.cnf
		sed -i "s#^table_open_cache.*#table_open_cache = 256#" /etc/my.cnf
		sed -i "s#^sort_buffer_size.*#sort_buffer_size = 1M#" /etc/my.cnf
		sed -i "s#^read_buffer_size.*#read_buffer_size = 1M#" /etc/my.cnf
		sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 16M#" /etc/my.cnf
		sed -i "s#^thread_cache_size.*#thread_cache_size = 32#" /etc/my.cnf
		sed -i "s#^query_cache_size.*#query_cache_size = 32M#" /etc/my.cnf
		sed -i "s#^tmp_table_size.*#tmp_table_size = 64M#" /etc/my.cnf
		sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 256M#" /etc/my.cnf
		sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 64M#" /etc/my.cnf
	elif [[ ${MemTotal} -ge 4096 && ${MemTotal} -lt 8192 ]]; then
		sed -i "s#^key_buffer_size.*#key_buffer_size = 128M#" /etc/my.cnf
		sed -i "s#^table_open_cache.*#table_open_cache = 512#" /etc/my.cnf
		sed -i "s#^sort_buffer_size.*#sort_buffer_size = 2M#" /etc/my.cnf
		sed -i "s#^read_buffer_size.*#read_buffer_size = 2M#" /etc/my.cnf
		sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 32M#" /etc/my.cnf
		sed -i "s#^thread_cache_size.*#thread_cache_size = 64#" /etc/my.cnf
		sed -i "s#^query_cache_size.*#query_cache_size = 64M#" /etc/my.cnf
		sed -i "s#^tmp_table_size.*#tmp_table_size = 64M#" /etc/my.cnf
		sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 512M#" /etc/my.cnf
		sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 128M#" /etc/my.cnf
	elif [[ ${MemTotal} -ge 8192 && ${MemTotal} -lt 16384 ]]; then
		sed -i "s#^key_buffer_size.*#key_buffer_size = 256M#" /etc/my.cnf
		sed -i "s#^table_open_cache.*#table_open_cache = 1024#" /etc/my.cnf
		sed -i "s#^sort_buffer_size.*#sort_buffer_size = 4M#" /etc/my.cnf
		sed -i "s#^read_buffer_size.*#read_buffer_size = 4M#" /etc/my.cnf
		sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 64M#" /etc/my.cnf
		sed -i "s#^thread_cache_size.*#thread_cache_size = 128#" /etc/my.cnf
		sed -i "s#^query_cache_size.*#query_cache_size = 128M#" /etc/my.cnf
		sed -i "s#^tmp_table_size.*#tmp_table_size = 128M#" /etc/my.cnf
		sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 1024M#" /etc/my.cnf
		sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 256M#" /etc/my.cnf
	elif [[ ${MemTotal} -ge 16384 && ${MemTotal} -lt 32768 ]]; then
		sed -i "s#^key_buffer_size.*#key_buffer_size = 512M#" /etc/my.cnf
		sed -i "s#^table_open_cache.*#table_open_cache = 2048#" /etc/my.cnf
		sed -i "s#^sort_buffer_size.*#sort_buffer_size = 8M#" /etc/my.cnf
		sed -i "s#^read_buffer_size.*#read_buffer_size = 8M#" /etc/my.cnf
		sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 128M#" /etc/my.cnf
		sed -i "s#^thread_cache_size.*#thread_cache_size = 256#" /etc/my.cnf
		sed -i "s#^query_cache_size.*#query_cache_size = 256M#" /etc/my.cnf
		sed -i "s#^tmp_table_size.*#tmp_table_size = 256M#" /etc/my.cnf
		sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 2048M#" /etc/my.cnf
		sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 512M#" /etc/my.cnf
	elif [[ ${MemTotal} -ge 32768 ]]; then
		sed -i "s#^key_buffer_size.*#key_buffer_size = 1024M#" /etc/my.cnf
		sed -i "s#^table_open_cache.*#table_open_cache = 4096#" /etc/my.cnf
		sed -i "s#^sort_buffer_size.*#sort_buffer_size = 16M#" /etc/my.cnf
		sed -i "s#^read_buffer_size.*#read_buffer_size = 16M#" /etc/my.cnf
		sed -i "s#^myisam_sort_buffer_size.*#myisam_sort_buffer_size = 256M#" /etc/my.cnf
		sed -i "s#^thread_cache_size.*#thread_cache_size = 512#" /etc/my.cnf
		sed -i "s#^query_cache_size.*#query_cache_size = 512M#" /etc/my.cnf
		sed -i "s#^tmp_table_size.*#tmp_table_size = 512M#" /etc/my.cnf
		sed -i "s#^innodb_buffer_pool_size.*#innodb_buffer_pool_size = 4096M#" /etc/my.cnf
		sed -i "s#^innodb_log_file_size.*#innodb_log_file_size = 1024M#" /etc/my.cnf
fi

# initialize mysql system databases and tables
mkdir -p /usr/local/mysql/data
chown -R mysql:mysql /usr/local/mysql/data

cp support-files/mysql.server /etc/init.d/mysql
chmod 755 /etc/init.d/mysql

#mysql lib
cat > /etc/ld.so.conf.d/mysql.conf<<EOF
	/usr/local/mysql/lib
	/usr/local/lib
EOF
ldconfig
sleep 2

apt-get clean
apt-get -y autoclean

rm -rf /usr/local/src/mysql-5.5.42
rm -rf /var/lib/apt/list/*
echo 'done'
