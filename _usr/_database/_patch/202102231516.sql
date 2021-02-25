ALTER TABLE `todo` 
ADD `ora_fine_pianificazione` TIME NULL DEFAULT NULL AFTER `ora_inizio_pianificazione`,
ADD `anno_pianificazione` YEAR(4) NULL DEFAULT NULL AFTER `ora_fine_pianificazione`, 
ADD `settimana_pianificazione` INT(11) NULL DEFAULT NULL AFTER `anno_pianificazione`,
ADD `ora_scadenza` TIME NULL DEFAULT NULL AFTER `data_scadenza`;