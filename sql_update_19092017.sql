ALTER TABLE `work_order` CHANGE `status` `status` INT(1) COMMENT '0: Complete, 1: Open, 2: In Progress, 3: Overdue' DEFAULT 1;


SHOW VARIABLES WHERE VARIABLE_NAME = 'event_scheduler';

SET GLOBAL event_scheduler = ON;
SET @@global.event_scheduler = ON;
SET GLOBAL event_scheduler = 1;
SET @@global.event_scheduler = 1;


DELIMITER $$
CREATE 
	EVENT `SCH_WO_OverDue` 
	ON SCHEDULE EVERY 1 HOUR STARTS '2017-09-19 10:00:00' 
	DO BEGIN
	
		-- update overdue
		UPDATE `work_order` SET last_update=NOW(),`status`= 3 WHERE `status` IN (1,2) AND `start_time`<NOW();
	    
	END $$

DELIMITER ;