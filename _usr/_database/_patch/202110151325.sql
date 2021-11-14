ALTER TABLE `categorie_attivita` 
ADD `se_produzione` INT(1) NULL DEFAULT NULL AFTER `se_straordinario`, 
ADD `se_ticket` INT(1) NULL DEFAULT NULL AFTER `se_produzione`,
ADD INDEX `se_produzione` (`se_produzione`),
ADD INDEX `se_ticket` (`se_ticket`);
