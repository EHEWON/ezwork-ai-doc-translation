# 项目安装与配置文档

## 目录

- [前言](#前言)
- [环境要求](#环境要求)
- [克隆主仓库](#克隆主仓库)
- [更新子模块](#更新子模块)
- [修改 .env 文件](#修改-env-文件)
- [Docker Compose 配置](#docker-compose-配置)
- [构建与启动服务](#构建与启动服务)
- [访问应用](#访问应用)
- [常见问题](#常见问题)

## 前言

本项目由四个主要部分组成：`api`、`frontend`、`admin` 和主仓库。主仓库使用 Git 子模块的方式引用其他三个仓库。我们将使用 Docker Compose 来部署这些服务。

## 环境要求

在开始之前，请确保你的系统上安装了以下软件：

- [Docker](https://docs.docker.com/get-docker/) - 用于容器化应用。
- [Docker Compose](https://docs.docker.com/compose/install/) - 用于定义和运行多容器 Docker 应用。
- [Git](https://git-scm.com/) - 用于版本控制和代码管理。

## 克隆主仓库

首先，克隆主仓库到本地,并更新子模块

```bash
git clone https://github.com/EHEWON/ezwork-ai-doc-translation.git ezwork-ai-doc-translation
cd ezwork-ai-doc-translation
git submodule update --init --recursive
```


## 修改 .env 文件
> 找到 api.env 文件,需要修改配置文件中关于邮箱部分的定义，用于邮箱发送验证码,

修改完成之后，将代码复制到接口目录
```bash
cp api.env api/.env
```

> 找到frontend.env文件，修改接口地址，端口映射在docker-compose.yml中定义，域名在nginx.conf中定义

修改完成之后，将代码复制到前端目录
```bash
cp frontend.env frontend/.env
```

> 找到admin.env文件，修改接口地址，端口映射在docker-compose.yml中定义，域名在nginx.conf中定义

修改完成之后，将代码复制到后台目录
```bash
cp admin.env admin/.env
```


## 构建与启动服务
```bash
docker-compose up -d --build
```

## 进入api服务格外安装libreoffice
```bash
docker exec -it  ezwork_api bash
apt install libreoffice unoconv
```

## 访问应用

Frontend: 访问 http://localhost:3000 来查看前端应用。

Backend: 访问 http://admin.localhost:3000 来查看后台应用。


## 常见问题
1. 如何停止服务？
要停止所有服务，可以运行：
```bash
docker-compose down
```

### 2. 如何查看日志？
要查看服务的日志，可以使用：
```bash
docker-compose logs
```

## 3. 如何重建服务？
如果你对代码进行了更改并希望重建服务，可以运行：
```bash
docker-compose up -d --build
```

## 4. 如何访问数据库？
你可以通过 MySQL 客户端连接到数据库，使用以下连接信息：
```bash
docker-compose exec db mysql -uroot -p
```

