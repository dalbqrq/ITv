SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

ALTER TABLE `itvision`.`itvision_app_object` DROP FOREIGN KEY `fk_app_id6` , DROP FOREIGN KEY `fk_object_id3` ;

ALTER TABLE `itvision`.`itvision_app_relat` DROP FOREIGN KEY `fk_id1` , DROP FOREIGN KEY `fk_id2` ;

ALTER TABLE `itvision`.`itvision_app_tree` DROP FOREIGN KEY `fk_app_id5` ;

ALTER TABLE `itvision`.`itvision_user` DROP FOREIGN KEY `fk_user_group_id1` ;

ALTER TABLE `itvision`.`itvision_app` CHARACTER SET = utf8 , COLLATE = utf8_unicode_ci , ADD COLUMN `entities_id` INT(11) NOT NULL DEFAULT 0  AFTER `instance_id` , CHANGE COLUMN `is_active` `is_active` TINYINT(4) NOT NULL DEFAULT 0  , RENAME TO  `itvision`.`itvision_apps` ;

ALTER TABLE `itvision`.`itvision_app_object` CHARACTER SET = utf8 , COLLATE = utf8_general_ci , CHANGE COLUMN `object_id` `service_object_id` INT(11) NOT NULL  , 
  ADD CONSTRAINT `fk_app_id6`
  FOREIGN KEY (`app_id` )
  REFERENCES `itvision`.`itvision_apps` (`id` )
  ON DELETE CASCADE
  ON UPDATE CASCADE, 
  ADD CONSTRAINT `fk_object_id3`
  FOREIGN KEY (`service_object_id` )
  REFERENCES `itvision`.`nagios_objects` (`object_id` )
  ON DELETE CASCADE
  ON UPDATE CASCADE, RENAME TO  `itvision`.`itvision_app_objects` ;

ALTER TABLE `itvision`.`itvision_app_relat` CHARACTER SET = utf8 , COLLATE = utf8_general_ci , 
  ADD CONSTRAINT `fk_id1`
  FOREIGN KEY (`app_relat_type_id` )
  REFERENCES `itvision`.`itvision_app_relat_types` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION, 
  ADD CONSTRAINT `fk_id2`
  FOREIGN KEY (`app_id` )
  REFERENCES `itvision`.`itvision_apps` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION, RENAME TO  `itvision`.`itvision_app_relats` ;

ALTER TABLE `itvision`.`itvision_app_relat_type` CHARACTER SET = utf8 , COLLATE = utf8_general_ci , RENAME TO  `itvision`.`itvision_app_relat_types` ;

ALTER TABLE `itvision`.`itvision_app_tree` CHARACTER SET = utf8 , COLLATE = utf8_general_ci , 
  ADD CONSTRAINT `fk_app_id5`
  FOREIGN KEY (`app_id` )
  REFERENCES `itvision`.`itvision_apps` (`id` )
  ON DELETE CASCADE
  ON UPDATE CASCADE, RENAME TO  `itvision`.`itvision_app_trees` ;

ALTER TABLE `itvision`.`itvision_monitor` CHARACTER SET = utf8 , COLLATE = utf8_general_ci , DROP COLUMN `host_object_id` , ADD COLUMN `instance_id` SMALLINT(6) NOT NULL  FIRST , ADD COLUMN `entities_id` INT(11) NOT NULL DEFAULT 0  AFTER `instance_id` , ADD COLUMN `networkequipments_id` INT(11) NULL DEFAULT NULL  AFTER `softwareversions_id` , CHANGE COLUMN `service_object_id` `service_object_id` INT(11) NOT NULL  AFTER `entities_id` , CHANGE COLUMN `is_active` `is_active` TINYINT(4) NOT NULL DEFAULT 0  , RENAME TO  `itvision`.`itvision_monitors` ;

ALTER TABLE `itvision`.`itvision_site_tree` CHARACTER SET = utf8 , COLLATE = utf8_general_ci , RENAME TO  `itvision`.`itvision_site_trees` ;

ALTER TABLE `itvision`.`itvision_sysconfig` CHARACTER SET = utf8 , COLLATE = utf8_general_ci ;

ALTER TABLE `itvision`.`itvision_user` CHARACTER SET = utf8 , COLLATE = utf8_general_ci , 
  ADD CONSTRAINT `fk_user_group_id1`
  FOREIGN KEY (`user_group_id` )
  REFERENCES `itvision`.`itvision_user_groups` (`id` )
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `itvision`.`itvision_user_group` CHARACTER SET = utf8 , COLLATE = utf8_general_ci , RENAME TO  `itvision`.`itvision_user_groups` ;

