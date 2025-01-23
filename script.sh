#!/bin/sh
/bin/sh /usr/local/bin/docker-entrypoint.sh mysqld
supervisord  -c /app/supervisord.conf
