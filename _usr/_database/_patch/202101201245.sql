ALTER TABLE `turni` ADD `id_pianificazione` INT NULL DEFAULT NULL AFTER `data_fine`, ADD INDEX (`id_pianificazione`) ;