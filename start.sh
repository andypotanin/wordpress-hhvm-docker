#!/bin/bash

cd /home/wordpress/wordpress
if ! grep -Fxq "define( 'Object', 'OBJECT', true );" wp-includes/wp-db.php
then
  sed -i -r "/define\(\s*'OBJECT',\s+'OBJECT',\s+true\s*\);/a define( 'Object', 'OBJECT' );" wp-includes/wp-db.php
fi
if ! grep -Fxq "define( 'object', 'OBJECT', true );" wp-includes/wp-db.php
then
  sed -i -r "/define\(\s*'OBJECT',\s+'OBJECT',\s+true\s*\);/a define( 'object', 'OBJECT' );" wp-includes/wp-db.php
fi
sed -i -r "s/define\(\s*'OBJECT',\s+'OBJECT',\s+true\s*\);/define( 'OBJECT', 'OBJECT' );/" wp-includes/wp-db.php
mv ../wp-config.php ./
chown wordpress:wordpress wp-config.php ../production-config.php

/usr/bin/hhvm --config /etc/hhvm/server.hdf --user www-data --mode daemon -vServer.Type=fastcgi -vServer.Port=9000 &
service nginx start

tail -f /var/log/nginx/error.log
