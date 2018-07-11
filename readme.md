# docker-zabbix-server

### Synopsis

Zabbix is the ultimate enterprise-level software designed for real-time monitoring of millions of metrics collected from tens of thousands of servers, virtual machines and network devices.  

Zabbix is Open Source and comes at no cost.

> [https://www.zabbix.com](https://www.zabbix.com)

## [中文说明](https://github.com/ainy0293/docker-zabbix-server/zh_cn)

***

This a Zabbix server use docker container.

The components include nginx web server,  MySQL database service and  PHP

***

A total of 4 containers for this service. 

The list is as follows.

 - nginx

> **nginx** : A web server, Configure monitoring services and monitoring hosts, and display and view graphics.

 - php

> **php** : Because ZABBIX pages use PHP programs, parsing these pages requires PHP.  **This PHP container has supported most of the PHP's most commonly used functions, as well as php-redis and php-memcached.**

 - mysql

 > **MySQL** : Store monitoring, host, graphics, and other data

  - zabbix

> **zabbix** : ZABBIX Server program

***

#### Use service:

Please use ```pip``` , ```apt-get``` or ```yum``` command install **docker-compose**

Use the command on the following platform

	# debian, RedHat and CentOS 
	yum -y install epel-release
	yum -y install docker-compose

	# Deiban and ubuntu
	apt-get -y update
	apt-get -y install docker-compose

	# or use pip install
	pip install docker-compose

	# Get a series of code for docker
	git clone https://github.com/ainy0293/docker-zabbix-server.git

	# build and start the container
	cd docker-zabbix-server
	docker-compose up -d

The above operation will automatically build the docker image and start the container.

After the command is completed, Use the browser to visit: 

	http://yourip

***

### Other information  

##### Default account and password

##### zabbix

Zabbix account: admin
Zabbix password: zabbix 

##### MySQL 
Allow Host: %
User: root
Password: 123456

##### VOLUMES volume mapping

	/etc/localtime:/etc/localtime:ro

	/var/www/html/web/zabbix/:/usr/local/nginx/html/

##### Version

 - Nginx: 1.10.1
 - MySQL: 5.5.42
 - PHP: 5.6.22
 - Zabbix: 3.4.11
