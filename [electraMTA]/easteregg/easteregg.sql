/*
Navicat MySQL Data Transfer

Source Server         : furkan123
Source Server Version : 80017
Source Host           : localhost:3306
Source Database       : project-system

Target Server Type    : MYSQL
Target Server Version : 80017
File Encoding         : 65001

Date: 2021-11-30 11:44:56
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `eastereggs`
-- ----------------------------
DROP TABLE IF EXISTS `eastereggs`;
CREATE TABLE `eastereggs` (
  `id` int(11) NOT NULL,
  `x` double NOT NULL,
  `y` double NOT NULL,
  `z` double NOT NULL,
  `interior` int(11) NOT NULL,
  `dim` int(11) NOT NULL,
  `olusturan` text NOT NULL,
  `state` text NOT NULL,
  `date` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of eastereggs
-- ----------------------------
