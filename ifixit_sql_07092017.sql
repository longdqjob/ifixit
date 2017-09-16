/*
SQLyog Ultimate v11.3 (64 bit)
MySQL - 5.6.16 : Database - ifixit
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `app_user` */

DROP TABLE IF EXISTS `app_user`;

CREATE TABLE `app_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_expired` bit(1) NOT NULL,
  `account_locked` bit(1) NOT NULL,
  `address` varchar(150) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `postal_code` varchar(15) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `credentials_expired` bit(1) NOT NULL,
  `email` varchar(255) NOT NULL,
  `account_enabled` bit(1) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `password_hint` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `version` int(11) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_1j9d9a06i600gd43uu3km82jw` (`email`),
  UNIQUE KEY `UK_3k4cplvh82srueuttfkwnylq0` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `app_user` */

insert  into `app_user`(`id`,`account_expired`,`account_locked`,`address`,`city`,`country`,`postal_code`,`province`,`credentials_expired`,`email`,`account_enabled`,`first_name`,`last_name`,`password`,`password_hint`,`phone_number`,`username`,`version`,`website`) values (-3,'\0','\0','','Denver','US','80210','CO','\0','two_roles_user@appfuse.org','','Two Roles','User','$2a$10$bH/ssqW8OhkTlIso9/yakubYODUOmh.6m5HEJvcBq3t3VdBh7ebqO','Not a female kitty.','','two_roles_user',1,'http://raibledesigns.com'),(-2,'\0','\0','','Denver','US','80210','CO','\0','matt@raibledesigns.com','','Matt','Raible','$2a$10$bH/ssqW8OhkTlIso9/yakubYODUOmh.6m5HEJvcBq3t3VdBh7ebqO','Not a female kitty.','','admin',1,'http://raibledesigns.com'),(-1,'\0','\0','','Denver','US','80210','CO','\0','matt_raible@yahoo.com','','Tomcat','User','$2a$10$CnQVJ9bsWBjMpeSKrrdDEeuIptZxXrwtI6CZ/OgtNxhIgpKxXeT9y','A male kitty.','','user',1,'http://tomcat.apache.org'),(1,'\0','\0','','Denver','US','80210','CO','\0','thuyetlv@yahoo.com','','Tomcat','User','$2a$10$bH/ssqW8OhkTlIso9/yakubYODUOmh.6m5HEJvcBq3t3VdBh7ebqO','A male kitty.','','thuyetlv',1,'http://tomcat.apache.org');

/*Table structure for table `company` */

DROP TABLE IF EXISTS `company`;

CREATE TABLE `company` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `completeCode` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_tqjljx2eskllwljnhk54ww02x` (`parent_id`),
  CONSTRAINT `FK_tqjljx2eskllwljnhk54ww02x` FOREIGN KEY (`parent_id`) REFERENCES `company` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

/*Data for the table `company` */

insert  into `company`(`id`,`code`,`completeCode`,`description`,`name`,`state`,`parent_id`) values (1,'01','01','VNPT - Technology','VNPT - Technology',NULL,NULL),(3,'001','01.001','VNPTTech - SSDC','SSDC',NULL,1),(4,'002','01.002','VNPTtech - Vivas','Vivas',NULL,1),(5,'001','01.001.001','Vnpttech -ssdc -nms','NMS',NULL,3),(6,'003','01.003','TTCN','TTCN',NULL,1),(7,'002','01.001.002','ERP','ERP',NULL,3);

/*Table structure for table `group_engineer` */

DROP TABLE IF EXISTS `group_engineer`;

