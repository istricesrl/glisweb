ALTER TABLE `ruoli_progetti` ADD `se_responsabile_acquisti` INT(1) NULL DEFAULT NULL AFTER `se_responsabile_qualita`, ADD INDEX (`se_responsabile_acquisti`) ;