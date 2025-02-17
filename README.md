# EZ-work文档翻译

人人可用的AI文档翻译助手，可以快速低成本调用OpenAI等大语言模型api，帮助您实现txt、word、csv、excel、pdf、ppt的文档翻译。

- 支持txt、markdown、word、csv、excel、pdf、ppt文档AI翻译
- 支持扫描pdf翻译
- 支持兼容OpenAI格式的任何端点API（中转API）
- 支持批量操作
- 支持多线程
- 支持Docker部署

[注册即送0.5美金，邀请新人再送0.5美金，限前20名用户！已接入DeepSeek V3和R1模型，OpenAI中转API购买推荐（同时包含Anthropic模型）>>](https://api.ezworkapi.top)

## 程序截图

### 用户前台

![图片](https://github.com/user-attachments/assets/d2fcf98a-4c6e-4c4a-a2ae-8d5d5cc81173)


### 管理后台

![图片](https://github.com/user-attachments/assets/d4781a49-917b-4a1e-a0fc-6673825bd2ff)

## 使用方法

本程序兼容OpenAI API请求格式进行文档翻译，请输入接口地址，默认为https://api.openai.com （支持中转接口），再输入API Key，即可开始使用。

在线版无需注册即可体验，暂不提供会员注册服务。如果您需要完整的功能和更快的性能，请按照下方提示自行部署。

## 翻译效果

### 原文

![图片](https://github.com/user-attachments/assets/55959e59-3e28-4aa9-91d4-a936f1bb1fa7)


### 译文

![图片](https://github.com/user-attachments/assets/b06eb00e-7b9d-434b-ae8b-43b84afcbbac)


## 项目安装与配置文档

### 目录

- [前言](#前言)
- [环境要求](#环境要求)
- [克隆主仓库](#克隆主仓库)
- [更新子模块](#更新子模块)
- [修改 .env 文件](#修改-env-文件)
- [Docker Compose 配置](#docker-compose-配置)
- [构建与启动服务](#构建与启动服务)
- [访问应用](#访问应用)
- [常见问题](#常见问题)

### 前言

本项目由四个主要部分组成：`api`、`frontend`、`admin` 和主仓库。主仓库使用 Git 子模块的方式引用其他三个仓库。我们将使用 Docker Compose 来部署这些服务。

### 环境要求

在开始之前，请确保你的系统上安装了以下软件：

- [Docker](https://docs.docker.com/get-docker/) - 用于容器化应用。
- [Docker Compose](https://docs.docker.com/compose/install/) - 用于定义和运行多容器 Docker 应用。
- [Git](https://git-scm.com/) - 用于版本控制和代码管理。


# 使用 Docker 启动 ezwork-ai 服务

## 1. 直接启动服务（本地部署）

```bash
docker run -p 5555:5555 -p 5556:5556 -d --name ezwork-ai ehemart/ezwork-ai:1.0
#国内加速器
docker pull dockerpull.cn/ehewon/ezwork-ai:latest && docker tag dockerpull.cn/ehemart/ezwork-ai:1.0 ehewon/ezwork-ai:latest
docker run -p 5555:5555 -p 5556:5556 -d --name ehewon/ezwork-ai:latest
```

## 2. 针对有修改需求的，重新构建服务（服务器部署）

### 克隆主仓库

首先，克隆主仓库到本地，并更新子模块：

```bash
git clone https://github.com/EHEWON/ezwork-ai-doc-translation.git ezwork-ai-doc-translation
cd ezwork-ai-doc-translation
git checkout master
git submodule update --init --recursive
cd api
git checkout master
git pull
cd ../frontend
git checkout master
git pull
cd ../admin
git checkout master
git pull
cd ..
```

### 更改接口地址
##### 如部署到ip为19.91.9.31的服务器上，映射的端口为5555, 则接口地址为 http://19.91.9.31:5555
* frontend.env 
* admin.env
* api.env

### 重新构建镜像和服务

> `5555` 对应用户端和接口的端口，`5556` 对应管理后台的端口。如果需要更改前端端口，需要更改 `frontend.env` 和 `admin.env` 的接口对应的端口。

```bash
docker build -t ezwork-ai .
docker run -p 5555:5555 -p 5556:5556 -d --name ezwork-ai ezwork-ai
```

### 挂载文件存储目录和数据库目录
* 文件存储目录: /app/api/storage, 挂载的本地目录要有读写权限
* 数据库目录: /var/lib/mysql

```bash
docker build -t ezwork-ai .
docker run -p 5555:5555 -p 5556:5556 -v /ezwork/storage:/app/api/storage -v /ezwork/db:/var/lib/mysql -d --name ezwork-ai ezwork-ai
```


### 访问应用

Frontend: 访问 http://localhost:5555 来查看前端应用。

Backend: 访问 http://localhost:5556 来查看后台应用。
* 账户：admin@erui.com
* 密码：erui2024


### 常见问题
1. 如何停止服务？
要停止所有服务，可以运行：
```bash
docker stop ezwork-ai
```

#### 2. 如何查看日志？
要查看服务的日志，可以使用：
```bash
docker logs ezwork-ai
```

### 4. 如何访问数据库？
你可以通过 MySQL 客户端连接到数据库，使用以下连接信息：
```bash
docker exec -it ezwork-ai mysql -uroot -pezwork ezwork
```

## 其他系统的部署教程

- [CentOS 系统](https://github.com/EHEWON/ezwork-ai-doc-translation/blob/main/build/Centos.md) - 请查看此文件获取在 CentOS 系统上的部署步骤。
- [Ubuntu 系统](https://github.com/EHEWON/ezwork-ai-doc-translation/blob/main/build/Ubuntu.md) - 请查看此文件获取在 Ubuntu 系统上的部署步骤。
- [Macos 系统](https://github.com/EHEWON/ezwork-ai-doc-translation/blob/main/build/Macos.md) - 请查看此文件获取在 Macos 系统上的部署步骤。

## 微信交流群

![alt text](<52e5fe9b12636fba1e8683fb3efc668 (1).jpg>)


