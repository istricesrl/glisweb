ALTER TABLE `anagrafica` ADD `riferimento` CHAR(32) NULL DEFAULT NULL AFTER `codice`, ADD INDEX (`riferimento`) ;