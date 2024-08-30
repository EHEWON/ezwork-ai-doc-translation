CREATE DATABASE IF NOT EXISTS ezwork;
use ezwork;

CREATE TABLE customer(
    id int not null AUTO_INCREMENT PRIMARY KEY,
    customer_no varchar(32) COMMENT '编号',
    phone varchar(11) COMMENT '手机号',
    name varchar(255) COMMENT '用户名',
    password varchar(64) NOT NULL COMMENT '密码',
    email varchar(255) NOT NULL COMMENT '邮箱',
    level enum('common','vip') DEFAULT 'common' COMMENT '会员等级',
    status enum('enabled','disabled') DEFAULT 'enabled' COMMENT '状态',
    storage bigint DEFAULT 0 COMMENT '存储空间，单位为字节',
    deleted_flag enum('N','Y') DEFAULT 'N' COMMENT '是否删除',
    created_at datetime DEFAULT NULL COMMENT '创建时间',
    updated_at datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED COMMENT='用户';

CREATE TABLE send_code (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id int DEFAULT NULL COMMENT '用户id',
  send_type int NOT NULL COMMENT '类型。 1:通过邮箱修改密码',
  send_to varchar(100) NOT NULL COMMENT '接收消息的手机号或邮箱',
  code varchar(6) NOT NULL COMMENT '验证码',
  created_at datetime DEFAULT NULL COMMENT '创建时间',
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件短信发送记录';

CREATE TABLE user(
    id int not null AUTO_INCREMENT PRIMARY KEY,
    name varchar(255) COMMENT '用户名',
    password varchar(64) NOT NULL COMMENT '密码',
    email varchar(255) NOT NULL COMMENT '邮箱',
    deleted_flag enum('N','Y') DEFAULT 'N' COMMENT '是否删除',
    created_at datetime DEFAULT NULL COMMENT '创建时间',
    updated_at datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED COMMENT='后台管理用户';

insert into user(name,email,password,deleted_flag) values ('admin','admin@erui.com','$2y$10$bLvbeemLfu8cYBfKfLVOMeSFdvET8eHj3S.Jx7jWBDoR.oHmtIo3S','N');

CREATE TABLE translate(
    id int not null AUTO_INCREMENT PRIMARY KEY,
    translate_no varchar(32) COMMENT '编号',
    uuid varchar(64) COMMENT 'uuid编号',
    customer_id int DEFAULT 0 COMMENT '用户id',
    origin_filename varchar(255) NOT NULL COMMENT '原文件名称',
    origin_filepath varchar(255) NOT NULL COMMENT '原文件路径',
    origin_filesize bigint DEFAULT 0 COMMENT '原文文件大小。单位为字节',
    target_filepath varchar(255) DEFAULT '' COMMENT '目标文件',
    target_filesize bigint DEFAULT 0 COMMENT '目标文件大小。单位为字节',
    status enum('none','process','done','failed') DEFAULT 'none' COMMENT '状态',
    start_at datetime DEFAULT NULL COMMENT '翻译开始日期',
    end_at datetime DEFAULT NULL COMMENT '翻译结束日期',
    deleted_flag enum('N','Y') DEFAULT 'N' COMMENT '是否删除',
    created_at datetime DEFAULT NULL COMMENT '创建时间',
    updated_at datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED COMMENT='翻译文件';

 CREATE TABLE translate (
  id int NOT NULL AUTO_INCREMENT,
  translate_no varchar(32) DEFAULT NULL COMMENT '编号',
  customer_id int DEFAULT '0' COMMENT '用户id',
  origin_filename varchar(255) NOT NULL COMMENT '原文件名称',
  origin_filepath varchar(255) NOT NULL COMMENT '原文件路径',
  target_filepath varchar(255) DEFAULT '' COMMENT '目标文件',
  status enum('none','process','done','failed') DEFAULT 'none' COMMENT '状态',
  start_at datetime DEFAULT NULL COMMENT '翻译开始日期',
  end_at datetime DEFAULT NULL,
  deleted_flag enum('N','Y') DEFAULT 'N' COMMENT '是否删除',
  created_at datetime DEFAULT NULL COMMENT '创建时间',
  updated_at datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  uuid varchar(64) DEFAULT NULL COMMENT 'uuid编号',
  origin_filesize bigint DEFAULT '0' COMMENT '原文文件大小。单位为字节',
  target_filesize bigint DEFAULT '0' COMMENT '目标文件大小。单位为字节',
  lang varchar(32) DEFAULT '' COMMENT '目标语言',
  model varchar(64) DEFAULT '' COMMENT 'ai翻译模型',
  prompt varchar(1024) DEFAULT '' COMMENT 'ai翻译提示语',
  api_url varchar(255) DEFAULT '' COMMENT '接口地址',
  api_key varchar(255) DEFAULT '' COMMENT '接口key',
  threads int DEFAULT '10' COMMENT '线程数',
  failed_reason text COMMENT '失败原因',
  failed_count int DEFAULT '0' COMMENT '失败次数',
  word_count float DEFAULT '0' COMMENT '字数',
  backup_model varchar(64) DEFAULT '' COMMENT '备用模型',
  type varchar(64) DEFAULT '' COMMENT '译文形式',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED COMMENT='翻译文件';


CREATE TABLE setting(
    id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符',
    alias varchar(64) DEFAULT NULL COMMENT '配置字段别名(保证唯一性)',
    `group` varchar(32) COMMENT '分组',
    value text COMMENT '配置字段值',
    serialized tinyint(1) DEFAULT '0' COMMENT '是否序列化value',
    created_at datetime NOT NULL COMMENT '创建时间',
    updated_at datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    deleted_flag enum('N','Y') DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='配置信息';
