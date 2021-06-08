ALTER TABLE `categorie_progetti` 
ADD `se_ordinario` INT(1) NULL DEFAULT NULL AFTER `nome`, 
ADD `se_straordinario` INT(1) NULL DEFAULT NULL AFTER `se_ordinario`, 
ADD KEY `se_ordinario` (`se_ordinario`),
ADD KEY `se_straordinario` (`se_straordinario`) ;