ALTER TABLE `orari_contratti` ADD `turno` INT NULL DEFAULT '1' AFTER `id_contratto`, ADD INDEX (`turno`) ;