CREATE TABLE `group_engineer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `complete_code` varchar(255) DEFAULT NULL,
  `cost` float DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_b3m8bdx1hl1i4bmcwmvahe6a0` (`parent_id`),
  CONSTRAINT `FK_b3m8bdx1hl1i4bmcwmvahe6a0` FOREIGN KEY (`parent_id`) REFERENCES `group_engineer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

/*Data for the table `group_engineer` */

insert  into `group_engineer`(`id`,`code`,`complete_code`,`cost`,`description`,`name`,`parent_id`) values (1,'ENG','ENG',10,'ENG - Engineer','Engineering',NULL),(2,'MAN','MAN',20,'MAN - Maintaince','Maintaince',NULL),(3,'MEC','MAN.MEC',30,'MANMEC - Mechanic Engineer','Mechanic Engineer',2),(4,'ELE','MAN.ELE',40,'MANELE - Electronic Engineer','Electronic Engineer',2),(5,'RP','RP',50,'RP - Repair','Repair',NULL),(6,'PRD','PRD',60,'PRD - Production','Production',NULL);

/*Table structure for table `item_type` */

DROP TABLE IF EXISTS `item_type`;

CREATE TABLE `item_type` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `specification` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(5) DEFAULT NULL,
  `complete_code` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `item_type` */

insert  into `item_type`(`id`,`code`,`name`,`specification`,`parent_id`,`complete_code`) values (1,'AA','AA NAME','{\"01\":\"dfgsdf\",\"02\":\"gfnh\",\"06\":\"6ujj\"}',NULL,'AA');

/*Table structure for table `machine` */

DROP TABLE IF EXISTS `machine`;

CREATE TABLE `machine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `completeCode` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `item_type_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `since` datetime DEFAULT NULL,
  `specification` varchar(255) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `machine_type_id` int(11) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_lc1d15hr6qyxjhb6sdgstgde` (`company_id`),
  KEY `FK_km41i0quj879chahjx4fr38g9` (`machine_type_id`),
  KEY `FK_8tivi7uhn7ujuio04or4ig47a` (`parent_id`),
  CONSTRAINT `FK_8tivi7uhn7ujuio04or4ig47a` FOREIGN KEY (`parent_id`) REFERENCES `machine` (`id`),
  CONSTRAINT `FK_km41i0quj879chahjx4fr38g9` FOREIGN KEY (`machine_type_id`) REFERENCES `machine_type` (`id`),
  CONSTRAINT `FK_lc1d15hr6qyxjhb6sdgstgde` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `machine` */

insert  into `machine`(`id`,`code`,`completeCode`,`description`,`item_type_id`,`name`,`note`,`since`,`specification`,`company_id`,`machine_type_id`,`parent_id`) values (1,'DT','DT.DT','',NULL,'Dien thoai','','2017-09-12 00:00:00','{\"01\":{\"label\":\"\",\"value\":\"20g\"},\"02\":{\"label\":\"\",\"value\":\"23x45\"}}',1,1,1);

/*Table structure for table `machine_type` */

DROP TABLE IF EXISTS `machine_type`;

CREATE TABLE `machine_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `specification` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `machine_type` */

insert  into `machine_type`(`id`,`code`,`description`,`name`,`note`,`specification`) values (1,'DT',NULL,'Dien thoai','Dien thoai chung chung','{\"01\":\"tr\\u1ecdng l\\u01b0\\u1ee3ng\",\"02\":\"k\\u00edch c\\u1ee1\"}');

/*Table structure for table `man_hours` */

DROP TABLE IF EXISTS `man_hours`;

CREATE TABLE `man_hours` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `mh` float DEFAULT NULL,
  `group_engineer_id` int(11) DEFAULT NULL,
  `work_order_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_jvbjw7t8p6ikdrtgw1fxobk5y` (`group_engineer_id`),
  KEY `FK_4waac2ibcwm04m51egk38g1k4` (`work_order_id`),
  CONSTRAINT `FK_4waac2ibcwm04m51egk38g1k4` FOREIGN KEY (`work_order_id`) REFERENCES `work_order` (`id`),
  CONSTRAINT `FK_jvbjw7t8p6ikdrtgw1fxobk5y` FOREIGN KEY (`group_engineer_id`) REFERENCES `group_engineer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `man_hours` */

