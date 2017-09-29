ALTER TABLE `work_type` ADD COLUMN `group_engineer_id` INT(11) NOT NULL;
ALTER TABLE `work_type` ADD COLUMN `task` VARCHAR(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `work_type` ADD COLUMN `i_interval` INT(5) DEFAULT 0;
ALTER TABLE `work_type` ADD COLUMN `is_repeat` INT(1) DEFAULT 0;