ALTER TABLE `tipologie_attivita_inps` 
	ADD `codice` CHAR(32) NULL DEFAULT NULL , 
	ADD `se_quadratura` INT(1) NULL DEFAULT NULL , 
	ADD UNIQUE KEY (`codice`) ;