#!/bin/bash

if [ $(id -u) != "0" ]; then
	echo "Error: You must be root to run this script, please use root to install "
	echo "or use sudo command! "
	exit 1
fi
cpu_num=$(lscpu | awk '/^CPU\(s\)\:/{print $2}')
back()
{
	cd /root/fpm/src
}

# modify apt source to wangyi (mirrors.163)
rm -rf /etc/apt/sources.list
cat > /etc/apt/sources.list<<EOF
deb http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse
EOF

apt-get -y update
apt-get -y install lsb-release

for packages in build-essential gcc g++ make cmake autoconf automake re2c wget cron bzip2 libzip-dev libc6-dev file rcconf flex vim bison m4 gawk less cpp binutils diffutils unzip tar bzip2 libbz2-dev libncurses5 libncurses5-dev libtool libevent-dev openssl libssl-dev zlibc libsasl2-dev libltdl3-dev libltdl-dev zlib1g zlib1g-dev libbz2-1.0 libbz2-dev libglib2.0-0 libglib2.0-dev libpng3 libjpeg62 libjpeg62-dev libjpeg-dev libpng-dev libpng12-0 libpng12-dev libkrb5-dev curl libcurl3 libcurl3-gnutls libcurl4-gnutls-dev libcurl4-openssl-dev libpq-dev libpq5 gettext libjpeg-dev libpng12-dev libxml2-dev libcap-dev ca-certificates debian-keyring debian-archive-keyring libc-client2007e-dev psmisc patch git libc-ares-dev libicu-dev e2fsprogs libxslt libxslt1-dev libc-client-dev
do apt-get install -y $packages --force-yes; done
#apt-get -y install  build-essential gcc g++ make cmake autoconf automake re2c wget cron bzip2 libzip-dev libc6-dev file rcconf flex vim bison m4 gawk less cpp binutils diffutils unzip tar bzip2 libbz2-dev libncurses5 libncurses5-dev libtool libevent-dev openssl libssl-dev zlibc libsasl2-dev libltdl3-dev libltdl-dev zlib1g zlib1g-dev libbz2-1.0 libbz2-dev libglib2.0-0 libglib2.0-dev libpng3 libjpeg62 libjpeg62-dev libjpeg-dev libpng-dev libpng12-0 libpng12-dev libkrb5-dev curl libcurl3 libcurl3-gnutls libcurl4-gnutls-dev libcurl4-openssl-dev libpq-dev libpq5 gettext libjpeg-dev libpng12-dev libxml2-dev libcap-dev ca-certificates debian-keyring debian-archive-keyring libc-client2007e-dev psmisc patch git libc-ares-dev libicu-dev e2fsprogs  libc-client-dev


#check file
if [ ! -f src.tar.gz ]; then
	echo "File src.tar.gz don't exist, download now!"
	wget -c http://dn.ifmx.cc/soft/src.tar.gz
fi
sleep 1

tar -zxvf src.tar.gz
back
if [ ! -f autoconf-2.13.tar.gz ]; then
	echo "Error! file autoconf-2.13.tar.gz Don't exist, exit!"
	exit 1
fi
if [ ! -f curl-7.47.1.tar.gz ]; then
	echo "Error! file curl-7.47.1.tar.gz Don't exist, exit!"
	exit 1
fi
if [ ! -f freetype-2.4.12.tar.gz ]; then
	echo "Error! file freetype-2.4.12.tar Don't exist, exit!"
	exit 1
fi
if [ ! -f icu4c-55_1-src.tgz ]; then
	echo "Error! file icu4c-55_1-src.tgz Don't exist, exit!"
	exit 1
fi
if [ ! -f libiconv-1.14.tar.gz ]; then
	echo "Error! file libiconv-1.14.tar.gz Don't exist, exit!"
	exit 1
fi
if [ ! -f libmcrypt-2.5.8.tar.gz ]; then
	echo "Error! file libmcrypt-2.5.8.tar.gz Don't exist, exit!"
	exit 1
fi
if [ ! -f mcrypt-2.6.8.tar.gz ]; then
	echo "Error! file mcrypt-2.6.8.tar.gz Don't exist, exit!"
	exit 1
fi
if [ ! -f mhash-0.9.9.9.tar.gz ]; then
	echo "Error! file mhash-0.9.9.9.tar.gz Don't exist, exit!"
	exit 1
fi
if [ ! -f pcre-8.36.tar.gz ]; then
	echo "Error! file pcre-8.36.tar.gz Don't exist, exit!"
	exit 1
