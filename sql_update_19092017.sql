ALTER TABLE `work_order` CHANGE `status` `status` INT(1) COMMENT '0: Complete, 1: Open, 2: Overdue' DEFAULT 0;

DELIMITER $$
CREATE 
	EVENT `SCH_WO_OverDue` 
	ON SCHEDULE EVERY 1 HOUR STARTS '2017-09-19 10:00:00' 
	DO BEGIN
	
		-- update overdue
		UPDATE `work_order` SET last_update=NOW(),`status`= 2 WHERE `status`= 1 AND `start_time`<NOW();
	    
	END $$

DELIMITER ;