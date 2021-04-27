ALTER TABLE `attivita` 
ADD `ora_inizio` TIME NULL DEFAULT NULL AFTER `ora`,
ADD `data_scadenza` DATE NULL DEFAULT NULL AFTER `timestamp_scadenza`, 
ADD `ora_scadenza` TIME NULL DEFAULT NULL AFTER `data_scadenza`,
ADD `data_pianificazione` DATE NULL DEFAULT NULL AFTER `ora_fine`, 
ADD `ora_inizio_pianificazione` TIME NULL DEFAULT NULL AFTER `data_pianificazione`, 
ADD `ora_fine_pianificazione` TIME NULL DEFAULT NULL AFTER `ora_inizio_pianificazione`
;