ALTER TABLE `itvision`.`itvision_user_prefs` CHARACTER SET = utf8 , COLLATE = utf8_general_ci ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;





SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

ALTER TABLE `itvision`.`itvision_apps` CHANGE COLUMN `name` `name` VARCHAR(45) NOT NULL  , CHANGE COLUMN `type` `type` ENUM('and','or') NOT NULL DEFAULT 'and'  , 
  ADD CONSTRAINT `fk_instance_id20`
  FOREIGN KEY (`instance_id` )
  REFERENCES `itvision`.`nagios_instances` (`instance_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION, 
  ADD CONSTRAINT `fk_instance_id27`
  FOREIGN KEY (`instance_id` )
  REFERENCES `itvision`.`nagios_instances` (`instance_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION, 
  ADD CONSTRAINT `fk_object_id26`
  FOREIGN KEY (`service_object_id` )
  REFERENCES `itvision`.`nagios_objects` (`object_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `itvision`.`itvision_app_objects` COLLATE = utf8_general_ci , CHANGE COLUMN `type` `type` ENUM('app','hst','svc') NOT NULL  , 
  ADD CONSTRAINT `fk_instance_id11`
  FOREIGN KEY (`instance_id` )
  REFERENCES `itvision`.`nagios_instances` (`instance_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `itvision`.`itvision_app_relats` COLLATE = utf8_general_ci , 
  ADD CONSTRAINT `fk_instance_id12`
  FOREIGN KEY (`instance_id` )
  REFERENCES `itvision`.`nagios_instances` (`instance_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION, 
  ADD CONSTRAINT `fk_object_id7`
  FOREIGN KEY (`from_object_id` )
  REFERENCES `itvision`.`nagios_objects` (`object_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION, 
  ADD CONSTRAINT `fk_object_id8`
  FOREIGN KEY (`to_object_id` )
  REFERENCES `itvision`.`nagios_objects` (`object_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `itvision`.`itvision_app_relat_types` COLLATE = utf8_general_ci , CHANGE COLUMN `name` `name` VARCHAR(45) NOT NULL  , CHANGE COLUMN `type` `type` ENUM('physical','logical') NULL DEFAULT 'logical'  ;

ALTER TABLE `itvision`.`itvision_app_trees` COLLATE = utf8_general_ci , 
  ADD CONSTRAINT `fk_instance_id16`
  FOREIGN KEY (`instance_id` )
  REFERENCES `itvision`.`nagios_instances` (`instance_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `itvision`.`itvision_monitors` COLLATE = utf8_general_ci , CHANGE COLUMN `type` `type` ENUM('hst','svc') NOT NULL DEFAULT 'hst'  ;

ALTER TABLE `itvision`.`itvision_site_trees` COLLATE = utf8_general_ci , 
  ADD CONSTRAINT `fk_instance_id1`
  FOREIGN KEY (`instance_id` )
  REFERENCES `itvision`.`nagios_instances` (`instance_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION, 
  ADD CONSTRAINT `fk_object_id1`
  FOREIGN KEY (`service_object_id` )
  REFERENCES `itvision`.`nagios_objects` (`object_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `itvision`.`itvision_sysconfig` COLLATE = utf8_general_ci , CHANGE COLUMN `version` `version` VARCHAR(45) NOT NULL  , CHANGE COLUMN `home_dir` `home_dir` VARCHAR(45) NOT NULL  , CHANGE COLUMN `monitor_dir` `monitor_dir` VARCHAR(45) NOT NULL  , CHANGE COLUMN `monitor_bp_dir` `monitor_bp_dir` VARCHAR(45) NOT NULL  ;

ALTER TABLE `itvision`.`itvision_user` COLLATE = utf8_general_ci , CHANGE COLUMN `login` `login` VARCHAR(45) NOT NULL  , CHANGE COLUMN `password` `password` VARCHAR(45) NOT NULL  , RENAME TO  `itvision`.`itvision_users` ;

ALTER TABLE `itvision`.`itvision_user_groups` COLLATE = utf8_general_ci , CHANGE COLUMN `name` `name` VARCHAR(45) NOT NULL  , 
  ADD CONSTRAINT `fk_instance_id6`
  FOREIGN KEY (`instance_id` )
  REFERENCES `itvision`.`nagios_instances` (`instance_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `itvision`.`itvision_user_prefs` COLLATE = utf8_general_ci ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

