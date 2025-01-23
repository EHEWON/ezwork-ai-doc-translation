#!/bin/sh
supervisord  -c /app/supervisord.conf
/bin/sh /usr/local/bin/docker-entrypoint.sh mysqld