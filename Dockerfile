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
RUN apt-get update 
 && apt-get install -y --no-install-recommends gnupg 
 && rm -rf /var/lib/apt/lists/*
COPY ./app/init.sql /docker-entrypoint-initdb.d/
# 安装必要的扩展
ENV VITE_BASE_API=47.91.229.195
RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    bzip2 \
    cron \
    curl \
    dpkg-dev \
    file \
    g++ \
    gcc \
    git \
    hostname \
    libc-dev \
    libjpeg-dev \
    libpng-dev \
    libreoffice \
    libssl-dev \
    libtool \
    libwebp-dev \
    libxml2 \
    libxml2-dev \
    libxslt-dev \
    libxslt1.1 \
    libzip-dev \
    make \
    man \
    net-tools \
    nginx \
    passwd \
    pkg-config \
    python3-pip \
    python3.11 \
    re2c \
    rsync \
    supervisor \
    tar \
    telnet \
    unoconv \
    unzip \
    vim \
    wget
RUN apt-get install -y --no-install-recommends libargon2-dev libcurl4-openssl-dev libonig-dev libreadline-dev libsodium-dev libsqlite3-dev libssl-dev libxml2-dev zlib1g-dev 
RUN apt-get install -y --no-install-recommends ca-certificates curl xz-utils  gnupg libkrb5-dev krb5-user  libgssapi-krb5-2
RUN rm -rf /var/lib/apt/lists/*;
RUN wget -O /mnt/php-8.2.24.tar.gz https://www.php.net/distributions/php-8.2.24.tar.gz 
RUN wget -O /mnt/freetype-2.10.0.tar.gz https://download.savannah.gnu.org/releases/freetype/freetype-2.10.0.tar.gz
RUN wget -O /mnt/jpegsrc.v9e.tar.gz  http://www.ijg.org/files/jpegsrc.v9e.tar.gz
RUN wget -O /mnt/xlswriter-1.5.1.tgz https://pecl.php.net/get/xlswriter-1.5.1.tgz
RUN wget -O /mnt/redis-5.3.5.tgz https://pecl.php.net/get/redis-5.3.5.tgz
RUN wget -O /mnt/oniguruma-6.9.4.tar.gz  https://github.com/kkos/oniguruma/archive/v6.9.4.tar.gz --no-check-certificate
RUN wget -O /mnt/libpng-1.5.30.tar.gz  https://sourceforge.net/projects/libpng/files/libpng15/1.5.30/libpng-1.5.30.tar.gz --no-check-certificate
RUN wget -O /mnt/libsodium-1.0.18.tar.gz https://github.com/jedisct1/libsodium/releases/download/1.0.18-RELEASE/libsodium-1.0.18.tar.gz \
&& cd /mnt/ \
&& tar zxf libsodium-1.0.18.tar.gz \
&& cd libsodium-1.0.18 \
&& ./configure --libdir=/lib64 \
&& make && make install \
&& rm /mnt/libsodium-1.0.18.tar.gz && rm -rf /mnt/libsodium-1.0.18
RUN cd /mnt/ && tar -zxvf jpegsrc.v9e.tar.gz &&  cd jpeg-9e && ./configure --enable-shared && make && make install
RUN wget https://github.com/kkos/oniguruma/archive/v6.9.4.tar.gz -O oniguruma-6.9.4.tar.gz 
RUN cd /mnt/ && tar -zxvf oniguruma-6.9.4.tar.gz && cd oniguruma-6.9.4/ && ./autogen.sh && ./configure --prefix=/usr --libdir=/lib64 \
 && make && make install && rm /mnt/oniguruma-6.9.4.tar.gz && rm -rf /mnt/oniguruma-6.9.4
RUN cd /mnt/ && tar -zxvf jpegsrc.v9e.tar.gz &&  cd jpeg-9e && ./configure --enable-shared && make && make install \
&& rm /mnt/jpegsrc.v9e.tar.gz && rm -rf /mnt/jpeg-9e
RUN cd /mnt/ && tar -zxvf /mnt/libpng-1.5.30.tar.gz &&  cd libpng-1.5.30 && ./configure && make && make install \
&& rm /mnt/libpng-1.5.30.tar.gz && rm -rf /mnt/libpng-1.5.30
RUN cd /mnt/ && tar -zxvf freetype-2.10.0.tar.gz && cd freetype-2.10.0 && ./configure && make && make install \
&& rm /mnt/freetype-2.10.0.tar.gz && rm -rf /mnt/freetype-2.10.0
RUN cd /mnt/ && export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig/" && tar -zxvf /mnt/php-8.2.24.tar.gz && cd php-8.2.24 && \
 ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-mysqli --with-pcre-regex \
--with-pdo-mysql --with-pdo-sqlite --with-pear --with-png-dir --with-xmlrpc --with-openssl --with-xsl --with-curl \
--with-zlib --with-zlib --enable-fpm --enable-bcmath --enable-libxml --enable-inline-optimization --enable-gd-native-ttf \
--enable-mbregex --enable-mbstring --enable-opcache --enable-pcntl --with-fpm-user=root --with-fpm-group=root --with-gettext \
--enable-shmop --enable-soap --enable-sockets --enable-sysvsem --enable-xml --enable-zip --with-iconv-dir --with-kerberos \
--enable-mbstring --enable-exif --with-libdir=lib64 --with-libxml-dir --with-freetype-dir --with-gd --with-jpeg-dir \
--with-kerberos && make && make install \
&& cp ./php.ini-production /usr/local/php/etc/php.ini \
&& cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf \
&& cp /usr/local/php/etc/php-fpm.d/www.conf.default  /usr/local/php/etc/php-fpm.d/www.conf
RUN cd /mnt/ && tar -zxvf redis-5.3.5.tgz && cd redis-5.3.5 && /usr/local/php/bin/phpize \
&& ./configure --with-php-config=/usr/local/php/bin/php-config \
&& make && make install \
&& echo "extension = redis.so" >>/usr/local/php/etc/php.ini  \
&& rm /mnt/redis-5.3.5.tgz && rm -rf /mnt/redis-5.3.5
RUN cd /mnt/ &&  tar -zxvf xlswriter-1.5.1.tgz &&  cd xlswriter-1.5.1 \
&& /usr/local/php/bin/phpize &&  ./configure --with-php-config=/usr/local/php/bin/php-config \
&& make && make install \
&& echo "extension = xlswriter.so" >>/usr/local/php/etc/php.ini  \
&& rm /mnt/xlswriter-1.5.1.tgz && rm -rf /mnt/xlswriter-1.5.1
RUN cd /mnt/php-8.2.24/ext/sodium  \
&& /usr/local/php/bin/phpize &&  ./configure --with-php-config=/usr/local/php/bin/php-config \
&& make && make install \
&& echo "extension = sodium.so" >>/usr/local/php/etc/php.ini  \
&& rm /mnt/php-8.2.24.tar.gz && rm -rf /mnt/php-8.2.24
RUN sed -i 's|post_max_size = 8M|post_max_size = 80M|g' /usr/local/php/etc/php.ini
RUN sed -i 's|upload_max_filesize = 2M|upload_max_filesize = 80M|g' /usr/local/php/etc/php.ini

RUN echo "export PATH=\$PATH:/usr/local/php/bin" >>/etc/profile
COPY ./app/crontab /etc/cron.d/crontab
RUN  chmod 0644 /etc/cron.d/crontab
RUN rm -rf /var/lib/apt/lists/* 
# 暴露 PHP-FPM 默认端口
WORKDIR /app
RUN mkdir /docker-entrypoint-initdb.d/
RUN mkdir /etc/mysql/
RUN chmod 777 /etc/mysql/
RUN chmod 777 /docker-entrypoint-initdb.d/
RUN docker-php-ext-install pdo pdo_mysql zip bcmath
RUN /usr/bin/python3.11 -m pip install --upgrade pip --break-system-packages
COPY --from=ezwork_mysql /var/lib/mysql /var/lib/mysql
COPY --from=ezwork_mysql /etc/mysql/ /etc/mysql/
COPY --from=ezwork_mysql /docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
COPY --from=ezwork_mysql /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh
COPY ./script.sh /usr/local/bin/script.sh && RUN chmod 777 /usr/local/bin/script.sh
COPY ./init.sql /docker-entrypoint-initdb.d/
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
RUN groupadd -r mysql && useradd -r -g mysql mysql
ENV GOSU_VERSION=1.17
ENV MYSQL_MAJOR=8.0
ENV MYSQL_VERSION=8.0.40-1debian12
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
RUN systemctl enable mysql
RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld 
ENTRYPOINT ["/usr/local/bin/script.sh"]

