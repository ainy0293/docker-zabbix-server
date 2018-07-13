#!/bin/bash

dir_null=$(ls /usr/local/mysql/data)

if [[ -z $MYSQL_ROOT_PASSWORD ]]; then
        echo "Error, You not define mysql root password"
	echo -e "Usage: docker run -d -p 3306:3306 --name mysql-server \033[31m -e MYSQL_ROOT_PASSWORD=your_password \033[0m ainy/mysql"
        exit 1
fi

if [[ -z $MYSQL_ALLOW_HOST ]]; then
	echo "You not define mysql allow connect host,usage default value"
	echo "default values is %"
        MYSQL_ALLOW_HOST=%
fi

#if [[ -z $MYSQL_USER ]]; then
	MYSQL_USER=root
#fi

#if [[ -z $DATABASE ]]; then
	DATABASE=*
#fi

# if [ $DATABASE != * ]; then
# 	mysql -uroot -e "create database $DATABASE"
# fi

if [ -z $dir_null -o "$dir_null" == "test" ]; then
	sed -i '23s/^/#/g' /etc/my.cnf
	sed -i '33s/^/#/g' /etc/my.cnf

	/usr/local/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --user=mysql
    chgrp mysql /usr/local/mysql/.

	nohup /usr/local/mysql/bin/mysqld --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --plugin-dir=/usr/local/mysql/lib/plugin --user=mysql --log-error=/usr/local/mysql/data/mysql-server.err --open-files=65535 --pid-file=/usr/local/mysql/data/mysql-server.pid --socket=/tmp/mysql.sock --port=3306 > /dev/null 2>&1 &
	
	while true
		do
			if ! /usr/local/mysql/bin/mysql -uroot -e "SELECT VERSION()" > /dev/null 2>&1 ; then
                sleep 1
                continue
            else
                /usr/local/mysql/bin/mysql -uroot -e "CREATE DATABASE zabbix;"
                /usr/local/mysql/bin/mysql -uroot zabbix < /root/schema.sql
                /usr/local/mysql/bin/mysql -uroot zabbix < /root/images.sql
                /usr/local/mysql/bin/mysql -uroot zabbix < /root/data.sql
                /usr/local/mysql/bin/mysql -uroot -e "GRANT ALL PRIVILEGES ON ${DATABASE}.* TO '${MYSQL_USER}'@'${MYSQL_ALLOW_HOST}' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
                /usr/local/mysql/bin/mysql -uroot -e "FLUSH PRIVILEGES;"
                sync
                break
            fi
        done

	# /etc/init.d/mysql start

	sleep 1
	# /etc/init.d/mysql stop
	# kill $(cat /usr/local/mysql/data/mysql-server.pid)
    /etc/init.d/mysql stop
    sleep 1
    while true
        do
            if /usr/local/mysql/bin/mysql -uroot -e "SELECT VERSION()" > /dev/null 2>&1; then
                sleep 2
                continue
            else
                sleep 1
                break
            fi
        done
    sleep 1

	rm -f /tmp/mysql.sock.lock
	/usr/local/mysql/bin/mysqld_safe
else
	rm -f /tmp/mysql.sock.lock
	/usr/local/mysql/bin/mysqld_safe
fi

