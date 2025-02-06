CREATE DATABASE IF NOT EXISTS ezwork;
use ezwork;

CREATE TABLE IF NOT EXISTS customer(
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

CREATE TABLE IF NOT EXISTS send_code (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id int DEFAULT NULL COMMENT '用户id',
  send_type int NOT NULL COMMENT '类型。 1:通过邮箱修改密码',
  send_to varchar(100) NOT NULL COMMENT '接收消息的手机号或邮箱',
  code varchar(6) NOT NULL COMMENT '验证码',
  created_at datetime DEFAULT NULL COMMENT '创建时间',
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件短信发送记录';

CREATE TABLE IF NOT EXISTS user(
    id int not null AUTO_INCREMENT PRIMARY KEY,
    name varchar(255) COMMENT '用户名',
    password varchar(64) NOT NULL COMMENT '密码',
    email varchar(255) NOT NULL COMMENT '邮箱',
    deleted_flag enum('N','Y') DEFAULT 'N' COMMENT '是否删除',
    created_at datetime DEFAULT NULL COMMENT '创建时间',
    updated_at datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED COMMENT='后台管理用户';

insert into user(name,email,password,deleted_flag) values ('admin','admin@erui.com','$2y$10$bLvbeemLfu8cYBfKfLVOMeSFdvET8eHj3S.Jx7jWBDoR.oHmtIo3S','N');

CREATE TABLE IF NOT EXISTS `translate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `translate_no` varchar(32) DEFAULT NULL COMMENT '编号',
  `uuid` varchar(64) DEFAULT NULL COMMENT 'uuid编号',
  `customer_id` int(11) DEFAULT '0' COMMENT '用户id',
  `origin_filename` varchar(520) NOT NULL COMMENT '原文件路径',
  `origin_filepath` varchar(520) NOT NULL COMMENT '原文件名称',
  `target_filepath` varchar(520) NOT NULL COMMENT '目标文件路径',
  `status` enum('none','process','done','failed') DEFAULT 'none' COMMENT '状态',
  `start_at` datetime DEFAULT NULL COMMENT '翻译开始日期',
  `end_at` datetime DEFAULT NULL COMMENT '翻译结束日期',
  `deleted_flag` enum('N','Y') DEFAULT 'N' COMMENT '是否删除',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `origin_filesize` bigint(20) DEFAULT '0' COMMENT '原文文件大小。单位为字节',
  `target_filesize` bigint(20) DEFAULT '0' COMMENT '目标文件大小。单位为字节',
  `lang` varchar(32) DEFAULT '' COMMENT '目标语言',
  `model` varchar(64) DEFAULT '' COMMENT 'ai翻译模型',
  `prompt` varchar(1024) DEFAULT '' COMMENT 'ai翻译提示语',
  `api_url` varchar(255) DEFAULT '' COMMENT '接口地址',
  `api_key` varchar(255) DEFAULT '' COMMENT '接口key',
  `threads` int(11) DEFAULT '10' COMMENT '线程数',
  `failed_reason` text COMMENT '失败原因',
  `failed_count` int(11) DEFAULT '0' COMMENT '失败次数',
  `word_count` int(11) DEFAULT '0' COMMENT '字数',
  `backup_model` varchar(64) DEFAULT '' COMMENT '备用模型',
  `md5` varchar(32) DEFAULT NULL,
  `type` varchar(64) DEFAULT '' COMMENT '译文形式',
  `origin_lang` varchar(32) DEFAULT NULL COMMENT '起始语言',
  `process` float(5,2) DEFAULT '0.00' COMMENT '翻译进度',
  `doc2x_flag` enum('N','Y') DEFAULT 'N',
  `doc2x_secret_key` varchar(32) DEFAULT NULL,
  `prompt_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '提示词ID',
  `comparison_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '对照表ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED COMMENT='翻译文件';


CREATE TABLE IF NOT EXISTS setting(
    id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识符',
    alias varchar(64) DEFAULT NULL COMMENT '配置字段别名(保证唯一性)',
    `group` varchar(32) COMMENT '分组',
    value text COMMENT '配置字段值',
    serialized tinyint(1) DEFAULT '0' COMMENT '是否序列化value',
    created_at datetime NOT NULL COMMENT '创建时间',
    updated_at datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    deleted_flag enum('N','Y') DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='配置信息';



CREATE TABLE IF NOT EXISTS  `translate_logs`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `md5_key` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `source` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '原内容',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `target_lang` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'zh' COMMENT '翻译后的语言',
  `model` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '翻译模型 MINIMAX:MiniMax,',
  `created_at` datetime(0) NOT NULL COMMENT '创建时间',
  `prompt` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'ai翻译提示语',
  `api_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '接口地址',
  `api_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '接口key',
  `word_count` int(11) NULL DEFAULT 0 COMMENT '字数',
  `backup_model` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备用模型',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `md5_key`(`md5_key`) USING BTREE,
  INDEX `chat_model`(`model`) USING BTREE
) ENGINE = InnoDB  CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '翻译日志' ROW_FORMAT = Dynamic;

INSERT INTO setting(id,alias,value,serialized,created_at,updated_at,deleted_flag,`group`) VALUES (1,'notice_setting','[\"1\"]',1,'2024-06-25 01:39:39',NULL,'N',NULL),(2,'api_url','https://newapi.erui.com',0,'2024-07-26 05:26:21','2024-07-26 13:26:21','N','api_setting'),(3,'api_key','',0,'2024-07-26 05:26:21','2024-07-26 13:26:21','N','api_setting'),(4,'models','gpt-3.5-turbo-0125,gpt-4o,deepseek-chat,test',0,'2024-07-26 05:26:21','2024-07-26 13:26:21','N','api_setting'),(5,'default_model','gpt-4o',0,'2024-07-26 05:26:21','2024-07-26 13:26:21','N','api_setting'),(6,'default_backup','deepseek-chat',0,'2024-07-26 05:26:21','2024-07-26 13:26:21','N','api_setting'),(7,'prompt','你是一个文档翻译助手，请将以下文本、单词或短语直接翻译成{target_lang}，不返回原文本。如果文本中包含{target_lang}文本、特殊名词（比如邮箱、品牌名、单位名词如mm、px、℃等）、无法翻译等特殊情况，请直接返回原文而无需解释原因。遇到无法翻译的文本直接返回原内容。保留多余空格。',0,'2024-09-02 05:55:30','2024-09-02 13:55:30','N','other_setting'),(8,'threads','10',0,'2024-09-02 05:55:30','2024-09-02 13:55:30','N','other_setting'),(9,'email_limit','',0,'2024-09-02 05:55:31','2024-09-02 13:55:31','N','other_setting');

