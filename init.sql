/*
 Navicat Premium Data Transfer

 Source Server         : 预生产
 Source Server Type    : MySQL
 Source Server Version : 50739
 Source Host           : 182.92.170.246:3306
 Source Schema         : erui_ezwork

 Target Server Type    : MySQL
 Target Server Version : 50739
 File Encoding         : 65001

 Date: 18/02/2025 13:42:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cache
-- ----------------------------
DROP TABLE IF EXISTS `cache`;
CREATE TABLE `cache`  (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cache_locks
-- ----------------------------
DROP TABLE IF EXISTS `cache_locks`;
CREATE TABLE `cache_locks`  (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for comparison
-- ----------------------------
DROP TABLE IF EXISTS `comparison`;
CREATE TABLE `comparison`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '唯一标识符',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `origin_lang` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '源语言',
  `target_lang` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '对照语种',
  `share_flag` enum('N','Y') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'N' COMMENT '分享状态。 N:不分享 Y:分享',
  `added_count` int(11) NOT NULL DEFAULT 0 COMMENT '被添加的次数',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '术语，源1,目标1;源2,目标2',
  `customer_id` int(11) NOT NULL DEFAULT 0 COMMENT '创建用户id',
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  `deleted_flag` enum('N','Y') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'N',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for comparison_fav
-- ----------------------------
DROP TABLE IF EXISTS `comparison_fav`;
CREATE TABLE `comparison_fav`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '唯一标识符',
  `comparison_id` int(11) NOT NULL COMMENT '对照表id',
  `customer_id` int(11) NOT NULL COMMENT '用户id',
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for customer
-- ----------------------------
DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_no` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编号',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '邮箱',
  `level` enum('common','vip') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'common' COMMENT '会员等级',
  `status` enum('enabled','disabled') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'enabled' COMMENT '状态',
  `deleted_flag` enum('N','Y') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '是否删除',
  `created_at` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `storage` bigint(20) NULL DEFAULT 0 COMMENT '存储空间，单位为字节',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户' ROW_FORMAT = COMPRESSED;

-- ----------------------------
-- Table structure for failed_jobs
-- ----------------------------
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `failed_jobs_uuid_unique`(`uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for job_batches
-- ----------------------------
DROP TABLE IF EXISTS `job_batches`;
CREATE TABLE `job_batches`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `cancelled_at` int(11) NULL DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jobs
-- ----------------------------
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED NULL DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `jobs_queue_index`(`queue`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for migrations
-- ----------------------------
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for password_reset_tokens
-- ----------------------------
DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens`  (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`email`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for prompt
-- ----------------------------
DROP TABLE IF EXISTS `prompt`;
CREATE TABLE `prompt`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '唯一标识符',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `share_flag` enum('N','Y') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'N' COMMENT '分享状态。 N:不分享 Y:分享',
  `added_count` int(11) NOT NULL DEFAULT 0 COMMENT '被添加的次数',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '提示语内容',
  `customer_id` int(11) NOT NULL DEFAULT 0 COMMENT '创建用户id',
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  `deleted_flag` enum('N','Y') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'N',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for prompt_fav
-- ----------------------------
DROP TABLE IF EXISTS `prompt_fav`;
CREATE TABLE `prompt_fav`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '唯一标识符',
  `prompt_id` int(11) NOT NULL COMMENT '对照表id',
  `customer_id` int(11) NOT NULL COMMENT '用户id',
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for send_code
-- ----------------------------
DROP TABLE IF EXISTS `send_code`;
CREATE TABLE `send_code`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `send_type` int(11) NOT NULL COMMENT '类型。 1:通过邮箱修改密码',
  `send_to` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '接收消息的手机号或邮箱',
  `code` varchar(6) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '验证码',
  `created_at` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '邮件短信发送记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sessions
-- ----------------------------
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sessions_user_id_index`(`user_id`) USING BTREE,
  INDEX `sessions_last_activity_index`(`last_activity`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for setting
-- ----------------------------
DROP TABLE IF EXISTS `setting`;
CREATE TABLE `setting`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一标识符',
  `alias` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '配置字段别名(保证唯一性)',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配置字段值',
  `serialized` tinyint(1) NULL DEFAULT 0 COMMENT '是否序列化value',
  `created_at` datetime(0) NOT NULL COMMENT '创建时间',
  `updated_at` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `deleted_flag` enum('N','Y') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N',
  `group` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分组',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '配置信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for translate
-- ----------------------------
DROP TABLE IF EXISTS `translate`;
CREATE TABLE `translate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `translate_no` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编号',
  `uuid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'uuid编号',
  `customer_id` int(11) NULL DEFAULT 0 COMMENT '用户id',
  `rand_user_id` varchar(64) DEFAULT NULL COMMENT '随机用户ID',
  `origin_filename` varchar(520) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '原文件路径',
  `origin_filepath` varchar(520) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '原文件名称',
  `target_filepath` varchar(520) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '目标文件路径',
  `status` enum('none','process','done','failed') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'none' COMMENT '状态',
  `start_at` datetime(0) NULL DEFAULT NULL COMMENT '翻译开始日期',
  `end_at` datetime(0) NULL DEFAULT NULL COMMENT '翻译结束日期',
  `deleted_flag` enum('N','Y') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '是否删除',
  `created_at` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `origin_filesize` bigint(20) NULL DEFAULT 0 COMMENT '原文文件大小。单位为字节',
  `target_filesize` bigint(20) NULL DEFAULT 0 COMMENT '目标文件大小。单位为字节',
  `lang` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '目标语言',
  `model` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'ai翻译模型',
  `prompt` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'ai翻译提示语',
  `api_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '接口地址',
  `api_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '接口key',
  `threads` int(11) NULL DEFAULT 10 COMMENT '线程数',
  `failed_reason` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '失败原因',
  `failed_count` int(11) NULL DEFAULT 0 COMMENT '失败次数',
  `word_count` int(11) NULL DEFAULT 0 COMMENT '字数',
  `backup_model` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备用模型',
  `md5` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '译文形式',
  `origin_lang` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '起始语言',
  `process` float(5, 2) NULL DEFAULT 0.00 COMMENT '翻译进度',
  `doc2x_flag` enum('N','Y') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N',
  `doc2x_secret_key` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `prompt_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '提示词ID',
  `comparison_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '对照表ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1323 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '翻译文件' ROW_FORMAT = COMPRESSED;

-- ----------------------------
-- Table structure for translate_logs
-- ----------------------------
DROP TABLE IF EXISTS `translate_logs`;
CREATE TABLE `translate_logs`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 621 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '翻译日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '邮箱',
  `deleted_flag` enum('N','Y') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '是否删除',
  `created_at` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '后台管理用户' ROW_FORMAT = COMPRESSED;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp(0) NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT NULL,
  `updated_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `users_email_unique`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
insert into user(name,email,password,deleted_flag) values ('admin','admin@erui.com','$2y$10$bLvbeemLfu8cYBfKfLVOMeSFdvET8eHj3S.Jx7jWBDoR.oHmtIo3S','N');
INSERT INTO setting(id,alias,value,serialized,created_at,updated_at,deleted_flag,`group`) VALUES (1,'notice_setting','[\"1\"]',1,'2024-06-25 01:39:39',NULL,'N',NULL),(2,'api_url','',0,'2024-07-26 05:26:21','2024-07-26 13:26:21','N','api_setting'),(3,'api_key','',0,'2024-07-26 05:26:21','2024-07-26 13:26:21','N','api_setting'),(4,'models','gpt-3.5-turbo-0125,gpt-4o,deepseek-chat,test',0,'2024-07-26 05:26:21','2024-07-26 13:26:21','N','api_setting'),(5,'default_model','gpt-4o',0,'2024-07-26 05:26:21','2024-07-26 13:26:21','N','api_setting'),(6,'default_backup','deepseek-chat',0,'2024-07-26 05:26:21','2024-07-26 13:26:21','N','api_setting'),(7,'prompt','你是一个文档翻译助手，请将以下文本、单词或短语直接翻译成{target_lang}，不返回原文本。如果文本中包含{target_lang}文本、特殊名词（比如邮箱、品牌名、单位名词如mm、px、℃等）、无法翻译等特殊情况，请直接返回原文而无需解释原因。遇到无法翻译的文本直接返回原内容。保留多余空格。',0,'2024-09-02 05:55:30','2024-09-02 13:55:30','N','other_setting'),(8,'threads','10',0,'2024-09-02 05:55:30','2024-09-02 13:55:30','N','other_setting'),(9,'email_limit','',0,'2024-09-02 05:55:31','2024-09-02 13:55:31','N','other_setting'),(10,'version','community',0,'2025-02-18 01:57:39',NULL,'N','site_setting');