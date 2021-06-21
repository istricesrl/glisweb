ALTER TABLE `periodi_variazioni_attivita` ADD `token` CHAR(128) NULL DEFAULT NULL AFTER `ora_fine`, ADD KEY `token` (`token`) ;
