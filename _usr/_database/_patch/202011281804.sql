ALTER TABLE `cron` ADD `token` CHAR(254) NULL DEFAULT NULL AFTER `iterazioni`, ADD INDEX (`token`) ;