fi
if [ ! -f php-5.5.36.tar.gz ]; then
	echo "Error! file php-5.5.36.tar.gz Don't exist, exit!"
	exit 1
fi
if [ ! -f php-5.6.22.tar.gz ]; then
	echo "Error! file php-5.6.22.tar.gz Don't exist, exit!"
	exit 1
fi


# Add php-fpm run user
useradd -s /usr/sbin/nologin -M www

# install autoconf-2.13
back
tar -zxvf autoconf-2.13.tar.gz -C /usr/local/src
cd /usr/local/src/autoconf-2.13
./configure --prefix=/usr/local/autoconf-2.13
make  -j $cpu_num
make install

#Install_Libiconv
back
tar -zxvf libiconv-1.14.tar.gz -C /usr/local/src
cd /usr/local/src/libiconv-1.14
patch -p0 < /root/fpm/src/patch/libiconv-glibc-2.16.patch
./configure --enable-static
make -j $cpu_num
make install


#Install_Libmcrypt

back
tar -zxvf libmcrypt-2.5.8.tar.gz -C /usr/local/src
cd /usr/local/src/libmcrypt-2.5.8
./configure
make -j $cpu_num
make install
/sbin/ldconfig
cd libltdl/
./configure --enable-ltdl-install
make -j $cpu_num && make install
ln -sf /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -sf /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -sf /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -sf /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
ldconfig


#Install_Mcrypt
back
tar -zxvf mcrypt-2.6.8.tar.gz -C /usr/local/src
cd /usr/local/src/mcrypt-2.6.8
./configure
make -j  $cpu_num
make install

#Install_Mhash
back
tar -zxvf mhash-0.9.9.9.tar.gz -C /usr/local/src
cd /usr/local/src/mhash-0.9.9.9
./configure
make -j $cpu_num
make install
ln -sf /usr/local/lib/libmhash.a /usr/lib/libmhash.a
ln -sf /usr/local/lib/libmhash.la /usr/lib/libmhash.la
ln -sf /usr/local/lib/libmhash.so /usr/lib/libmhash.so
ln -sf /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
ln -sf /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
ldconfig

#Install_Freetype
back
tar -zxvf freetype-2.4.12.tar.gz -C /usr/local/src
cd /usr/local/src/freetype-2.4.12
./configure --prefix=/usr/local/freetype
make -j $cpu_num
make install
cat > /etc/ld.so.conf.d/freetype.conf<<EOF
/usr/local/freetype/lib
EOF
ldconfig
ln -sf /usr/local/freetype/include/freetype2 /usr/local/include
ln -sf /usr/local/freetype/include/ft2build.h /usr/local/include

#Install_Curl
#back
#tar -zxvf curl-7.47.1.tar.gz -C /usr/local/src
#cd /usr/local/src/curl-7.47.1
#./configure --prefix=/usr/local/curl --enable-ares --without-nss --with-ssl
#make
#make install
#
#Install_Pcre
#{
#    Cur_Pcre_Ver=`pcre-config --version`
#    if echo "${Cur_Pcre_Ver}" | grep -vEqi '^8.';then
#        Echo_Blue "[+] Installing ${Pcre_Ver}"
#        Tar_Cd ${Pcre_Ver}.tar.gz ${Pcre_Ver}
#        ./configure
#        make && make install
#        cd ${cur_dir}/src/
#        rm -rf ${cur_dir}/src/${Pcre_Ver}
#    fi
#}
#Install_Icu4c()
#{
#    if /usr/bin/icu-config --version | grep '^3.'; then
#        Echo_Blue "[+] Installing ${Libicu4c_Ver}"
#        cd ${cur_dir}/src
#        Download_Files ${Download_Mirror}/lib/icu4c/${Libicu4c_Ver}-src.tgz ${Libicu4c_Ver}-src.tgz
#        Tar_Cd ${Libicu4c_Ver}-src.tgz icu/source
#        ./configure --prefix=/usr
#        make && make install
#        cd ${cur_dir}/src/
#        rm -rf ${cur_dir}/src/icu
#    fi
#}


