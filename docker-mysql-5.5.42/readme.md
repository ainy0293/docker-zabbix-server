# mysql on docker


this is MySQL server run on docker container. MySQL version is 5.5.42

container images is ubuntu 14.04，use mysql source code compile install mysql server in this images. 

modify the container ubuntu apt source to wangyi ( 163 ) source


The MySQL configuration file to do a little optimization. Enabled Innodb engine and set default engine.


### make images:

enter source code directory and use command

	sudo docker build -t ainy/mysql:5.5.42 .

Option： `-t` this option specify image name, and tag

wait for it to finish

### see image

see image, use command

	sudo docker images

### Run container from image, and setting MySQL root password

> ***PS: The first time you start, need initialize the system database, it may take a little time.***

use command
 
	sudo docker run -d -p 3306:3306 --name mysql-server -h mysql-server -e MYSQL_ROOT_PASSWORD=123456 ainy/mysql:5.7.17

Usage: -e  MYSQL_ROOT_PASSWORD=123456 set your root password, ***123456*** is your password

> Tips: Mysql root password must set, if you not set root password, this cann't start container.

### Specify host access to MySQL server 

use command

	sudo docker run -d -p 3306:3306 --name mysql-server -h mysql-server -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_ALLOW_HOST=172.27.32.10 ainy/mysql:5.7.17

Usage: -e MYSQL_ALLOW_HOST=172.27.32.10, ***172.27.32.10*** is you need connection host. 

> Tips: If you not set allow access host, use default values is %, any host can be connection to this MySQL server

### see container

use command 

	sudo docker ps