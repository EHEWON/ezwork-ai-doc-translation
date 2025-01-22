FROM dockerpull.cn/node:22-alpine AS ezwork_node
ENV VITE_BASE_API=localhost
RUN mkdir /app
WORKDIR /app
RUN apk add git
COPY ./admin /app/admin
COPY ./frontend /app/frontend
RUN /usr/local/bin/yarn config set registry  https://registry.npmmirror.com/ -g
WORKDIR /app/admin
COPY ./admin.env /app/admin/.env.production
RUN /usr/local/bin/yarn
RUN /usr/local/bin/yarn build:prod
WORKDIR /app/frontend
COPY ./frontend.env /app/frontend/.env.production
RUN /usr/local/bin/yarn
RUN /usr/local/bin/yarn build:prod
FROM dockerpull.cn/python:3.11 AS python-env
RUN pip install --upgrade pip
# 安装所需的 Python 包
RUN pip install --no-cache-dir PyMuPDF==1.24.7 bs4 docx2pdf lxml markdown openai openpyxl pdf2docx pdfdeal pydantic_core pymdown-extensions pymysql pytesseract python-docx==1.1.2 python-dotenv python-pptx shapely

FROM dockerpull.cn/mysql:8.0.40-debian  AS ezwork_mysql
ENV MYSQL_DATABASE=ezwork
ENV MYSQL_USER=ezwork
ENV MYSQL_PASSWORD=ezwork
ENV MYSQL_ROOT_PASSWORD=ezwork
COPY ./init.sql /docker-entrypoint-initdb.d/
FROM dockerpull.cn/php:8.2-fpm
# 安装必要的扩展

RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    vim \
    libzip-dev \
    mariadb-server \
    python3.11 \
    python3-pip \
    libreoffice \
    unoconv \
    nginx \
    cron \
    supervisor

# 暴露 PHP-FPM 默认端口
WORKDIR /app

RUN docker-php-ext-install pdo pdo_mysql zip bcmath
RUN /usr/bin/python3.11 -m pip install --upgrade pip --break-system-packages
COPY --from=ezwork_mysql /var/lib/mysql /var/lib/mysql
RUN mkdir /docker-entrypoint-initdb.d/
COPY --from=ezwork_mysql /docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
COPY .init.sql /docker-entrypoint-initdb.d/
ENV VITE_BASE_API=localhost
ENV MYSQL_DATABASE=ezwork
ENV MYSQL_USER=ezwork
ENV MYSQL_PASSWORD=ezwork
ENV MYSQL_ROOT_PASSWORD=ezwork
# 复制源代码
RUN mkdir /app
RUN alias ll="ls -l"
COPY ./crontab /etc/cron.d/crontab
RUN  chmod 0644 /etc/cron.d/crontab
COPY ./admin /app/admin
COPY ./frontend /app/frontend
COPY ./api /app/api
COPY ./api.env /app/api/.env
RUN chmod -R 777 /app
WORKDIR /app/api
RUN chmod -R 777 storage
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 
RUN composer install
WORKDIR /app/api/python/translate
COPY --from=python-env /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/dist-packages
RUN /usr/local/bin/pip3.11  install -r ./requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --break-system-packages
COPY --from=ezwork_node /app/admin/dist /app/admin/dist
COPY --from=ezwork_node /app/frontend/dist /app/frontend/dist
# 暴露 PHP-FPM 默认端口
EXPOSE 9000
EXPOSE 5556
EXPOSE 5555
EXPOSE 3306
# 复制 Nginx 配置文件
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
RUN /usr/bin/mysqld_safe &
ENTRYPOINT ["supervisord", "-c", "/app/supervisord.conf"]

