#!/bin/sh

if [ -z "${APP_URL+x}" ]; then
	exit 1
fi

REG_APP_URL=$(echo "$APP_URL" | sed 's/\./\\./g')
for adminjs in `find /app/admin/dist/static  -name '*.js'`
do

  ADMIN_REG='s|baseURL:"[a-zA-Z0-9:-\./]*/api/admin"|baseURL:"'$REG_APP_URL'/api/admin"|g' 
  echo $ADMIN_REG
  sed -i -r  "$ADMIN_REG" $adminjs
done
for frontendjs in `find /app/frontend/dist/assets  -name '*.js'`
do
  FRONTEND_REG='s|baseURL:"[a-zA-Z0-9:-\./]*"|baseURL:"'$REG_APP_URL'"|g'
  echo $FRONTEND_REG
  sed -i -r  $FRONTEND_REG $frontendjs
done
API_REG='s|APP_URL=.*|APP_URL="'$REG_APP_URL'"|g'
sed -i -r $API_REG /app/api/.env
