ALTER TABLE `progetti` ADD `id_pianificazione` INT NULL DEFAULT NULL AFTER `testo`, ADD KEY `id_pianificazione` (`id_pianificazione`) ;