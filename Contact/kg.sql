/*
 Navicat Premium Data Transfer

 Source Server         : Eriak
 Source Server Type    : MySQL
 Source Server Version : 50736
 Source Host           : localhost:3306
 Source Schema         : kg

 Target Server Type    : MySQL
 Target Server Version : 50736
 File Encoding         : 65001

 Date: 16/05/2022 16:58:22
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for kg_category
-- ----------------------------
DROP TABLE IF EXISTS `kg_category`;
CREATE TABLE `kg_category`  (
  `CategoryNodeId` int(11) NOT NULL AUTO_INCREMENT,
  `CategoryNodeName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `CategoryNodeCode` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `SystemCode` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `CategoryId` bigint(11) NOT NULL,
  `ParentId` int(11) NULL DEFAULT NULL,
  `ParentCode` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `TreeLevel` int(11) NULL DEFAULT NULL,
  `IsLeaf` int(11) NOT NULL DEFAULT 1,
  `Status` int(11) NULL DEFAULT NULL,
  `FileUuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '附件uuid',
  `FileName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '节点来源附件',
  `CreateUser` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `CreateTime` datetime NULL DEFAULT NULL,
  `UpdateUser` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `UpdateTime` datetime NULL DEFAULT NULL,
  `Color` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`CategoryNodeId`) USING BTREE,
  INDEX `categoryId`(`CategoryId`) USING BTREE,
  INDEX `parentId`(`ParentId`) USING BTREE,
  INDEX `parentCode`(`ParentCode`) USING BTREE,
  INDEX `categoryCode`(`CategoryNodeCode`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of kg_category
-- ----------------------------

-- ----------------------------
-- Table structure for kg_domain
-- ----------------------------
DROP TABLE IF EXISTS `kg_domain`;
CREATE TABLE `kg_domain`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `nodecount` int(11) NOT NULL DEFAULT 0,
  `shipcount` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `createuser` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `commend` int(11) NULL DEFAULT 0 COMMENT '推荐',
  `type` int(11) NULL DEFAULT NULL COMMENT '0=手动创建，1=三元组导入，2=excel导入，3=er图构建',
  `pub` int(11) NOT NULL DEFAULT 0,
  `feedback_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 496 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of kg_domain
-- ----------------------------
INSERT INTO `kg_domain` VALUES (483, '高等数学', 0, 0, 0, 'tc', 0, 0, 0, NULL);
INSERT INTO `kg_domain` VALUES (484, 'test@1', 0, 0, 0, 'tc', 0, 0, 0, NULL);
INSERT INTO `kg_domain` VALUES (485, 'test@1', 0, 0, 0, 'tc', 0, 0, 0, NULL);
INSERT INTO `kg_domain` VALUES (486, 'test1@1', 0, 0, 0, 'tc', 0, 0, 0, NULL);
INSERT INTO `kg_domain` VALUES (487, 'test@1', 0, 0, 0, 'tc', 0, 0, 0, NULL);
INSERT INTO `kg_domain` VALUES (488, '高等数学', 0, 0, 1, 'tc', 0, 2, 0, NULL);
INSERT INTO `kg_domain` VALUES (489, '高等数学@1', 0, 0, 1, 'tc', 0, 2, 1, NULL);
INSERT INTO `kg_domain` VALUES (490, 'teat@1', 0, 0, 1, 'tc', 0, 0, 0, NULL);
INSERT INTO `kg_domain` VALUES (491, 'IT项目管理@1', 0, 0, 0, 'tc', 0, 0, 0, NULL);
INSERT INTO `kg_domain` VALUES (492, 'IT项目管理@1', 0, 0, 1, 'tc', 0, 0, 0, NULL);
INSERT INTO `kg_domain` VALUES (493, 'Java基础@1', 0, 0, 0, 'tc', 0, 0, 0, NULL);
INSERT INTO `kg_domain` VALUES (494, 'Java基础@1', 0, 0, 0, 'tc', 0, 2, 0, NULL);
INSERT INTO `kg_domain` VALUES (495, 'Java基础@1', 0, 0, 1, 'tc', 0, 2, 0, NULL);

-- ----------------------------
-- Table structure for kg_feedback
-- ----------------------------
DROP TABLE IF EXISTS `kg_feedback`;
CREATE TABLE `kg_feedback`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) NOT NULL,
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'con',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_active` int(11) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kg_feedback
-- ----------------------------
INSERT INTO `kg_feedback` VALUES (1, 489, '某个节点错误', '2022-05-16 16:36:42', 0);
INSERT INTO `kg_feedback` VALUES (2, 489, '测试1下', '2022-05-16 16:57:15', 0);

-- ----------------------------
-- Table structure for kg_graph_link
-- ----------------------------
DROP TABLE IF EXISTS `kg_graph_link`;
CREATE TABLE `kg_graph_link`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `to` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `domainId` int(11) NULL DEFAULT NULL COMMENT '领域id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of kg_graph_link
-- ----------------------------

-- ----------------------------
-- Table structure for kg_graph_node
-- ----------------------------
DROP TABLE IF EXISTS `kg_graph_node`;
CREATE TABLE `kg_graph_node`  (
  `nodeId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `nodeKey` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '节点唯一标识',
  `tableId` int(11) NULL DEFAULT NULL COMMENT '数据表id',
  `nodeName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '节点名称',
  `type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '节点类型',
  `left` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '节点左位置',
  `top` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '节点右位置',
  `ico` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '节点图标',
  `state` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '节点状态',
  `viewOnly` int(11) NULL DEFAULT NULL COMMENT '是否可以拖动，1=是，0=否',
  `sourceId` int(11) NULL DEFAULT NULL COMMENT '数据源id',
  `domainId` int(11) NULL DEFAULT NULL COMMENT '领域id',
  `startNode` int(11) NULL DEFAULT NULL COMMENT '是否是起点',
  PRIMARY KEY (`nodeId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of kg_graph_node
-- ----------------------------

-- ----------------------------
-- Table structure for kg_graph_node_map
-- ----------------------------
DROP TABLE IF EXISTS `kg_graph_node_map`;
CREATE TABLE `kg_graph_node_map`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `columnId` int(11) NULL DEFAULT NULL COMMENT '列id',
  `ico` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列图标',
  `isPrimary` int(11) NULL DEFAULT NULL COMMENT '是否主键',
  `itemId` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '数据列key',
  `itemCode` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '原始数据列字段',
  `itemName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列别名',
  `itemType` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字段类型',
  `nodeId` bigint(20) NULL DEFAULT NULL COMMENT '节点id',
  `domainId` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of kg_graph_node_map
-- ----------------------------

-- ----------------------------
-- Table structure for kg_nodedetail
-- ----------------------------
DROP TABLE IF EXISTS `kg_nodedetail`;
CREATE TABLE `kg_nodedetail`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '领域关系主键',
  `DomainId` int(11) NULL DEFAULT NULL COMMENT '知识图谱领域主键',
  `NodeId` int(11) NULL DEFAULT NULL COMMENT '关系定义主键',
  `Status` int(11) NULL DEFAULT 1,
  `Content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `CreateUser` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `CreateTime` datetime NULL DEFAULT NULL,
  `ModifyUser` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ModifyTime` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `domainid`(`DomainId`) USING BTREE,
  INDEX `nodeid`(`NodeId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of kg_nodedetail
-- ----------------------------
INSERT INTO `kg_nodedetail` VALUES (31, 478, 1304, 1, '<p>地址：<a href=\"https://www.baidu.com\" target=\"_blank\">百度</a></p>', 'tc', '2022-05-15 04:03:28', NULL, NULL);
INSERT INTO `kg_nodedetail` VALUES (32, 489, 23, 1, '<p>描述</p>', 'tc', '2022-05-15 08:46:50', NULL, NULL);

-- ----------------------------
-- Table structure for kg_nodedetail_file
-- ----------------------------
DROP TABLE IF EXISTS `kg_nodedetail_file`;
CREATE TABLE `kg_nodedetail_file`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '领域关系主键',
  `DomainId` int(11) NULL DEFAULT NULL COMMENT '知识图谱领域主键',
  `NodeId` int(11) NULL DEFAULT NULL COMMENT '关系定义主键',
  `FileName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '若是本地上传则为文件名称，若是网络链接则保存为链接',
  `ImageType` int(11) NULL DEFAULT 0 COMMENT '0=本地上传,1=网络链接',
  `Status` int(11) NULL DEFAULT 1,
  `CreateUser` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `CreateTime` datetime NULL DEFAULT NULL,
  `ModifyUser` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ModifyTime` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `domainid`(`DomainId`) USING BTREE,
  INDEX `nodeid`(`NodeId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of kg_nodedetail_file
-- ----------------------------

-- ----------------------------
-- Table structure for kg_user
-- ----------------------------
DROP TABLE IF EXISTS `kg_user`;
CREATE TABLE `kg_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of kg_user
-- ----------------------------
INSERT INTO `kg_user` VALUES (1, 'admin', 'admin', '管理员', 'admin@gmail.com', '123456789', '中国', '2022-01-22 21:10:27', ' ', 'ROLE_ADMIN');
INSERT INTO `kg_user` VALUES (2, '王子君', NULL, 'arika', '10001010@qq.com', '10086', '郑州大学信工院', '2022-05-16 16:24:26', NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