insert  into `man_hours`(`id`,`mh`,`group_engineer_id`,`work_order_id`) values (1,3,2,1),(2,3,6,1),(3,2,2,1),(4,123,2,1);

/*Table structure for table `material` */

DROP TABLE IF EXISTS `material`;

CREATE TABLE `material` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `complete_code` varchar(255) DEFAULT NULL,
  `cost` float DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `item_type_id` int(5) DEFAULT NULL,
  `specification` varchar(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_rveuv7odl1m50fbvdvkxxqqin` (`parent_id`),
  CONSTRAINT `FK_rveuv7odl1m50fbvdvkxxqqin` FOREIGN KEY (`parent_id`) REFERENCES `material` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `material` */

insert  into `material`(`id`,`code`,`complete_code`,`cost`,`description`,`name`,`unit`,`parent_id`,`item_type_id`,`specification`) values (1,'DT','DT',32,'Dien thoai','Dient hoai','Cai',NULL,1,NULL),(2,'NAP','DT.NAP',12,'Nap dt','Nap','Cai',1,1,NULL),(4,'00122','DT.00122',23,NULL,'Vo 01','kg',1,1,'{\"01\":{\"label\":\"dfgsdf\",\"value\":\"aaa\"},\"02\":{\"label\":\"gfnh\",\"value\":\"bbb\"},\"06\":{\"label\":\"6ujj\",\"value\":\"cccc\"}}');

/*Table structure for table `role` */

DROP TABLE IF EXISTS `role`;

CREATE TABLE `role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(64) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `role` */

insert  into `role`(`id`,`description`,`name`) values (-2,'Default role for all Users','ROLE_USER'),(-1,'Administrator role (can edit Users)','ROLE_ADMIN');

/*Table structure for table `stock_item` */

DROP TABLE IF EXISTS `stock_item`;

CREATE TABLE `stock_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `quantity` int(11) DEFAULT NULL,
  `material_id` bigint(20) DEFAULT NULL,
  `work_order_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_483v0fy4uxibk65jgx01no1cv` (`material_id`),
  KEY `FK_pcns1e0l07tgg6vcfuyb9k7q5` (`work_order_id`),
  CONSTRAINT `FK_483v0fy4uxibk65jgx01no1cv` FOREIGN KEY (`material_id`) REFERENCES `material` (`id`),
  CONSTRAINT `FK_pcns1e0l07tgg6vcfuyb9k7q5` FOREIGN KEY (`work_order_id`) REFERENCES `work_order` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `stock_item` */

insert  into `stock_item`(`id`,`quantity`,`material_id`,`work_order_id`) values (1,2,2,1);

/*Table structure for table `supplier` */

DROP TABLE IF EXISTS `supplier`;

CREATE TABLE `supplier` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `supplier` */

/*Table structure for table `user_role` */

DROP TABLE IF EXISTS `user_role`;

CREATE TABLE `user_role` (
  `user_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `FK_it77eq964jhfqtu54081ebtio` (`role_id`),
  CONSTRAINT `FK_apcc8lxk2xnug8377fatvbn04` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`),
  CONSTRAINT `FK_it77eq964jhfqtu54081ebtio` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `user_role` */

insert  into `user_role`(`user_id`,`role_id`) values (-3,-2),(-1,-2),(1,-2),(-3,-1),(-2,-1),(1,-1);

/*Table structure for table `work_order` */

DROP TABLE IF EXISTS `work_order`;

CREATE TABLE `work_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `i_interval` int(11) DEFAULT NULL,
  `is_repeat` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `task` varchar(255) DEFAULT NULL,
  `group_engineer_id` int(11) DEFAULT NULL,
  `machine_id` bigint(20) DEFAULT NULL,
  `work_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_2y2rdnljsreriuijm6tc6ynjm` (`group_engineer_id`),
  KEY `FK_e0lp16k0jddk506tbhjb47hpx` (`machine_id`),
  KEY `FK_s7cu0n4tt86almpepjehdhod` (`work_type_id`),
  CONSTRAINT `FK_2y2rdnljsreriuijm6tc6ynjm` FOREIGN KEY (`group_engineer_id`) REFERENCES `group_engineer` (`id`),
  CONSTRAINT `FK_e0lp16k0jddk506tbhjb47hpx` FOREIGN KEY (`machine_id`) REFERENCES `machine` (`id`),
  CONSTRAINT `FK_s7cu0n4tt86almpepjehdhod` FOREIGN KEY (`work_type_id`) REFERENCES `work_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `work_order` */

insert  into `work_order`(`id`,`code`,`end_time`,`i_interval`,`is_repeat`,`name`,`note`,`reason`,`start_time`,`status`,`task`,`group_engineer_id`,`machine_id`,`work_type_id`) values (1,'AA','2017-09-15 00:00:00',45,1,'test','','','2017-09-13 00:00:00',1,'task 1\ntask 2',1,1,1);

/*Table structure for table `work_type` */

DROP TABLE IF EXISTS `work_type`;

CREATE TABLE `work_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `complete_code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_5x6yu244uvup63qgvmg12rtae` (`parent_id`),
  CONSTRAINT `FK_5x6yu244uvup63qgvmg12rtae` FOREIGN KEY (`parent_id`) REFERENCES `work_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

/*Data for the table `work_type` */

insert  into `work_type`(`id`,`code`,`name`,`parent_id`,`complete_code`) values (1,'AA','AAA name',NULL,NULL),(2,'BB','BB Root',NULL,'BB'),(7,'001','BB - 001',2,'BB.001'),(8,'002','BB - 002',2,'BB.002'),(9,'ss','BBsfsaf',7,'001.ss'),(10,'CC','CC Root',NULL,'CC'),(11,'01','CC 01',10,'CC.01'),(12,'02','CC 02',10,'CC.02'),(13,'03','CC 03',10,'CC.03'),(14,'04','CC 04',10,'CC.04'),(15,'05','CC 05',10,'CC.05'),(16,'06','CC 06',10,'CC.06'),(17,'07','CC 07',10,'CC.07'),(18,'08','CC 08',10,'CC.08');

/* Function  structure for function  `GetAncestry` */

/*!50003 DROP FUNCTION IF EXISTS `GetAncestry` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `GetAncestry`(GivenID INT) RETURNS varchar(1024) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE rv VARCHAR(1024);
    DECLARE cm CHAR(1);
    DECLARE ch INT;
    SET rv = '';
    SET cm = '';
    SET ch = GivenID;
    WHILE ch > 0 DO
        SELECT IFNULL(parent_id,-1) INTO ch FROM
        (SELECT parent_id FROM item_type WHERE id = ch) A;
        IF ch > 0 THEN
            SET rv = CONCAT(rv,cm,ch);
            SET cm = ',';
        END IF;
    END WHILE;
    RETURN rv;
END */$$
DELIMITER ;

/* Function  structure for function  `GetCompanyTree` */

/*!50003 DROP FUNCTION IF EXISTS `GetCompanyTree` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `GetCompanyTree`(GivenID INT,LevelLimit INT) RETURNS varchar(1024) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE rv,q,queue,queue_children,front_rc,level_part VARCHAR(1024);
    DECLARE queue_length,front_id,front_ht,pos,curr_level INT;
    SET rv = '';
    SET queue = CONCAT(GivenID,':0');
    SET queue_length = 1;
    WHILE queue_length > 0 DO
        SET front_id = FORMAT(queue,0);
        IF queue_length = 1 THEN
            SET front_rc = queue;
            SET queue = '';
            SET pos = LOCATE(':',front_rc);
        ELSE
            SET pos = LOCATE(',',queue);
            SET front_rc = LEFT(queue,pos - 1);
            SET q = SUBSTR(queue,pos + 1);
            SET queue = q;
            SET pos = LOCATE(':',front_rc);
        END IF;
        SET front_id = LEFT(front_rc,pos - 1);
        SET front_ht = SUBSTR(front_rc,pos + 1);
        SET queue_length = queue_length - 1;
        SELECT IFNULL(qc,'') INTO queue_children
        FROM (SELECT GROUP_CONCAT(CONCAT(id,':',front_ht+1)) qc
        FROM company WHERE parent_id = front_id) A;
        IF LENGTH(queue_children) = 0 THEN
            IF LENGTH(queue) = 0 THEN
                SET queue_length = 0;
            END IF;
        ELSE
            IF LENGTH(rv) = 0 THEN
                IF front_ht < LevelLimit THEN
                    SET rv = queue_children;
                END IF;
            ELSE
                IF front_ht < LevelLimit THEN
                    SET rv = CONCAT(rv,',',queue_children);
                END IF;
            END IF;
            IF LENGTH(queue) = 0 THEN
                SET queue = queue_children;
            ELSE
                SET queue = CONCAT(queue,',',queue_children);
            END IF;
            SET queue_length = LENGTH(queue) - LENGTH(REPLACE(queue,',','')) + 1;
        END IF;
    END WHILE;
    #
    # Strip away level parts of the output
    #
    IF LENGTH(rv) > 0 THEN
        SET curr_level = 1;
        WHILE curr_level <= LevelLimit DO
            SET level_part = CONCAT(':',curr_level);
            SET rv = REPLACE(rv,level_part,'');
            SET curr_level = curr_level + 1;
        END WHILE;
    END IF;
    RETURN rv;
END */$$
DELIMITER ;

/* Function  structure for function  `GetEngineerTree` */

/*!50003 DROP FUNCTION IF EXISTS `GetEngineerTree` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `GetEngineerTree`(GivenID INT,LevelLimit INT) RETURNS varchar(1024) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE rv,q,queue,queue_children,front_rc,level_part VARCHAR(1024);
    DECLARE queue_length,front_id,front_ht,pos,curr_level INT;
    SET rv = '';
    SET queue = CONCAT(GivenID,':0');
    SET queue_length = 1;
    WHILE queue_length > 0 DO
        SET front_id = FORMAT(queue,0);
        IF queue_length = 1 THEN
            SET front_rc = queue;
            SET queue = '';
            SET pos = LOCATE(':',front_rc);
        ELSE
            SET pos = LOCATE(',',queue);
            SET front_rc = LEFT(queue,pos - 1);
            SET q = SUBSTR(queue,pos + 1);
            SET queue = q;
            SET pos = LOCATE(':',front_rc);
        END IF;
        SET front_id = LEFT(front_rc,pos - 1);
        SET front_ht = SUBSTR(front_rc,pos + 1);
        SET queue_length = queue_length - 1;
        SELECT IFNULL(qc,'') INTO queue_children
        FROM (SELECT GROUP_CONCAT(CONCAT(id,':',front_ht+1)) qc
        FROM `group_engineer` WHERE parent_id = front_id) A;
        IF LENGTH(queue_children) = 0 THEN
            IF LENGTH(queue) = 0 THEN
                SET queue_length = 0;
            END IF;
        ELSE
            IF LENGTH(rv) = 0 THEN
                IF front_ht < LevelLimit THEN
                    SET rv = queue_children;
                END IF;
            ELSE
                IF front_ht < LevelLimit THEN
                    SET rv = CONCAT(rv,',',queue_children);
                END IF;
            END IF;
            IF LENGTH(queue) = 0 THEN
                SET queue = queue_children;
            ELSE
                SET queue = CONCAT(queue,',',queue_children);
            END IF;
            SET queue_length = LENGTH(queue) - LENGTH(REPLACE(queue,',','')) + 1;
        END IF;
    END WHILE;
    #
    # Strip away level parts of the output
    #
    IF LENGTH(rv) > 0 THEN
        SET curr_level = 1;
        WHILE curr_level <= LevelLimit DO
            SET level_part = CONCAT(':',curr_level);
            SET rv = REPLACE(rv,level_part,'');
            SET curr_level = curr_level + 1;
        END WHILE;
    END IF;
    RETURN rv;
END */$$
DELIMITER ;

/* Function  structure for function  `GetFamilyTree` */

/*!50003 DROP FUNCTION IF EXISTS `GetFamilyTree` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `GetFamilyTree`(GivenID INT,LevelLimit INT) RETURNS varchar(1024) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE rv,q,queue,queue_children,front_rc,level_part VARCHAR(1024);
    DECLARE queue_length,front_id,front_ht,pos,curr_level INT;
    SET rv = '';
    SET queue = CONCAT(GivenID,':0');
    SET queue_length = 1;
    WHILE queue_length > 0 DO
        SET front_id = FORMAT(queue,0);
        IF queue_length = 1 THEN
            SET front_rc = queue;
            SET queue = '';
            SET pos = LOCATE(':',front_rc);
        ELSE
            SET pos = LOCATE(',',queue);
            SET front_rc = LEFT(queue,pos - 1);
            SET q = SUBSTR(queue,pos + 1);
            SET queue = q;
            SET pos = LOCATE(':',front_rc);
        END IF;
        SET front_id = LEFT(front_rc,pos - 1);
        SET front_ht = SUBSTR(front_rc,pos + 1);
        SET queue_length = queue_length - 1;
        SELECT IFNULL(qc,'') INTO queue_children
        FROM (SELECT GROUP_CONCAT(CONCAT(id,':',front_ht+1)) qc
        FROM item_type WHERE parent_id = front_id) A;
        IF LENGTH(queue_children) = 0 THEN
            IF LENGTH(queue) = 0 THEN
                SET queue_length = 0;
            END IF;
        ELSE
            IF LENGTH(rv) = 0 THEN
                IF front_ht < LevelLimit THEN
                    SET rv = queue_children;
                END IF;
            ELSE
                IF front_ht < LevelLimit THEN
                    SET rv = CONCAT(rv,',',queue_children);
                END IF;
            END IF;
            IF LENGTH(queue) = 0 THEN
                SET queue = queue_children;
            ELSE
                SET queue = CONCAT(queue,',',queue_children);
            END IF;
            SET queue_length = LENGTH(queue) - LENGTH(REPLACE(queue,',','')) + 1;
        END IF;
    END WHILE;
    #
    # Strip away level parts of the output
    #
    IF LENGTH(rv) > 0 THEN
        SET curr_level = 1;
        WHILE curr_level <= LevelLimit DO
            SET level_part = CONCAT(':',curr_level);
            SET rv = REPLACE(rv,level_part,'');
            SET curr_level = curr_level + 1;
        END WHILE;
    END IF;
    RETURN rv;
END */$$
DELIMITER ;

/* Function  structure for function  `GetItemTypeTree` */

/*!50003 DROP FUNCTION IF EXISTS `GetItemTypeTree` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `GetItemTypeTree`(GivenID INT,LevelLimit INT) RETURNS varchar(1024) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE rv,q,queue,queue_children,front_rc,level_part VARCHAR(1024);
    DECLARE queue_length,front_id,front_ht,pos,curr_level INT;
    SET rv = '';
    SET queue = CONCAT(GivenID,':0');
    SET queue_length = 1;
    WHILE queue_length > 0 DO
        SET front_id = FORMAT(queue,0);
        IF queue_length = 1 THEN
            SET front_rc = queue;
            SET queue = '';
            SET pos = LOCATE(':',front_rc);
        ELSE
            SET pos = LOCATE(',',queue);
            SET front_rc = LEFT(queue,pos - 1);
            SET q = SUBSTR(queue,pos + 1);
            SET queue = q;
            SET pos = LOCATE(':',front_rc);
        END IF;
        SET front_id = LEFT(front_rc,pos - 1);
        SET front_ht = SUBSTR(front_rc,pos + 1);
        SET queue_length = queue_length - 1;
        SELECT IFNULL(qc,'') INTO queue_children
        FROM (SELECT GROUP_CONCAT(CONCAT(id,':',front_ht+1)) qc
        FROM `item_type` WHERE parent_id = front_id) A;
        IF LENGTH(queue_children) = 0 THEN
            IF LENGTH(queue) = 0 THEN
                SET queue_length = 0;
            END IF;
        ELSE
            IF LENGTH(rv) = 0 THEN
                IF front_ht < LevelLimit THEN
                    SET rv = queue_children;
                END IF;
            ELSE
                IF front_ht < LevelLimit THEN
                    SET rv = CONCAT(rv,',',queue_children);
                END IF;
            END IF;
            IF LENGTH(queue) = 0 THEN
                SET queue = queue_children;
            ELSE
                SET queue = CONCAT(queue,',',queue_children);
            END IF;
            SET queue_length = LENGTH(queue) - LENGTH(REPLACE(queue,',','')) + 1;
        END IF;
    END WHILE;
    #
    # Strip away level parts of the output
    #
    IF LENGTH(rv) > 0 THEN
        SET curr_level = 1;
        WHILE curr_level <= LevelLimit DO
            SET level_part = CONCAT(':',curr_level);
            SET rv = REPLACE(rv,level_part,'');
            SET curr_level = curr_level + 1;
        END WHILE;
    END IF;
    RETURN rv;
END */$$
DELIMITER ;

/* Function  structure for function  `GetWorkTypeTree` */

/*!50003 DROP FUNCTION IF EXISTS `GetWorkTypeTree` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `GetWorkTypeTree`(GivenID INT,LevelLimit INT) RETURNS varchar(1024) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE rv,q,queue,queue_children,front_rc,level_part VARCHAR(1024);
    DECLARE queue_length,front_id,front_ht,pos,curr_level INT;
    SET rv = '';
    SET queue = CONCAT(GivenID,':0');
    SET queue_length = 1;
    WHILE queue_length > 0 DO
        SET front_id = FORMAT(queue,0);
        IF queue_length = 1 THEN
            SET front_rc = queue;
            SET queue = '';
            SET pos = LOCATE(':',front_rc);
        ELSE
            SET pos = LOCATE(',',queue);
            SET front_rc = LEFT(queue,pos - 1);
            SET q = SUBSTR(queue,pos + 1);
            SET queue = q;
            SET pos = LOCATE(':',front_rc);
        END IF;
        SET front_id = LEFT(front_rc,pos - 1);
        SET front_ht = SUBSTR(front_rc,pos + 1);
        SET queue_length = queue_length - 1;
        SELECT IFNULL(qc,'') INTO queue_children
        FROM (SELECT GROUP_CONCAT(CONCAT(id,':',front_ht+1)) qc
        FROM work_type WHERE parent_id = front_id) A;
        IF LENGTH(queue_children) = 0 THEN
            IF LENGTH(queue) = 0 THEN
                SET queue_length = 0;
            END IF;
        ELSE
            IF LENGTH(rv) = 0 THEN
                IF front_ht < LevelLimit THEN
                    SET rv = queue_children;
                END IF;
            ELSE
                IF front_ht < LevelLimit THEN
                    SET rv = CONCAT(rv,',',queue_children);
                END IF;
            END IF;
            IF LENGTH(queue) = 0 THEN
                SET queue = queue_children;
            ELSE
                SET queue = CONCAT(queue,',',queue_children);
            END IF;
            SET queue_length = LENGTH(queue) - LENGTH(REPLACE(queue,',','')) + 1;
        END IF;
    END WHILE;
    #
    # Strip away level parts of the output
    #
    IF LENGTH(rv) > 0 THEN
        SET curr_level = 1;
        WHILE curr_level <= LevelLimit DO
            SET level_part = CONCAT(':',curr_level);
            SET rv = REPLACE(rv,level_part,'');
            SET curr_level = curr_level + 1;
        END WHILE;
    END IF;
    RETURN rv;
END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
