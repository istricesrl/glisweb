ALTER TABLE `pianificazioni` ADD `timestamp_popolazione` INT NULL DEFAULT NULL AFTER `timestamp_estensione`, ADD INDEX (`timestamp_popolazione`) ;
