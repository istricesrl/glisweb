ALTER TABLE `codici_tracking` 
ADD `id_campagna` INT NULL DEFAULT NULL,
ADD `id_account_inserimento` INT NULL DEFAULT NULL ,
ADD `timestamp_inserimento` INT NULL DEFAULT NULL ,
ADD `id_account_aggiornamento` INT NULL DEFAULT NULL ,
ADD `timestamp_aggiornamento` INT NULL DEFAULT NULL, 
ADD INDEX(`id_account_inserimento`), 
ADD INDEX (`id_campagna`), 
ADD INDEX(`id_account_aggiornamento`);