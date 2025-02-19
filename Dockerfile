FROM node:22-alpine AS ezwork_node
RUN mkdir /app
WORKDIR /app
#RUN apk add git
COPY ./admin /app/admin
COPY ./frontend /app/frontend
RUN /usr/local/bin/yarn config set registry  https://registry.npmmirror.com/ -g
WORKDIR /app/admin
COPY ./admin.env /app/admin/.env.community
RUN /usr/local/bin/yarn
RUN /usr/local/bin/yarn build:community
WORKDIR /app/frontend
COPY ./frontend.env /app/frontend/.env.production
RUN /usr/local/bin/yarn
RUN /usr/local/bin/yarn build:prod
FROM ehemart/ezwork-ai:1.1  AS ezwork_ai
RUN apt clean && apt autoclean && apt update && apt install --fix-missing && apt install -y locales && dpkg-reconfigure locales
RUN echo "LANG=zh_CN.UTF-8" |  tee -a /etc/locale.gen | locale-gen
RUN sed -i 's|;date.timezone =|date.timezone=Asia/Shanghai|g' /usr/local/php/etc/php.ini
COPY ./init.sql /docker-entrypoint-initdb.d/
COPY --from=ezwork_node /app/admin/dist /app/admin/dist
COPY --from=ezwork_node /app/frontend/dist /app/frontend/dist
COPY ./api.env /app/api/.env
WORKDIR /app/api/
RUN composer install
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
