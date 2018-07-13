#!/bin/bash
# nginx startup script

dir_null=$(ls /usr/local/nginx/html/)

if [[ -z $dir_null ]]; then
	mv /usr/local/src/php/* /usr/local/nginx/html/
    #chmod -R 777 /usr/local/nginx/html
    cat > /usr/local/nginx/html/conf/zabbix.conf.php << EOF
<?php
// Zabbix GUI configuration file.
global \$DB;

\$DB['TYPE']     = 'MYSQL';
\$DB['SERVER']   = 'mysql-server';
\$DB['PORT']     = '0';
\$DB['DATABASE'] = 'zabbix';
\$DB['USER']     = 'root';
\$DB['PASSWORD'] = '123456';

// Schema name. Used for IBM DB2 and PostgreSQL.
\$DB['SCHEMA'] = '';

\$ZBX_SERVER      = 'zabbix-server';
\$ZBX_SERVER_PORT = '10051';
\$ZBX_SERVER_NAME = 'zabbix-server';

\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;

EOF

	/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
else
	/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
fi
