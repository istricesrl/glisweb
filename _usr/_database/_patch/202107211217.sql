ALTER TABLE `attivita_view_static` ADD `se_master` INT(1) NULL DEFAULT NULL AFTER `anno`, ADD `ore_previste` DECIMAL(5,2) NULL DEFAULT NULL AFTER `ore`, ADD KEY `se_master` (`se_master`) ;