#install php
#Install_PHP_55()
back
tar -zxvf php-5.5.36.tar.gz -C /usr/local/src
cd /usr/local/src/php-5.5.36
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir --with-freetype-dir=/usr/local/freetype --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-mbstring --with-mcrypt --enable-ftp --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --with-gettext --disable-fileinfo --enable-opcache --enable-intl --with-xsl
make ZEND_EXTRA_LIBS='-liconv' -j $cpu_num
make install
#Ln_PHP_Bin()
#{
	ln -sf /usr/local/php/bin/php /usr/bin/php
	ln -sf /usr/local/php/bin/phpize /usr/bin/phpize
	ln -sf /usr/local/php/bin/pear /usr/bin/pear
	ln -sf /usr/local/php/bin/pecl /usr/bin/pecl
	ln -sf /usr/local/php/sbin/php-fpm /usr/bin/php-fpm
#}
#Ln_PHP_Bin
mkdir -p /usr/local/php/etc
cp php.ini-production /usr/local/php/etc/php.ini
# php extensions
echo "Modify php.ini..."
sed -i 's/post_max_size =.*/post_max_size = 50M/g' /usr/local/php/etc/php.ini
sed -i 's/upload_max_filesize =.*/upload_max_filesize = 50M/g' /usr/local/php/etc/php.ini
sed -i 's/;date.timezone =.*/date.timezone = PRC/g' /usr/local/php/etc/php.ini
sed -i 's/short_open_tag =.*/short_open_tag = On/g' /usr/local/php/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=.*/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini
sed -i 's/max_execution_time =.*/max_execution_time = 300/g' /usr/local/php/etc/php.ini
sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chgrp,chown,shell_exec,proc_open,proc_get_status,popen,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server/g' /usr/local/php/etc/php.ini

sed -i '/^expose_php/c expose_php = Off' /usr/local/php/etc/php.ini

#pear config-set php_ini /usr/local/php/etc/php.ini
#pecl config-set php_ini /usr/local/php/etc/php.ini
#curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
back
tar -zxvf zend-loader-php5.5-linux-x86_64.tar.gz
mkdir -p /usr/local/zend/
cp zend-loader-php5.5-linux-x86_64/ZendGuardLoader.so /usr/local/zend/
echo "Write ZendGuardLoader to php.ini..."
cat >>/usr/local/php/etc/php.ini<<EOF

;eaccelerator

;ionCube

;opcache

[Zend ZendGuard Loader]
zend_extension=/usr/local/zend/ZendGuardLoader.so
zend_loader.enable=1
zend_loader.disable_licensing=0
zend_loader.obfuscation_level_support=3
zend_loader.license_path=

;xcache

EOF


# install php memcached extension
cd /root
wget -c http://memcached.org/files/memcached-1.4.39.tar.gz
tar -zxvf memcached-1.4.39.tar.gz
cd memcached-1.4.39
./configure --prefix=/usr/local/memcached
make -j $cpu_num
make install

cd /root
wget -c https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
tar -zxvf libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18
./configure --with-memcached=/usr/local/memcached/ --prefix=/usr/local/libmemcached
make -j $cpu_num
make install

cd /root
wget -c http://pecl.php.net/get/memcached-2.2.0.tgz
tar -xvf memcached-2.2.0.tgz
cd memcached-2.2.0
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-libmemcached-dir=/usr/local/libmemcached/
make -j $cpu_num
make install
sed -i '$a\extension = memcached.so' /usr/local/php/etc/php.ini
rm -rf /usr/local/memcached

# install php redis extension
cd /root
wget http://pecl.php.net/get/redis-2.2.8.tgz
tar -xvf redis-2.2.8.tgz
cd redis-2.2.8
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make -j $cpu_num
make install
sed -i '$a\extension = redis.so' /usr/local/php/etc/php.ini

cd /root
rm -rf libmemcached*
rm -rf memcached*
rm -rf redis*


cat >/usr/local/php/etc/php-fpm.conf<<EOF
[global]
pid = /usr/local/php/var/run/php-fpm.pid
error_log = /usr/local/php/var/log/php-fpm.log
log_level = notice

[www]
listen = /tmp/php-cgi.sock
listen.backlog = -1
listen.allowed_clients = any
listen.owner = www
listen.group = www
listen.mode = 0666
user = www
group = www
pm = dynamic
pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 6
request_terminate_timeout = 100
request_slowlog_timeout = 0
slowlog = /var/log/slow.log
EOF

echo "Copy php-fpm init.d file..."
cp /usr/local/src/php-5.5.36/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm

#modify zabbix on php.ini

sed -i '/^max_input_time/c max_input_time = 300' /usr/local/php/etc/php.ini

back 
rm -rf /usr/local/src/*
rm -rf *
apt-get clean
apt-get autoclean
rm -f /var/cache/apt/archives/*.deb
