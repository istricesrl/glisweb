ALTER TABLE `ruoli_progetti` 
	ADD `se_responsabile_qualita` INT(1) NULL DEFAULT NULL AFTER `nome`, 
	ADD `se_coordinatore` INT(1) NULL DEFAULT NULL AFTER `se_responsabile_qualita`,
	ADD `se_responsabile_amministrativo` INT(1) NULL DEFAULT NULL AFTER `se_coordinatore`, 
	ADD `se_responsabile_servizi` INT(1) NULL DEFAULT NULL AFTER `se_responsabile_amministrativo`, 
	ADD `se_operativo` INT(1) NULL DEFAULT NULL AFTER `se_responsabile_servizi`;