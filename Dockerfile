FROM node:22-alpine AS ezwork_node
RUN mkdir /app
WORKDIR /app
#RUN apk add git
COPY ./admin /app/admin
COPY ./frontend /app/frontend
RUN /usr/local/bin/yarn config set registry  https://registry.npmmirror.com/ -g
WORKDIR /app/admin
RUN rm -rf /app/admin/public/config.js
COPY ./admin.js /app/admin/public/config.js
COPY ./admin.env /app/admin/.env.community
RUN /usr/local/bin/yarn
RUN /usr/local/bin/yarn build:community
WORKDIR /app/frontend
COPY ./frontend.env /app/frontend/.env.production
RUN /usr/local/bin/yarn
RUN /usr/local/bin/yarn build:prod
FROM ehewon/ezwork-ai:1.4  AS ezwork_ai
#ENV MYSQL_DATABASE=ezwork
#ENV MYSQL_USER=ezwork
#ENV MYSQL_PASSWORD=ezwork
#ENV MYSQL_ROOT_PASSWORD=ezwork
ENV MYSQL_CHARACTER_SET_SERVER=utf8mb4
ENV MYSQL_COLLATION_SERVER=utf8mb4_unicode_ci
RUN sed -i 's|;date.timezone =|date.timezone=Asia/Shanghai|g' /usr/local/php/etc/php.ini
COPY ./init.sql /docker-entrypoint-initdb.d/
COPY --from=ezwork_node /app/admin/dist /app/admin/dist
COPY --from=ezwork_node /app/frontend/dist /app/frontend/dist
COPY ./supervisord.conf /app/supervisord.conf
RUN apt-get update && apt-get install -y redis-server
RUN rm -rf /app/api
COPY ./api /app/api
COPY ./script.sh /app/script.sh
RUN chmod -R 777 /app/script.sh
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod -R 777 /usr/local/bin/docker-entrypoint.sh
COPY ./api.env /app/api/.env
RUN chmod -R 777 /app/api
WORKDIR /app/api/
RUN composer install
WORKDIR /app/api/python/translate
RUN /usr/local/bin/pip3.11  install -r ./requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --break-system-packages

WORKDIR /app
RUN cat /dev/null>/app/supervisord.log && chmod -R 777 /app/supervisord.log
# 暴露 PHP-FPM 默认端口
EXPOSE 9000
EXPOSE 5556
EXPOSE 5555
EXPOSE 3306
# 复制 Nginx 配置文件
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
RUN rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["mysqld"]

