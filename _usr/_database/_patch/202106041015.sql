ALTER TABLE `job` ADD `se_foreground` INT(1) NULL DEFAULT NULL AFTER `token`, ADD KEY `se_foreground` (`se_foreground`) ;
