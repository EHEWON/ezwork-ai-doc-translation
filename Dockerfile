FROM ehewon/ezwork-ai:latest

# 设置工作目录
WORKDIR /app
# 复制源代码
COPY . .

RUN rm -rf /app/frontend/node_modules/
RUN rm -rf /app/frontend/dist/
RUN rm -rf /app/admin/node_modules/
RUN rm -rf /app/admin/dist/

# 构建前端 
WORKDIR /app/frontend
COPY frontend.env .env.production
RUN yarn
RUN yarn build:prod

# 构建后端
WORKDIR /app/admin
COPY admin.env .env.production
RUN yarn
RUN yarn build:prod

#安装接口依赖
WORKDIR /app/api
COPY api.env .env
RUN chmod -R 777 storage
RUN composer install

# 暴露 PHP-FPM 默认端口
EXPOSE 9000
EXPOSE 80
EXPOSE 3306

# 复制 Nginx 配置文件
COPY nginx.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT ["supervisord", "-c", "/app/supervisord.conf"]

