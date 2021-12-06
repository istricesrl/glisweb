ALTER TABLE `cartellini` ADD `timestamp_approvazione` INT NULL DEFAULT NULL AFTER `ore_fatte`, ADD `id_account_approvazione` INT NULL DEFAULT NULL AFTER `timestamp_approvazione`,ADD INDEX `id_account_approvazione`(`id_account_approvazione`),
ADD INDEX `id_account_inserimento`(`id_account_inserimento`),
ADD INDEX `id_account_aggiornamento`(`id_account_aggiornamento`);
