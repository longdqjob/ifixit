/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : ifixit

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2017-08-26 15:11:00
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for app_user
-- ----------------------------
DROP TABLE IF EXISTS `app_user`;
CREATE TABLE `app_user` (
`id`  bigint(20) NOT NULL AUTO_INCREMENT ,
`account_expired`  bit(1) NOT NULL ,
`account_locked`  bit(1) NOT NULL ,
`address`  varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
`city`  varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
`country`  varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
`postal_code`  varchar(15) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
`province`  varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
`credentials_expired`  bit(1) NOT NULL ,
`email`  varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
`account_enabled`  bit(1) NULL DEFAULT NULL ,
`first_name`  varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
`last_name`  varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
`password`  varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
`password_hint`  varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
`phone_number`  varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
`username`  varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
`version`  int(11) NULL DEFAULT NULL ,
`website`  varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
PRIMARY KEY (`id`),
UNIQUE INDEX `UK_1j9d9a06i600gd43uu3km82jw` (`email`) USING BTREE ,
UNIQUE INDEX `UK_3k4cplvh82srueuttfkwnylq0` (`username`) USING BTREE 
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=latin1 COLLATE=latin1_swedish_ci
AUTO_INCREMENT=1

;

-- ----------------------------
-- Records of app_user
-- ----------------------------
BEGIN;
INSERT INTO `app_user` VALUES ('-3', '\0', '\0', '', 'Denver', 'US', '80210', 'CO', '\0', 'two_roles_user@appfuse.org', '', 'Two Roles', 'User', '$2a$10$bH/ssqW8OhkTlIso9/yakubYODUOmh.6m5HEJvcBq3t3VdBh7ebqO', 'Not a female kitty.', '', 'two_roles_user', '1', 'http://raibledesigns.com'), ('-2', '\0', '\0', '', 'Denver', 'US', '80210', 'CO', '\0', 'matt@raibledesigns.com', '', 'Matt', 'Raible', '$2a$10$bH/ssqW8OhkTlIso9/yakubYODUOmh.6m5HEJvcBq3t3VdBh7ebqO', 'Not a female kitty.', '', 'admin', '1', 'http://raibledesigns.com'), ('-1', '\0', '\0', '', 'Denver', 'US', '80210', 'CO', '\0', 'matt_raible@yahoo.com', '', 'Tomcat', 'User', '$2a$10$CnQVJ9bsWBjMpeSKrrdDEeuIptZxXrwtI6CZ/OgtNxhIgpKxXeT9y', 'A male kitty.', '', 'user', '1', 'http://tomcat.apache.org');
COMMIT;

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
`id`  bigint(20) NOT NULL AUTO_INCREMENT ,
`description`  varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
`name`  varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=latin1 COLLATE=latin1_swedish_ci
AUTO_INCREMENT=1

;

-- ----------------------------
-- Records of role
-- ----------------------------
BEGIN;
INSERT INTO `role` VALUES ('-2', 'Default role for all Users', 'ROLE_USER'), ('-1', 'Administrator role (can edit Users)', 'ROLE_ADMIN');
COMMIT;

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
`user_id`  bigint(20) NOT NULL ,
`role_id`  bigint(20) NOT NULL ,
PRIMARY KEY (`user_id`, `role_id`),
FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
INDEX `FK_it77eq964jhfqtu54081ebtio` (`role_id`) USING BTREE 
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=latin1 COLLATE=latin1_swedish_ci

;

-- ----------------------------
-- Records of user_role
-- ----------------------------
BEGIN;
INSERT INTO `user_role` VALUES ('-3', '-2'), ('-3', '-1'), ('-2', '-1'), ('-1', '-2');
COMMIT;

-- ----------------------------
-- Auto increment value for app_user
-- ----------------------------
ALTER TABLE `app_user` AUTO_INCREMENT=1;

-- ----------------------------
-- Auto increment value for role
-- ----------------------------
ALTER TABLE `role` AUTO_INCREMENT=1;
