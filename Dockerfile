# 使用 Node.js 作为基础镜像
FROM node:20 AS build

# 设置工作目录
WORKDIR /app/frontend

# 复制源代码
COPY ./frontend .

RUN rm -rf /app/frontend/node_modules/
RUN rm -rf /app/frontend/dist/

# 安装依赖
RUN yarn

# 编译 Vue 应用
RUN yarn build

WORKDIR /app/admin

# 复制源代码
COPY ./admin .

RUN rm -rf /app/admin/node_modules/
RUN rm -rf /app/admin/dist/

# 安装依赖
RUN yarn

# 编译后台
RUN yarn build:prod

# 使用 Nginx 作为生产环境服务器
FROM nginx:alpine

# 复制编译后的文件到 Nginx 目录
COPY --from=build /app/frontend/dist /var/www/frontend
COPY --from=build /app/admin/dist /var/www/admin

# 复制 Nginx 配置文件
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80
