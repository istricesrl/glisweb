ALTER TABLE `todo` 
ADD `data_pianificazione` DATE NULL DEFAULT NULL AFTER `timestamp_pianificazione`, 
ADD `ora_pianificazione` TIME NULL DEFAULT NULL AFTER `data_pianificazione`;