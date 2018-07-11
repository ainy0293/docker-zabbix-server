# docker-zabbix-server

### 简介

Zabbix 是一款企业级监控软件，用于监控服务器，网络设备，以及虚拟机，收集指标，并以图形的方面，以web界面来进行友好的展示。

Zabbix 是开源软件，不需要您花费任何代价，官网如下：

> [https://www.zabbix.com](https://www.zabbix.com)

***

这是一个使用docker 容器来运行的 Zabbix 服务端程序。

这个服务，一共使用了4个容器。如下列表：

 - nginx

> **nginx** : web 服务器，用以配置被监控设备，以及查看性能指标，分析图形等。

 - php

> 因为 Zabbix 页面使用了PHP程序，所以需要它来解析页面。**这个容器已经包含了php所使用的绝大多数常用函数，还添加了 php-redis 和 php-memcached 的支持**
 - mysql

 > **MySQL** : 存储配置项，被监控主机，性能图形，以及其它一些数据

  - zabbix

> **zabbix** : ZABBIX 服务端程序

***

#### 使用服务

请使用 ```pip``` , ```apt-get``` 或 ```yum``` 命令来安装 **docker-compose**

在下列平台上执行相应的命令来安装 docker-compose

	# RedHat and CentOS 
	yum -y install epel-release
	yum -y install docker-compose

	# Deiban and ubuntu
	apt-get -y update
	apt-get -y install docker-compose

	# or use pip install
	pip install docker-compose

	# 获取docker服务代码以其它文件
	git clone https://github.com/ainy0293/docker-zabbix-server.git

	# 构建并且运行服务
	cd docker-zabbix-server
	docker-compose up -d

上面的操作，将自动构建 ```images```，并且自动创建容器，自动启动容器，并提供服务

等待命令完成之后，使用浏览器访问

	http://yourip

***

### 其它信息

##### 默认账号和密码

##### zabbix

Zabbix account: admin

Zabbix password: zabbix 

##### MySQL 

Allow Host: %

User: root

Password: 123456

##### 卷映射

	/etc/localtime:/etc/localtime:ro

	/var/www/html/web/zabbix/:/usr/local/nginx/html/


##### 组件版本信息
 
 - Nginx: 1.10.1
 - MySQL: 5.5.42
 - PHP: 5.6.22
 - Zabbix: 3.4.11
