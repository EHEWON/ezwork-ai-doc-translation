# 部署文档 (非 Docker 部署)

## 概述

本文档详细描述了如何在全新的 Linux 系统上从头开始部署 EzWork 项目。EzWork 项目由 Python 后端、PHP 前端和 MySQL 数据库组成。以下将详细说明每个组件的安装与配置。

## 环境要求

- Linux 操作系统（Ubuntu）
- 必要的工具：`git`, `curl`, `wget`
- 运行以下命令前，请确保您有 sudo 权限。

## 步骤概述

1. 更新系统和安装必要的工具
2. 安装 Python 和相关包
3. 安装 PHP 和必要的扩展
4. 安装 MySQL 数据库
5. 下载并配置 EzWork 项目
6. 启动服务并配置数据库

## 1. 更新系统和安装必要的工具

首先，更新系统并安装常用工具：

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y git curl wget nodejs libreoffice unoconv
#需要安装的nodejs最低版本为22
node -v
#如果版本过低
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
```

## 2. 安装 Python 和相关包

接下来，安装 Python 3.9（根据项目需要安装的版本）及所需的 Python 库。

### 安装 Python 3.9

```bash
sudo apt install -y python3.9 python3-pip
```

### 安装所需的 Python 包

```bash
# 安装所需的 Python 包
pip install openpyxl lxml openai pydantic_core python-docx==1.1.2 python-pptx pdf2docx pymysql PyMuPDF==1.24.7 docx2pdf python-dotenv pytesseract
```

## 3. 安装 PHP 和必要的扩展

### 安装 PHP 8.2

```bash
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php

sudo apt update
sudo apt install -y php8.2 php8.2-fpm php8.2-mysql php8.2-zip php8.2-bcmath
```


### 启动 PHP-FPM

```bash
# 查看php对应的服务名称
sudo systemctl status | grep php
sudo systemctl start php8.2-fpm
sudo systemctl enable php8.2-fpm
```

#### 安装 PHP 8.2 (源码安装,当源没有的话) 

### 步骤 1: 安装编译工具和依赖

在开始之前，您需要先安装一些编译 PHP 所需的工具和依赖库。

```bash
sudo apt update
sudo apt install -y build-essential libxml2-dev libcurl4-openssl-dev pkg-config libssl-dev libzip-dev libonig-dev
```


### 步骤 2: 下载 PHP 8.2 源代码

访问 PHP 官网，下载 PHP 8.2 的源代码。您可以使用 `wget` 命令下载所需版本的 PHP。

```bash
cd /usr/src
sudo wget https://www.php.net/distributions/php-8.2.0.tar.gz
sudo tar -xzvf php-8.2.0.tar.gz
cd php-8.2.0
```


### 步骤 3: 配置 PHP

运行 `./configure` 以配置 PHP 构建选项。您可以根据需求调整这些选项。以下是一个示例配置命令，包括 MySQL、zip 和 bcmath 扩展。

```bash
sudo ./configure --with-mysqli=mysqlnd \
    --with-curl \
    --with-openssl \
    --enable-mbstring \
    --with-zlib \
    --enable-bcmath \
    --with-zip \
    --enable-fpm
```

### 步骤 4: 编译和安装 PHP

接下来，使用 `make` 编译 PHP 并安装它。

```bash
sudo make
sudo make install
```

### 步骤 5: 配置 PHP-FPM

您通常需要设置 PHP-FPM 以便在 Web 服务器中正确使用 PHP。

```bash
sudo cp php.ini-production /usr/local/lib/php.ini
sudo cp sapi/fpm/php-fpm.conf /usr/local/etc/php-fpm.conf
sudo cp sapi/fpm/www.conf /usr/local/etc/php-fpm.d/www.conf
```

### 步骤 6: 启动 PHP-FPM

启动 PHP-FPM 服务:

```bash
# 查看php对应的服务名称
sudo systemctl status | grep php
#CGroup: /system.slice/php-fpm-80.service
sudo systemctl start php-fpm-80
sudo systemctl enable php-fpm-80
```


## 4. 安装 MySQL 数据库

### 安装 MySQL

```bash
sudo apt install mysql-server-8.0
```

### 启动 MySQL 服务

```bash
# Ubuntu
sudo systemctl start mysql
sudo systemctl enable mysql
```

### 配置 MySQL

设置 MySQL root 用户密码并创建数据库：

```bash
sudo mysql_secure_installation

# 登录 MySQL
mysql -uroot -p

# 创建数据库和用户并授权
CREATE DATABASE ezwork;
```

### 初始化数据库

在您项目的 `init.sql` 文件中创建所需的表和初始数据。例如：

将上述 SQL 语句运行到 MySQL 中。

```bash
mysql -uroot -p ezwork < ./init.sql
```

## 5. 下载并配置 EzWork 项目

### 克隆项目代码

```bash
cd /var/www
sudo git clone https://github.com/EHEWON/ezwork-ai-doc-translation.git ezwork
cd ezwork
sudo git checkout master
sudo git submodule update --init --recursive
cd api
sudo git checkout master
sudo git pull
sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
sudo composer install
cd ../frontend
sudo git checkout master
sudo git pull
cd ../admin
sudo git checkout master
sudo git pull
cd ..
```

### 配置 `.env` 文件

在 `api` 目录下创建 `.env` 文件并添加数据库连接信息：

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ezwork
DB_USERNAME=ezworkuser
DB_PASSWORD=your_password

#设置邮件系统
MAIL_DRIVER=smtp
MAIL_HOST=s
MAIL_PORT=80
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_FROM_ADDRESS=
MAIL_FROM_NAME='Ehe Admin'
```

修改frontend.env文件中的api接口地址。 修改完后拷贝到frontend目录
```bash
cp frontend.env frontend/.env
```

修改admin.env文件中的api接口地址。 修改完后拷贝到admin目录
```bash
cp admin.env admin/.env
```

### 构建前端和管理平台

```bash
cd /var/www/ezwork/frontend
sudo yarn 
sudo yarn build
sudo cp -r dist/* ../api/public/frontend
cd ../admin
sudo yarn
sudo yarn build:prod
sudo cp -r dist/* ../api/public/admin
```

## 6. 启动服务

### 启动 PHP-FPM

确认 PHP-FPM 正在运行：

```bash
sudo systemctl status php-fpm-80
```

### 启动 Nginx

如果您需要通过 Nginx 作为反向代理来处理 HTTP 请求，可以安装并配置 Nginx：

```bash
sudo apt install -y nginx
```

### 配置 Nginx

在 `/etc/nginx/conf.d/` 目录下创建一个新的配置文件（如 `ezwork`），并添加以下内容：

```nginx
server {
    listen 80;
    server_name ezwork.com;

    root /var/www/ezwork/api/public/frontend;
    index index.html;

    location /api/ {
        try_files $uri $uri/ /index.php?s=$1; 
    }

    location /admin {
        root /var/www/ezwork/api/public/admin;
        try_files $uri $uri/ /index.html; 
    }

    location /storage/ {
        alias /var/www/ezwork/storage/app/public/;
        try_files $uri $uri/ =404;
    }

    location / {
        try_files $uri $uri/ /index.html; 
    }

    location ~ \.php$ {
        root /var/www/ezwork/api/public;
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}

```

### 启动 Nginx

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 访问应用

在浏览器中访问您的域名或服务器 IP，比如 `http://your_domain_or_IP`。
