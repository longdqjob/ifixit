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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `app_user` */

insert  into `app_user`(`id`,`account_expired`,`account_locked`,`address`,`city`,`country`,`postal_code`,`province`,`credentials_expired`,`email`,`account_enabled`,`first_name`,`last_name`,`password`,`password_hint`,`phone_number`,`username`,`version`,`website`) values (-3,'\0','\0','','Denver','US','80210','CO','\0','two_roles_user@appfuse.org','','Two Roles','User','$2a$10$bH/ssqW8OhkTlIso9/yakubYODUOmh.6m5HEJvcBq3t3VdBh7ebqO','Not a female kitty.','','two_roles_user',1,'http://raibledesigns.com'),(-2,'\0','\0','','Denver','US','80210','CO','\0','matt@raibledesigns.com','','Matt','Raible','$2a$10$bH/ssqW8OhkTlIso9/yakubYODUOmh.6m5HEJvcBq3t3VdBh7ebqO','Not a female kitty.','','admin',1,'http://raibledesigns.com'),(-1,'\0','\0','','Denver','US','80210','CO','\0','matt_raible@yahoo.com','','Tomcat','User','$2a$10$CnQVJ9bsWBjMpeSKrrdDEeuIptZxXrwtI6CZ/OgtNxhIgpKxXeT9y','A male kitty.','','user',1,'http://tomcat.apache.org');

/*Table structure for table `company` */

DROP TABLE IF EXISTS `company`;

CREATE TABLE `company` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) DEFAULT NULL,
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` int(1) DEFAULT NULL,
  `parent_id` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

/*Data for the table `company` */

insert  into `company`(`id`,`code`,`description`,`name`,`state`,`parent_id`) values (1,'LAMSON','Lamson comany des','Lamson company',NULL,NULL),(2,'LAMSON01','Trung tam 01','Trung tam 01',NULL,1),(3,'LAMSON02','Trung tam 02','Trung tam 02',NULL,1),(4,'TESST','TESST desc','test',NULL,1),(6,'sldfjk','slkj','sdfkjl',NULL,2),(7,'sfn','fgn','sadf',NULL,1),(8,'ng','fgn','een',NULL,7);

/*Table structure for table `group_engineer` */

DROP TABLE IF EXISTS `group_engineer`;

CREATE TABLE `group_engineer` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `cost` float DEFAULT NULL,
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `group_engineer` */

/*Table structure for table `item_type` */

DROP TABLE IF EXISTS `item_type`;

CREATE TABLE `item_type` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) DEFAULT NULL,
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `specification` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `parent_id` int(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `item_type` */

insert  into `item_type`(`id`,`code`,`description`,`name`,`specification`,`parent_id`) values (1,'G','Generic','Generic',NULL,0),(2,'AU','AUTO MOBILE','AUTO MOBILE',NULL,1),(3,'AV','HVAC','HVAC',NULL,1),(4,'010','TYRES','TYRES',NULL,2),(5,'020','FILTERS (AUTO)','FILTERS (AUTO)',NULL,2);

/*Table structure for table `machine` */

DROP TABLE IF EXISTS `machine`;

CREATE TABLE `machine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `item_type_id` int(11) DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent` int(5) DEFAULT NULL,
  `company_id` int(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;

/*Data for the table `machine` */

insert  into `machine`(`id`,`code`,`description`,`item_type_id`,`name`,`parent`,`company_id`) values (1,'11a','a',4,'aa',NULL,NULL),(2,'22b','b',4,'bb',NULL,NULL),(3,'cc','cc',5,'cc',NULL,NULL),(4,'cc','cc',5,'cc',NULL,NULL),(5,'55b','b',4,'bb',NULL,NULL),(6,'66a','a',4,'aa',NULL,NULL),(7,'77a','a',4,'aa',NULL,NULL),(8,'88a','a',4,'aa',NULL,NULL),(9,'99a','a',4,'aa',NULL,NULL),(10,'1010a','a',4,'aa',NULL,NULL),(11,'1111a','a',4,'aa',NULL,NULL),(12,'1212a','a',4,'aa',NULL,NULL),(13,'1313a','a',4,'aa',NULL,NULL),(14,'1414a','a',4,'aa',NULL,NULL),(15,'1515a','a',4,'aa',NULL,NULL),(16,'1616a','a',4,'aa',NULL,NULL),(17,'1717a','a',4,'aa',NULL,NULL),(18,'1818a','a',4,'aa',NULL,NULL),(19,'1919a','a',4,'aa',NULL,NULL),(20,'2020a','a',4,'aa',NULL,NULL),(21,'21a','a',4,'aa',NULL,NULL),(22,'22a','a',4,'aa',NULL,NULL),(23,'23b','b',4,'bb',NULL,NULL),(24,'cc','cc',5,'cc',NULL,NULL),(25,'251a','a',4,'aa',NULL,NULL),(26,'261a','a',4,'aa',NULL,NULL),(27,'271a','a',4,'aa',NULL,NULL),(28,'281a','a',4,'aa',NULL,NULL),(29,'291a','a',4,'aa',NULL,NULL);

/*Table structure for table `machine_type` */

DROP TABLE IF EXISTS `machine_type`;

CREATE TABLE `machine_type` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `specification` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `note` varchar(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `machine_type` */

insert  into `machine_type`(`id`,`code`,`name`,`description`,`specification`,`note`) values (2,'fbnad','ndan','dn','{\"01\":\"t\\u00e9t\",\"02\":\"k\\u00edch th\\u01b0\\u1edbc\"}','fgn'),(3,'test','test','','{\"10\":\"docao\",\"13\":\"donang\",\"40\":\"IpAddress\",\"01\":\"SERIAL NO\",\"02\":\"trong luong\",\"03\":\"aa\",\"04\":\"haha\"}','stsvfsadg');

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

/*Table structure for table `supplier` */

DROP TABLE IF EXISTS `supplier`;

CREATE TABLE `supplier` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) DEFAULT NULL,
  `name` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact` varchar(125) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;

/*Data for the table `supplier` */

insert  into `supplier`(`id`,`code`,`name`,`contact`,`phone`,`email`,`address`,`city`,`country`) values (1,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(2,'bb','bbb','bbb','bbb',NULL,NULL,NULL,NULL),(6,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(7,'bb','bbb','bbb','bbb',NULL,NULL,NULL,NULL),(9,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(10,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(12,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(13,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(14,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(15,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(16,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(17,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(18,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(19,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(20,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(21,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(22,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(23,'a','â',NULL,NULL,NULL,NULL,NULL,NULL),(29,'abc','abc','abc','abc',NULL,NULL,NULL,NULL),(33,'bb','bb','bb','bb',NULL,NULL,NULL,NULL),(34,'cc','cc','cc','cc',NULL,NULL,NULL,NULL);

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

insert  into `user_role`(`user_id`,`role_id`) values (-3,-2),(-1,-2),(-3,-1),(-2,-1);

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

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
