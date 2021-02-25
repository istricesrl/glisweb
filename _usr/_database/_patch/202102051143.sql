ALTER TABLE `pianificazioni` 
	ADD `id_contratto` INT NULL DEFAULT NULL AFTER `nome`, 
	ADD `id_progetto` CHAR(32) NULL DEFAULT NULL AFTER `id_contratto`, 
	ADD `data_fine` DATE NULL DEFAULT NULL AFTER `id_progetto`, 
	ADD `data_ultimo_oggetto` DATE NULL DEFAULT NULL AFTER `data_fine`, 
	ADD INDEX (`id_contratto`),
	ADD INDEX (`id_progetto`);