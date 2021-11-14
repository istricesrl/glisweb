ALTER TABLE `matricole` 
ADD `id_marchio` INT NULL DEFAULT NULL AFTER `id`, 
ADD `id_produttore` INT NULL DEFAULT NULL AFTER `id_marchio`, 
ADD `serial_number` char(128) NULL DEFAULT NULL AFTER `id_produttore`, 
ADD INDEX (`serial_number`), 
ADD INDEX (`id_marchio`), 
ADD INDEX (`id_produttore`) ;
