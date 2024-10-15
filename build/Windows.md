# 部署文档 (非 Docker 部署)

## 概述

本文档详细描述了如何在全新的 Windows 系统上从头开始部署 EzWork 项目。EzWork 项目由 Python 后端、PHP 前端和 MySQL 数据库组成。以下将详细说明每个组件的安装与配置。

## 环境要求

- Windows 操作系统
- 必要的工具：`git`, `curl`, `Composer`, `Node.js`, `Python`
- 运行以下命令前，请确保您具有管理员权限。

## 步骤概述

1. 更新系统和安装必要的工具
2. 安装 Python 和相关包
3. 安装 PHP 和必要的扩展
4. 安装 MySQL 数据库
5. 下载并配置 EzWork 项目
6. 启动服务并配置数据库

## 1. 更新系统和安装必要的工具

确保您的 Windows 系统是最新的，接下来安装常用工具。

### 安装 Git

下载并安装 Git for Windows：[Git for Windows](https://git-scm.com/download/win)

### 安装 cURL

cURL 通常会预装在 Windows 10 及以后的版本中。如果没有，请下载并安装：[cURL for Windows](https://curl.se/windows/)

### 安装 Composer

下载并安装 Composer，以便管理 PHP 依赖：[Composer](https://getcomposer.org/download/)

### 安装 Node.js

下载并安装 Node.js：[Node.js](https://nodejs.org/)

### 安装 Python

下载并安装 Python 3.9（或所需版本）：[Python](https://www.python.org/downloads/)

安装完成后，确保在命令行中可以访问 Python 和 pip：

```bash
python --version
pip --version
```

## 2. 安装 Python 和相关包

### 安装所需的 Python 包

使用 pip 安装项目所需的 Python 库：

```bash
pip install openpyxl lxml openai pydantic_core python-docx==1.1.2 python-pptx pdf2docx pymysql PyMuPDF==1.24.7 docx2pdf python-dotenv pytesseract
```

## 3. 安装 PHP 和必要的扩展

### 安装 PHP

可以使用 [XAMPP](https://www.apachefriends.org/index.html) 来安装 PHP 和相关组件，选择 XAMPP 安装包并进行安装，确保把 Apache 和 MySQL 服务一起安装。

### 启动 Apache 和 MySQL

打开 XAMPP 控制面板，启动 Apache 和 MySQL 服务。

### 配置 PHP 扩展

在 XAMPP 的安装目录下，找到 `php.ini` 文件，启用需要的 PHP 扩展，例如 `extension=mysqli`，将其前面的 `;` 删除。

## 4. 安装 MySQL 数据库

如果您使用 XAMPP 安装了 MySQL，您可以直接通过 XAMPP 启动并配置 MySQL。

### 配置 MySQL

1. 通过 XAMPP 控制面板启动 MySQL。
2. 打开命令提示符，进入 MySQL 命令行：
   ```bash
   mysql -u root
   ```

3. 创建数据库和用户并授权：
   ```sql
   CREATE DATABASE ezwork;
   ```

### 初始化数据库

在您项目的 `init.sql` 文件中创建所需的表和初始数据。例如：

将上述 SQL 语句运行到 MySQL 中：

```bash
mysql -u root -p ezwork < ./init.sql
```

## 5. 下载并配置 EzWork 项目

### 克隆项目代码

在命令提示符中执行以下命令：

```bash
cd C:\path\to\your\project
git clone https://github.com/EHEWON/ezwork-ai-doc-translation.git ezwork
cd ezwork
git checkout master
git submodule update --init --recursive
cd api
git checkout master
git pull
composer install
cd ../frontend
git checkout master
git pull
cd ../admin
git checkout master
git pull
cd ..
```

### 配置 `.env` 文件

在 `api` 目录下创建 `.env` 文件并添加数据库连接信息：

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ezwork
DB_USERNAME=root
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

## 6. 启动服务

### VirtualHost

```bash
<VirtualHost *:80>
    ServerName your_defined_domain  # 定义访问域名

    DocumentRoot /var/www/ezwork/api/public

    <Directory /var/www/ezwork/api/public>
        AllowOverride All
        Require all granted
    </Directory>
    
    # 静态文件存储
    Alias /storage /var/www/ezwork/api/storage/app/public/
    <Directory /var/www/ezwork/api/storage/app/public>
        Require all granted
    </Directory>
    
    # PHP 处理
    <FilesMatch \.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>

    # 确保 Apache 能找到 PHP 处理程序
    <IfModule mod_proxy_fcgi.c>
        <FilesMatch \.php$>
            SetHandler "proxy:unix:/var/run/php/php8.2-fpm.sock|fcgi://localhost/"
        </FilesMatch>
    </IfModule>
</VirtualHost>
```

### 启动 Apache

确保 Apache 服务正在运行，可以在 XAMPP 控制面板中查看。


修改 `frontend.env` 文件中的 API 接口地址，并拷贝到 `frontend` 目录：

```bash
copy frontend.env frontend\.env
```

修改 `admin.env` 文件中的 API 接口地址，并拷贝到 `admin` 目录：

```bash
copy admin.env admin\.env
```

### 构建前端和管理平台

首先确保您已安装 Yarn，您可以通过 npm 安装 Yarn：

```bash
npm install --global yarn
```

#### 运行用户端：

```bash
cd C:\path\to\your\project\ezwork\frontend
yarn 
yarn dev
```

#### 运行管理后台端：

```bash
cd C:\path\to\your\project\ezwork\admin
yarn
yarn dev
```
