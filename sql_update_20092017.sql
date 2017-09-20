ALTER TABLE `material` ADD COLUMN location VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `work_order` ADD COLUMN last_update DATETIME DEFAULT NULL;

ALTER TABLE `company` CHANGE `name` `name` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `company` CHANGE `description` `description` VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;

ALTER TABLE `group_engineer` CHANGE `name` `name` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `group_engineer` CHANGE `description` `description` VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;

ALTER TABLE `item_type` CHANGE `name` `name` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `item_type` CHANGE `specification` `specification` VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;

ALTER TABLE `machine` CHANGE `name` `name` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `machine` CHANGE `description` `description` VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `machine` CHANGE `note` `note` VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `machine` CHANGE `specification` `specification` VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `machine` CHANGE `img_url` `img_url` VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `machine` CHANGE `img_path` `img_path` VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;

ALTER TABLE `machine_type` CHANGE `name` `name` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `machine_type` CHANGE `description` `description` VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `machine_type` CHANGE `specification` `specification` VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;


ALTER TABLE `material` CHANGE `name` `name` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `material` CHANGE `description` `description` VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `material` CHANGE `unit` `unit` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `material` CHANGE `specification` `specification` VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `material` CHANGE `img_url` `img_url` VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `material` CHANGE `img_path` `img_path` VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `material` CHANGE `location` `location` VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;


ALTER TABLE `work_order` CHANGE `name` `name` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `work_order` CHANGE `note` `note` VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `work_order` CHANGE `reason` `reason` VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `work_order` CHANGE `task` `task` VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;


ALTER TABLE `work_type` CHANGE `name` `name` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
