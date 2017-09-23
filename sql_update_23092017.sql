ALTER TABLE `app_user` CHANGE `last_name` `last_name` VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `app_user` CHANGE `password_hint` `password_hint` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;
ALTER TABLE `app_user` CHANGE `email` `email` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL;