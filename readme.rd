# docker-zabbix-server

***

### Synopsis

Zabbix is monitor

> [https://www.zabbix.com](https://www.zabbix.com)

***

This a Zabbix server use docker container.

The components include nginx web server,  MySQL database service and  PHP

#### Use service:

Please ```pip``` , ```apt-get``` or ```yum``` install docker-compose

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

	# uild and start the container
	cd docker-zabbix-server
	docker-compose up -d

The above operation will automatically build the docker image and start the container.

Use the browser to visit: 

	http:yourip

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

END
